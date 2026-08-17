extends CharacterBody3D
class_name Enemy

# PROPERTIES

enum State {
	NONE, IDLE, RUN, ATTACK, HURT, DEAD
}

@export var enemy_config: EnemyConfig

@onready var animation_player = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var enemy_hp = $EnemyHP

var current_state: State

# FIXME: - Remove @export after initializing enemies from a Packed Scene.
@export var player: Player

var player_in_attack_range: bool = false

var has_spawned: bool = true
var is_slaying: bool = false
var current_hp: float


# FUNCTIONS

func _ready() -> void:
	_setup_enemy()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_process_movement()
	enemy_hp.position_hp(self)
	
	move_and_slide()


func _setup_enemy():
	enemy_hp.setup_values(enemy_config.hp)
	current_hp = enemy_config.hp
	_update_state(State.RUN)


# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta


# Movement and follow player
func _process_movement():
	if player == null:
		print("No player assigned. Assign player to enemy.")
		return
	
	if current_state != State.RUN:
		velocity.x = 0
		velocity.z = 0
		return
	
	nav_agent.target_position = player.global_position
	
	var next_nav_point = nav_agent.get_next_path_position()
	var path_dir = next_nav_point - global_position
	
	path_dir.y = 0
	path_dir = path_dir.normalized()
	
	velocity.x = path_dir.x * enemy_config.speed
	velocity.z = path_dir.z * enemy_config.speed
	
	# Rotate enemy to face player
	if path_dir.length_squared() > 0.0:
		look_at(global_position + path_dir, Vector3.UP)


# Updates the current state and animation
func _update_state(state: State):
	current_state = state
	
	match state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.ATTACK:
			animation_player.play("attack")
		_:
			animation_player.play("RESET")


# SIGNAL FUNCTIONS

# This is what registers enemy hurtbox from player's hitbox, i.e. arrow.
func damage(amount: float):
	if not has_spawned:
		return
	
	if is_slaying:
		return
	
	current_hp -= amount
	current_hp = clamp(current_hp, 0, enemy_config.hp)
	enemy_hp.update_health(current_hp)
	
	if current_hp <= 0:
		call_deferred("slay")


func slay():
	if is_slaying:
		return
	
	is_slaying = true
	turn_off_collisions()
	_update_state(State.IDLE)
	
	var tween := create_tween()
	var meshes := $Visuals.find_children("*", "MeshInstance3D", true, false)
	var dissolve_speed: float = 0.5
	
	for mesh in meshes:
		var material = mesh.get_active_material(0)
		
		if material == null:
			continue
		
		material = material.duplicate()
		mesh.material_override = material
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		
		tween.parallel().tween_property(
			material,
			"albedo_color:a",
			0.0,
			dissolve_speed
		)
		
	tween.finished.connect(queue_free)


func turn_off_collisions():
	set_collision_layer_value(GameState.COLLISION_ENEMY_BODY, false)
	set_collision_mask_value(GameState.COLLISION_PLAYER_BODY, false)
	set_collision_mask_value(GameState.COLLISION_ENEMY_BODY, false)
	set_collision_mask_value(GameState.COLLISION_SPAWNER_BODY, false)
	
	$Hurtbox.set_collision_layer_value(GameState.COLLISION_ENEMY_HURT, false)
	$Hurtbox.set_collision_mask_value(GameState.COLLISION_PLAYER_HIT, false)
	
	$Hitbox.set_collision_layer_value(GameState.COLLISION_ENEMY_HIT, false)
	$Hitbox.set_collision_mask_value(GameState.COLLISION_PLAYER_HURT, false)


# And this registers when player gets hit by enemy.
func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurtbox"):
		print("Player attacked!")


# This detector triggers when player enters enemy's PlayerDetector.
func _on_player_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true
		
		if current_state == State.RUN:
			_update_state(State.ATTACK)


# This triggers when player leaves PlayerDetector.
func _on_player_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false


# And this causes enemy to re-attack if player is still in detector.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		if player_in_attack_range:
			_update_state(State.ATTACK)
		else:
			_update_state(State.RUN)
