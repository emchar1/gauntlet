extends CharacterBody3D
class_name Enemy

# PROPERTIES



# FUNCTIONS

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	move_and_slide()


# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
