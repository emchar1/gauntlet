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
	
	# ROTATION
	if actor and move_dir.length_squared() > 0.001:
		var look_dir := Vector3(-move_dir.x, 0.0, -move_dir.y).normalized()
		var target_angle := atan2(look_dir.x, look_dir.z)
		
		actor.rotation.y = lerp_angle(
			actor.rotation.y,
			target_angle,
			0.2
		)


# Updates the movement speed.
func update_speed(new_value: float) -> void:
	speed = new_value
