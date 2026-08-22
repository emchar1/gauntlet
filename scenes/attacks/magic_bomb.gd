extends Area3D


# PROPERTIES

var initial_position: Vector2
var direction := Vector2.ZERO
var color: Color

var damage: float = 2
var speed: float = 10
var knockback: float = 0
var max_distance: float = 40

var initial_velocity: float = 0
var vertical_velocity: float = 0
var weight: float = 3

var obeys_gravity: bool = true
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
func _process(delta: float) -> void:
	pass


func setup(pos: Vector3, dir: Vector2):
	pass
	#var forward := GameState.map_2d_to_3d(dir).normalized()
	#var offset := Vector3(0.5 * forward.z, 1.0, -0.5 * forward.x)
	#
	position = pos
	#initial_position = GameState.map_3d_to_2d(pos)
	#direction = dir
	#rotation.y = -direction.angle() - (PI / 2.0)
	#vertical_velocity = initial_velocity


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurtbox"):
		print("damage")
		area.get_parent().damage(damage, Vector2.ZERO, 0)


func _did_explode():
	queue_free()
