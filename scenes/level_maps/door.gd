@tool
extends Node3D


# PROPERTIES

@export var is_open: bool = true:
	set(value):
		is_open = value
		set_doorway(value)

@onready var doorway = $Doorway

var door_tween: Tween


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_doorway()


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


# HELPER FUNCTIONS

# Just a setter function, does not animate the opening door.
func _update_doorway():
	if not is_instance_valid(doorway):
		return
	
	doorway.position.y = -8.0 if is_open else 0.0
