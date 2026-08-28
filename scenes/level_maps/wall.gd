@tool
extends StaticBody3D
class_name Wall


# PROPERTIES

@export var size: Vector2 = Vector2(2, 1):
	set(value):
		size = value
		_update_size()

@export var collision_padding: float = 2:
	set(value):
		collision_padding = value
		_update_size()

@export var wall_height: float = 10:
	set(value):
		wall_height = value
		_update_size()

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()


func _update_size():
	if not is_instance_valid(mesh) or not is_instance_valid(collision_shape):
		return
	
	# Update mesh size
	var box_mesh := mesh.mesh as BoxMesh
	if box_mesh:
		mesh.position.y = wall_height / 2.0
		box_mesh.size = Vector3(size.x, wall_height, size.y)
	
	# Update collision shape size
	var box_shape := collision_shape.shape as BoxShape3D
	if box_shape:
		collision_shape.position.y = wall_height / 2.0
		box_shape.size = Vector3(
			size.x + (collision_padding * 2.0 if size.y > 1 else 0.0),
			wall_height,
			size.y + (collision_padding * 2.0 if size.x > 1 else 0.0)
		)
