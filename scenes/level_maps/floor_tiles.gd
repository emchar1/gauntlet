extends Node3D


# PROPERTIES

# Tile Countss
@export var rows: int = 10
@export var cols: int = 10

# Tile Attributes
var color: Color = Color.DARK_SLATE_GRAY
var width: float = 3.0
var height: float = 1.1
var depth: float = 2.0
var gap: float = 0.1


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_tiles()


func _generate_tiles():
	var tile_position = Vector3(width, 0.0, depth) * (1 + gap)
	var tile_offset = Vector3(width, 0.0, depth) * (0.5 + gap)
	
	for x in range(rows):
		for z in range(cols):
			var tile := MeshInstance3D.new()
			var mesh := BoxMesh.new()
			var material := StandardMaterial3D.new()
			
			material.albedo_color = color.lightened(randf_range(-0.1, 0.1))
			mesh.size = Vector3(width, height, depth)
			tile.mesh = mesh
			tile.position = (tile_position * Vector3(x, 0.0, z)) + tile_offset
			tile.material_override = material
			
			add_child(tile)
