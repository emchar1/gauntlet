extends Node3D

# PROPERTIES

@export var is_open: bool = true
@onready var doorway = $Doorway

var door_tween: Tween


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doorway.position.y = -8.0 if is_open else 0.0


# Opens/closes the doorway.
func set_doorway(should_open: bool):
	if is_open == should_open:
		return
	
	is_open = should_open
	
	if door_tween:
		door_tween.kill()
	
	door_tween = create_tween()
	door_tween.tween_property(
		doorway,
		"position:y",
		-8.0 if should_open else 0.0,
		0.5
	)
