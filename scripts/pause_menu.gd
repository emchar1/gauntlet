extends Node

# PROPERTIES

@onready var pause_label = $Label

var is_paused: bool = false
var blink_tween: Tween


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if blink_tween:
		blink_tween.kill()
	
	blink_tween = create_tween()
	blink_tween.set_loops()
	
	pause_label.modulate = Color.BLACK
	
	blink_tween.tween_property(
		pause_label,
		"modulate",
		Color.WHITE,
		0.75
	)
	blink_tween.tween_property(
		pause_label,
		"modulate",
		Color.BLACK,
		0.0
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		pause_label.visible = is_paused
		get_tree().paused = is_paused
