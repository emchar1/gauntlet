extends CharacterBody3D
class_name Player


# PROPERTIES

signal died

enum MoveState {
	IDLE, RUN, DODGE, HURT, DEAD
}

enum AttackState {
	NONE, STARTING, CHARGED, FIRING, ENDING
}

@export var hp_max := 100.0
var hp_current: float

# Components
@onready var animation_component = %AnimationComponent
@onready var combat_component = %CombatComponent
@onready var dodge_component = %DodgeComponent
@onready var input_component = %InputComponent
@onready var movement_component = %MovementComponent
@onready var bow = %Bow

@onready var resurrect_timer = $ResurrectTimer
@onready var hp_bar = $HPBar
@onready var aiming_l = $AimingReticleL
@onready var aiming_r = $AimingReticleR
var aiming_tween: Tween

var move_state: MoveState
var attack_state: AttackState
var facing_dir := Vector2.RIGHT

# Too many bools
var is_invincible: bool = false
var is_resurrecting: bool = false

# Ability-handling Properties
var selected_ability: Ability
var current_ability: Ability
var last_ability: Ability
var can_fire_charged: bool = false


# INIT FUNCTIONS

func _ready() -> void:
	move_state = MoveState.IDLE
	attack_state = AttackState.NONE
	
	selected_ability = combat_component.quick_arrow
	current_ability = selected_ability
	last_ability = selected_ability
	
	hp_bar.setup_values(hp_max)
	hp_current = hp_max
	
	combat_component.set_ability_timers()
	combat_component.attack_executed.connect(_helper_attack_executed)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	# Read input and update timers independently of player state.
	input_component.read_input(self)
	combat_component.update_ability_timers(delta)
	
	_player_move()
	_update_facing()
	_update_aiming_reticle()
	_player_attack()
	
	if movement_component.is_dodging:
		movement_component.traverse_dodge(self)
	
	if move_state == MoveState.DEAD:
		if resurrect_timer.is_stopped() and input_component.start_pressed:
			_resurrect()
	
	hp_bar.position_hp(self)
	
	move_and_slide()
	
	# MUST go AFTER move_and_slide()
	if is_resurrecting and is_on_floor():
		_apply_resurrection_knockback()
		GameState.shake_main_camera(3.5, 30)
		is_resurrecting = false


# PUBLIC FUNCTIONS

func update_hp(amount: float):
	if amount < 0 and is_invincible:
		return
	
	hp_current += amount
	hp_current = clamp(hp_current, 0, hp_max)
	hp_bar.update_health(hp_current)
	
	if hp_current <= 0:
		_die()
		return
	
	if amount < 0:
		_reset_attack()
		_update_move_state(MoveState.HURT)
		_update_iframes()


func stop_movement():
	velocity.x = 0
	velocity.z = 0


# HELPER FUNCTIONS

# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if global_position.y <= -450:
		_die()


# Adds iframes to the player.
func _update_iframes():
	is_invincible = true
	await get_tree().create_timer(0.8).timeout
	is_invincible = false


# Player movement function.
func _player_move():
	if move_state == MoveState.DODGE:
		return
	
	if move_state == MoveState.HURT or move_state == MoveState.DEAD:
		stop_movement()
		return
	
	movement_component.move_dir = input_component.move_direction
	movement_component.update_movement(self)
	
	# Dodging
	if input_component.dodge_pressed:
		_dodge_begin()
	elif movement_component.is_moving:
		_update_move_state(MoveState.RUN)
	else:
		_update_move_state(MoveState.IDLE)


# Updates the direction player is facing based on if aiming vs movement
func _update_facing() -> void:
	if move_state == MoveState.DODGE \
	or move_state == MoveState.HURT \
	or move_state == MoveState.DEAD:
		return
	
	if input_component.charge_pressed:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = target_angle
		
	elif input_component.charge_held and can_fire_charged:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.02)
		
	elif combat_component.is_aiming:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.5)
		
	elif movement_component.is_moving:
		var target_angle := _get_target_angle(-input_component.move_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.5)


func _update_aiming_reticle():
	if move_state == MoveState.DODGE \
	or move_state == MoveState.HURT \
	or move_state == MoveState.DEAD:
		return
	
	if input_component.charge_pressed:
		_set_aiming()
		
	elif input_component.charge_released:
		_reset_aiming()


func _set_aiming():
	if aiming_tween:
			aiming_tween.kill()
	
	var speed := 0.5
	
	aiming_tween = create_tween()
	aiming_tween.set_parallel(true)
	aiming_tween.tween_property(aiming_l, "transparency", 0.0, speed)
	aiming_tween.tween_property(aiming_r, "transparency", 0.0, speed)
	aiming_tween.tween_property(aiming_l, "rotation:y", 0.0, speed)
	aiming_tween.tween_property(aiming_r, "rotation:y", 0.0, speed)
	aiming_tween.tween_property(aiming_l, "texture:height", 20, speed)
	aiming_tween.tween_property(aiming_r, "texture:height", 20, speed)


func _reset_aiming():
	if aiming_tween:
		aiming_tween.kill()
		
	aiming_l.transparency = 1.0
	aiming_r.transparency = 1.0
	aiming_l.rotation.y = 8.0 * PI / 180
	aiming_r.rotation.y = -8.0 * PI / 180
	aiming_l.texture.height = 1
	aiming_r.texture.height = 1


# Player attack function.
func _player_attack():
	if move_state == MoveState.HURT or move_state == MoveState.DEAD:
		return
	
	if move_state == MoveState.DODGE:
		if input_component.special_pressed:
			combat_component.execute_attack(self, combat_component.magic_bomb)
		return
	
	# Basic Attacks
	if input_component.charge_pressed:
		selected_ability = combat_component.charged_arrow
		current_ability = selected_ability
		_update_attack_state(AttackState.STARTING)
		
	elif input_component.charge_released:
		can_fire_charged = false
		selected_ability = combat_component.quick_arrow
		current_ability = selected_ability
		_update_attack_state(AttackState.ENDING)
		
	elif input_component.main_pressed:
		if selected_ability == combat_component.charged_arrow:
			if can_fire_charged:
				current_ability = selected_ability
				_update_attack_state(AttackState.FIRING)
		else:
			current_ability = selected_ability
			_update_attack_state(AttackState.FIRING)
		
	elif input_component.main_released:
		combat_component.is_aiming = false
		
	# Magical Attacks
	elif input_component.special_pressed:
		if can_fire_charged:
			current_ability = combat_component.magic_arrow
			_update_attack_state(AttackState.FIRING)
		else:
			combat_component.execute_attack(self, combat_component.magic_bomb)


# Updates the move state and animation
func _update_move_state(state: MoveState):
	if move_state == state:
		return
	
	move_state = state
	animation_component.play_locomotion(state)


# Updates the attack state and animation
func _update_attack_state(state: AttackState):
	# Prevents locking when holding down the attack button.
	if attack_state == state and last_ability == current_ability:
		return
	
	if not combat_component._can_use(current_ability):
		# If you don't set last_ability == null, function will always return
		# via above guard check due to last_ability = current_ability!
		# This is especially needed for attacks with a cooldown, i.e. the
		# magic arrow.
		last_ability = null
		return
	
	last_ability = current_ability
	
	var is_basic_charged = current_ability == combat_component.charged_arrow
	var is_magic_charged = current_ability == combat_component.magic_arrow
	var is_charged = is_basic_charged or is_magic_charged
	
	attack_state = state
	animation_component.play_combat(state, is_charged)


# Resets attack_state, esp useful for dodge movement.
func _reset_attack():
	attack_state = AttackState.NONE
	selected_ability = combat_component.quick_arrow
	current_ability = selected_ability
	can_fire_charged = false
	combat_component.is_aiming = false
	_reset_aiming()
	animation_component.play_combat(AttackState.NONE, false)


# Retrieves the target angle based on the aim direction.
func _get_target_angle(direction: Vector2) -> float:
	var aim_dir := GameState.map_2d_to_3d(direction)
	return atan2(aim_dir.x, aim_dir.z)


# Handle death.
func _die():
	if move_state == MoveState.DEAD:
		return
	
	_reset_attack()
	_update_move_state(MoveState.DEAD)
	resurrect_timer.start()


func _resurrect():
	if move_state != MoveState.DEAD:
		print("Can't resurrect. Not dead.")
		return
	
	if is_resurrecting:
		return
	
	is_resurrecting = true
	
	dissolve_body($Visuals, Color.BLACK, 3.0)
	
	hp_current = hp_max
	hp_bar.update_health(hp_current)
	_update_move_state(MoveState.IDLE)
	
	# Resurrect from above
	var res_position = global_position
	
	global_position = res_position + Vector3.UP * 30
	velocity.y = 0
	
	# Reset ability timers
	combat_component.set_ability_timers()


func dissolve_body(
	visuals: Node3D,
	dissolve_color: Color,
	dissolve_speed: float
):
	var visuals_copy = visuals.duplicate()
	var world_transform := visuals.global_transform
	
	var tween := create_tween()
	var meshes := visuals_copy.find_children("*", "MeshInstance3D", true, false)
	
	get_parent().add_child(visuals_copy)
	visuals_copy.global_transform = world_transform
	
	# Dissolve by fading to color, then out by going through all meshes.
	for mesh in meshes:
		var material = mesh.get_active_material(0)
		
		if material == null:
			continue
		
		material = material.duplicate()
		mesh.material_override = material
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		
		tween.parallel().tween_property(
			material,
			"albedo_color",
			dissolve_color,
			dissolve_speed
		)
		
		tween.parallel().tween_property(
			material,
			"albedo_color:a",
			0.0,
			dissolve_speed
		)
		
	tween.finished.connect(visuals_copy.queue_free)


# ANIMATION PLAYER: ATTACK - CALLBACK FUNCTIONS

func attack_start_finished():
	can_fire_charged = true


func attack_loop_started():
	# Quickly snap to mouse pointer direction on first attack press.
	if not combat_component.is_aiming:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = target_angle
	
	combat_component.is_aiming = true
	combat_component.execute_attack(self, current_ability)


func attack_loop_finished():
	if selected_ability == combat_component.charged_arrow:
		_update_attack_state(AttackState.CHARGED)
	else:
		if input_component.main_pressed:
			_update_attack_state(AttackState.FIRING)
		else:
			_update_attack_state(AttackState.ENDING)


func attack_end_finished():
	combat_component.is_aiming = false
	current_ability = selected_ability
	_update_attack_state(AttackState.NONE)


# ANIMATION PLAYER: DODGE - CALLBACK FUNCTIONS

func _dodge_begin():
	# Used to prevent a bug where if dodge button spammed, input is softlocked.
	if animation_component.is_dodge_animation_playing():
		return
	
	_reset_attack()
	_update_move_state(MoveState.DODGE)


func _dodge_launch():
	movement_component.start_dodge(self)
	
	# Must come AFTER start_dodge()!
	rotation.y = -movement_component.dodge_dir.angle() - PI / 2.0


func _dodge_land():
	movement_component.stop_dodge(self)


func _dodge_recover():
	_update_move_state(MoveState.IDLE)


# ANIMATION PLAYER: HURT/DEAD - CALLBACK FUNCTIONS

func _hurt_finished():
	_update_move_state(MoveState.IDLE)


func _dead_finished():
	died.emit()


# SIGNAL CONNECTED CALLBACK FUNCTIONS

# Reorients the facing_dir so arrows always move towards mouse position.
func _helper_attack_executed(ability: Ability):
	var normalized_global_transform_basis_z := GameState.map_3d_to_2d(
		-global_transform.basis.z
	).normalized()
	
	match ability:
		combat_component.quick_arrow:
			# Updates facing dir to direction of mouse pointer
			#facing_dir = input_component.aim_direction
			
			# Updates facing dir to player's actual facing direction
			facing_dir = normalized_global_transform_basis_z
		combat_component.charged_arrow:
			facing_dir = normalized_global_transform_basis_z
		combat_component.magic_arrow:
			facing_dir = normalized_global_transform_basis_z


# Not really a signal callback, but is like one because you can check for 
# overlapping areas on the Resurrectbox area3d.
func _apply_resurrection_knockback():
	var areas = $Resurrectbox.get_overlapping_areas()
	
	for area in areas:
		if area.is_in_group("hurtbox"):
			var enemy = area.get_parent() as Enemy
			
			if not enemy:
				return
			
			var direction_to_enemy = enemy.global_position - global_position
			var knockback_direction = GameState.map_3d_to_2d(direction_to_enemy)
			
			enemy.damage(0.0, knockback_direction, 6.0, 2)
