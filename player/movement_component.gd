extends Node
class_name MovementComponent


# PROPERTIES

@export var speed: float = 10.0

var move_dir := Vector2.ZERO
var is_moving := false


# FUNCTION

# Updates the movement velocity of the specified actor (player, enemy, etc.)
func update_movement(actor: CharacterBody3D) -> void:
	actor.velocity.x = move_dir.x * speed
	actor.velocity.z = move_dir.y * speed
	
	is_moving = move_dir != Vector2.ZERO


# Updates the movement speed.
func update_speed(new_value: float) -> void:
	speed = new_value
