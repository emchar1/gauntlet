extends Area3D

# PROPERTIES

var cooldown: float = 20.0
var damage: float = 2.0


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setup(pos: Vector3):
	global_position = Vector3(pos.x, 0.05, pos.z)
