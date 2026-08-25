extends Node
class_name MovementComponent


# PROPERTIES

@export var speed: float = 12.0
@export var dodge_speed: float = 24.0

var move_dir := Vector2.ZERO
var dodge_dir := Vector2.ZERO
var is_moving := false
var is_dodging := false


# MOVEMENT FUNCTIONS

# Updates the movement velocity of the specified actor (player, enemy, etc.)
func update_movement(actor: CharacterBody3D) -> void:
	actor.velocity.x = move_dir.x * speed
	actor.velocity.z = move_dir.y * speed
	
	is_moving = move_dir != Vector2.ZERO


# Updates the movement speed.
func update_speed(new_value: float) -> void:
	speed = new_value


# DODGE FUNCTIONS

func start_dodge(actor: CharacterBody3D) -> void:
	is_dodging = true
	
	if is_moving:
		dodge_dir = move_dir
		
	# Sets dodge_dir to actor's facing direction, normalized (gives movement).
	else:
		dodge_dir = GameState.map_3d_to_2d(
			-actor.global_transform.basis.z.normalized()
		)
	
	
	
	# TODO: - need separate layer for dodging
	actor.set_collision_mask_value(GameState.COLLISION_ENEMY_BODY, false)


func traverse_dodge(actor: CharacterBody3D) -> void:
	actor.velocity.x = dodge_dir.x * dodge_speed
	actor.velocity.z = dodge_dir.y * dodge_speed


func stop_dodge(actor: CharacterBody3D) -> void:
	is_dodging = false
	
	dodge_dir = Vector2.ZERO
	actor.velocity.x = 0
	actor.velocity.z = 0
	
	
	
	# TODO: - need separate layer for dodging
	actor.set_collision_mask_value(GameState.COLLISION_ENEMY_BODY, true)
