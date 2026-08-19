extends CharacterBody3D
class_name Player


# PROPERTIES

enum MoveState {
	IDLE, RUN, HURT, DEAD
}
}

# Components
@onready var animation_component = %AnimationComponent
@onready var combat_component = %CombatComponent
@onready var dodge_component = %DodgeComponent
@onready var input_component = %InputComponent
@onready var movement_component = %MovementComponent
@onready var bow = %Bow

@onready var aiming_l = $AimingReticleL
@onready var aiming_r = $AimingReticleR
var aiming_tween: Tween

var move_state: MoveState
var attack_state: State
var facing_dir := Vector2.RIGHT


# FUNCTIONS

func _ready() -> void:
	move_state = MoveState.IDLE
	attack_state = State.NONE
	
	combat_component.set_ability_timers()
	combat_component.attack_executed.connect(_helper_attack_executed)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_player_move()
	_update_facing()
	_update_aiming_reticle()
	_player_attack()
	
	move_and_slide()


# HELPER FUNCTIONS

# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta


# Player movement function.
func _player_move():
	input_component.read_movement()
	
	movement_component.move_dir = input_component.move_direction
	movement_component.update_movement(self)
	
	if movement_component.is_moving:
		_update_move_state(MoveState.RUN)
	else:
		_update_move_state(MoveState.IDLE)


# Updates the direction player is facing based on if aiming vs movement
func _update_facing() -> void:
	if input_component.charge_pressed:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = target_angle
		
	elif input_component.charge_held:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.02)
		
	elif combat_component.is_aiming:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.5)
		
	elif movement_component.is_moving:
		var target_angle := _get_target_angle(-input_component.move_direction)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.5)


func _update_aiming_reticle():
	if input_component.charge_pressed:
		if aiming_tween:
			aiming_tween.kill()
		
		var speed: float = 0.5
		
		aiming_tween = create_tween()
		aiming_tween.set_parallel(true)
		aiming_tween.tween_property(aiming_l, "transparency", 0.0, speed)
		aiming_tween.tween_property(aiming_r, "transparency", 0.0, speed)
		aiming_tween.tween_property(aiming_l, "rotation:y", 0.0, speed)
		aiming_tween.tween_property(aiming_r, "rotation:y", 0.0, speed)
		aiming_tween.tween_property(aiming_l, "texture:height", 20, speed)
		aiming_tween.tween_property(aiming_r, "texture:height", 20, speed)
		
	elif input_component.charge_released:
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
	input_component.read_combat()
	input_component.read_aiming(self)
	
	if input_component.main_pressed:
		#if combat_component.start_attack(self):
		_update_attack_state(State.ATTACK)
		
	# Immediately snaps to direction of movement if attack button is released.
	elif input_component.main_released:
		combat_component.is_aiming = false


# Updates the move state and animation
func _update_move_state(state: MoveState):
	if move_state == state:
		return
	
	move_state = state
	animation_component.play_locomotion(state)


# Updates the attack state and animation
func _update_attack_state(state: State):
	# Prevents locking when holding down the attack button.
	if attack_state == state:
		return
	
	attack_state = state
	animation_component.play_combat(state)


# Retrieves the target angle based on the aim direction.
func _get_target_angle(direction: Vector2) -> float:
	var aim_dir := GameState.map_2d_to_3d(direction)
	return atan2(aim_dir.x, aim_dir.z)


# ANIMATION PLAYER CALLBACK FUNCTIONS

func attack_start_finished():
	animation_component.continue_attack(true)


func attack_loop_started():
	# Quickly snap to mouse pointer direction on first attack press.
	if not combat_component.is_aiming:
		var target_angle := _get_target_angle(-input_component.aim_direction)
		rotation.y = target_angle
	
	combat_component.is_aiming = true
	combat_component.execute_attack(self)
	#combat_component.update_ability_timers(0)


func attack_loop_finished():
	animation_component.continue_attack(input_component.main_pressed)


func attack_end_finished():
	combat_component.is_aiming = false
	#combat_component.end_attack(self)
	_update_attack_state(State.NONE)


# SIGNAL CALLBACKS

# Reorients the facing_dir so arrows always move towards mouse position.
func _helper_attack_executed(ability: Ability):
	match ability:
		combat_component.quick_arrow:
			# Updates facing dir to direction of mouse pointer
			#facing_dir = input_component.aim_direction
			
			# Updates facing dir to player's actual facing direction
			facing_dir = GameState.map_3d_to_2d(
				-global_transform.basis.z
			).normalized()
