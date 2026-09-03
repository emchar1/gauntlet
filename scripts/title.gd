extends CanvasLayer

# PROPERTIES

@onready var fade_rect = $FadeRect
@onready var start_button = $StartButton
@onready var settings_button = $SettingsButton

var fade_tween: Tween


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_button_pressed() -> void:
	start_button.disabled = true
	settings_button.disabled = true
	
	AudioManager.play(AudioData.AudioKey.SPLAT)
	
	if fade_tween:
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		2.0
	)
	
	await fade_tween.finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_button_pressed() -> void:
	start_button.disabled = true
	settings_button.disabled = true
	
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
