@tool
extends StaticBody3D
class_name Floor

# PROPERTIES

@export var size: Vector2 = Vector2(10, 10):
	set(value):
		size = value
		_update_size()

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var floor_tiles = $FloorTiles


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()


func _update_size():
	if not is_instance_valid(mesh) \
	or not is_instance_valid(collision_shape) \
	or not is_instance_valid(floor_tiles):
		return
	
	# Update mesh size
	var box_mesh := mesh.mesh as BoxMesh
	if box_mesh:
		box_mesh.size = Vector3(size.x, 1, size.y)
	
	# Update collision shape size
	var box_shape := collision_shape.shape as BoxShape3D
	if box_shape:
		box_shape.size = Vector3(size.x, 1, size.y)
	
	# Reposition floor tiles
	floor_tiles.position.x = -size.x / 2
	floor_tiles.position.z = -size.y / 2
	
	# Update tile counts
	floor_tiles.set_tile_counts(int(size.x), int(size.y))
