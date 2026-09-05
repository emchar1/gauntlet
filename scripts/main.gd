extends Node3D

# PROPERTIES

@onready var player = $Player
@onready var level_map = $LevelMap
@onready var hud = $Hud
@onready var hud_final = $HudFinal
@onready var combat_component = $Player/Components/CombatComponent


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.final_death.connect(level_map.show_final_label)
	player.hp_did_update.connect(hud.hp_did_update)
	player.died.connect(hud.player_died)
	player.final_death.connect(hud.player_died_finally)
	player.resurrect_ready.connect(hud.player_resurrect_ready)
	player.did_resurrect.connect(hud.player_did_resurrect)
	player.resurrect_timer_did_update.connect(hud.resurrect_timer_did_update)
	player.final_death.connect(hud_final.show_final_results)
	combat_component.timers_did_update.connect(hud.special_did_update)
	
	AudioManager.play_music(AudioData.Music.BGM)
