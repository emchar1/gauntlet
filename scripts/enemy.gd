extends CharacterBody3D
class_name Enemy

# PROPERTIES

enum State {
	NONE, IDLE, RUN, ATTACK, HURT, DEAD
}

@onready var animation_player = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D

@export var speed := 8.0

var current_state: State

# FIXME: - Remove @export after initializing enemies from a Packed Scene.
@export var player: Player

var player_in_attack_range: bool = false


# FUNCTIONS

func _ready() -> void:
	_update_state(State.RUN)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_process_movement()
	
	move_and_slide()


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
	
	velocity.x = path_dir.x * speed
	velocity.z = path_dir.z * speed
	
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
	print("damaged by arrow, amt: ", amount)


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
