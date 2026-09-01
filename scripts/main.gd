extends Node3D

# PROPERTIES

@onready var player = $Player
@onready var level_map = $LevelMap


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.final_death.connect(level_map.show_final_label)
	AudioManager.play_music(AudioData.Music.BGM_CORRIDOR)
