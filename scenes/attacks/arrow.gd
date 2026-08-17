extends Area3D


# PROPERTIES

var initial_position: Vector2
var direction := Vector2.ZERO
var color: Color

var damage: float = 2
var speed: float = 10
var max_distance: float = 40

var initial_velocity: float = 0
var vertical_velocity: float = 0
var weight: float = 3

var piercing: bool = false
var explodes: bool = false
var usable_while_dodging: bool = false

# Ensures quick and charged arrows cannot damage multiple overlapping enemies.
var has_hit := false

# Stops an arrow, like if it hits the world
var is_inert := false


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_inert:
		_fire(delta)


# Call this after instantiation to configure BEFORE adding to the scene tree.
func setup(pos: Vector3, dir: Vector2):
	var forward := GameState.map_2d_to_3d(dir).normalized()
	var offset := Vector3(0.5 * forward.z, 1.0, -0.5 * forward.x)
	
	position = pos + offset
	initial_position = GameState.map_3d_to_2d(pos)
	direction = dir
	rotation.y = -direction.angle() - (PI / 2.0)
	vertical_velocity = initial_velocity


func _fire(delta: float):
	# Horizontal velocity
	var velocity_3d := GameState.map_2d_to_3d(direction) * speed
	
	# Apply gravity to vertical velocity
	vertical_velocity -= gravity * weight * delta
	velocity_3d.y = vertical_velocity
	
	# Move
	global_position += velocity_3d * delta
	
	# Point arrow along its actual trajectory
	if velocity_3d.length_squared() > 0.001:
		look_at(global_position + velocity_3d, Vector3.UP)
	
	var current_position = GameState.map_3d_to_2d(global_position)
	var distance_traveled = initial_position.distance_to(current_position)
	
	if max_distance > 0 and distance_traveled > max_distance:
		queue_free()


# SIGNAL CALLBACK FUNCTIONS

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("world"):
		dissolve_arrow()


# Dissolves and queue_free's the arrow.
func dissolve_arrow():
	if is_inert:
		return
	
	is_inert = true
	
	var meshes := $Visuals.find_children("*", "MeshInstance3D", true, false)
	
	for mesh in meshes:
		var tween := create_tween()
		var material = mesh.get_active_material(0)
		var dissolve_speed: float = 0.5
		
		if material == null:
			continue
		
		material = material.duplicate()
		mesh.material_override = material
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		
		tween.tween_property(
			material,
			"albedo_color",
			Color.BLACK,
			dissolve_speed
		)
		
		tween.tween_property(
			material,
			"albedo_color:a",
			0.0,
			dissolve_speed
		)
		
		tween.finished.connect(queue_free)


func _on_area_entered(area: Area3D) -> void:
	if has_hit and not piercing:
		return
	
	if area.is_in_group("hurtbox"):
		has_hit = true
		area.get_parent().damage(damage)
	
		# TODO: - Build for mobs
		#if area.get_parent() is Mob:
			#area.get_parent().speed *= 0.5
		
		if not piercing:
			queue_free()
