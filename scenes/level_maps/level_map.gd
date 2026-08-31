extends Node3D

# PROPERTIES

@onready var final_label = $Instructions/Label10


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_final_label():
	var tween = create_tween()
	tween.tween_property(
		final_label,
		"transparency",
		0.0,
		3.0
	).set_delay(2.0)
