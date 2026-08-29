@tool
extends Node3D


# PROPERTIES

# Tile Counts
var rows: int = 10
var cols: int = 10

# Tile Attributes
var color: Color = Color.DARK_SLATE_GRAY
var size = Vector3(1.9, 1.1, 1.9)
var gap: float = 0.1


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_tiles()


# Updates tile counts and regenerates tiles.
func set_tile_counts(new_rows: int, new_cols: int):
	rows = new_rows
	cols = new_cols
	
	for child in get_children():
		child.queue_free()
	
	_generate_tiles()


# HELPER FUNCTIONS

func _generate_tiles():
	var tile_position = Vector3(size.x + gap, 0.0, size.z + gap)
	var tile_offset = 0.5 * tile_position
	
	for x in range(rows):
		for z in range(cols):
			var tile := MeshInstance3D.new()
			var mesh := BoxMesh.new()
			var material := StandardMaterial3D.new()
			
			material.albedo_color = color.lightened(randf_range(-0.1, 0.1))
			mesh.size = size
			tile.mesh = mesh
			tile.position = (tile_position * Vector3(x, 0.0, z)) + tile_offset
			tile.material_override = material
			
			add_child(tile)
