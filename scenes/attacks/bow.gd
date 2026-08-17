extends Node3D


# PROPERTIES

const BOW_RADIUS := 0.1
const RING_SIDES := 6
const CURVE_SAMPLES := 24

@onready var curve_path: Path3D = $CurvePath
@onready var bow_mesh: MeshInstance3D = $BowMeshIgnoreTheWarning


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_bow_mesh()


# Draws the bow mesh using the CurvePath created in scene editor.
func _generate_bow_mesh():
	var curve := curve_path.curve
	var curve_length := curve.get_baked_length()
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	
	for i in range(CURVE_SAMPLES):
		var t := float(i) / float(CURVE_SAMPLES - 1)
		var distance := t * curve_length
		var _transform := curve.sample_baked_with_rotation(distance)
		var center := _transform.origin
		
		for j in range(RING_SIDES):
			var angle := TAU * float(j) / float(RING_SIDES)
			var offset := Vector3(
				cos(angle) * BOW_RADIUS,
				sin(angle) * BOW_RADIUS,
				0.0
			)
			vertices.append(center + _transform.basis * offset)
	
	for i in range(CURVE_SAMPLES - 1):
		var current_ring := i * RING_SIDES
		var next_ring := (i + 1) * RING_SIDES
		
		for j in range(RING_SIDES):
			var next_j := (j + 1) % RING_SIDES
			indices.append(current_ring + j)
			indices.append(next_ring + j)
			indices.append(next_ring + next_j)
			indices.append(current_ring + j)
			indices.append(next_ring + next_j)
			indices.append(current_ring + next_j)
	
	var array_mesh := ArrayMesh.new()
	var arrays := []
	
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	array_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_TRIANGLES,
		arrays
	)
	
	bow_mesh.mesh = array_mesh
	
	# Adds color to the bow.
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.SADDLE_BROWN
	bow_mesh.material_override = material
