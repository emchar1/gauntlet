extends Area3D


# PROPERTIES

var initial_position: Vector2
var direction := Vector2.ZERO
var color: Color

var damage: float = 2
var speed: float = 40
var max_distance: float = 40

var initial_velocity: float = 6
var vertical_velocity: float = 0

var piercing: bool = false
var explodes: bool = false
var usable_while_dodging: bool = false

# Ensures quick and charged arrows cannot damage multiple overlapping enemies.
var has_hit := false


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_fire(delta)


# Call this after instantiation to configure BEFORE adding to the scene tree.
func setup(pos: Vector2, dir: Vector2):
	position = GameState.map_2d_to_3d(pos)
	initial_position = pos
	direction = dir
	#rotation.y = -direction.angle()
	vertical_velocity = initial_velocity


func _fire(delta: float):
	# Horizontal velocity
	var velocity_3d := GameState.map_2d_to_3d(direction) * speed
	
	# Apply gravity to vertical velocity
	vertical_velocity -= gravity * delta
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


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Walls":
		queue_free()


func _on_area_entered(area: Area2D) -> void:
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
