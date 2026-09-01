extends Node


# PROPERTIES

@onready var close_button = $CloseButton
@onready var music_slider = $MusicSlider
@onready var sfx_slider = $SFXSlider
@onready var music = $Music
@onready var sound = $Sound


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_slider.value = GameState.music_volume
	sfx_slider.value = GameState.sfx_volume
	music.play()


func _on_master_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	sound.play()


func _on_music_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	GameState.music_volume = value


func _on_sfx_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	GameState.sfx_volume = value
	sound.play()


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
