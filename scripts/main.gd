extends Node3D

# PROPERTIES

@export var player_scene: PackedScene

@onready var level_map = $LevelMap
@onready var hud = $Hud
@onready var hud_final = $HudFinal

# Player Properties
@onready var players = $Players
@onready var spawner = $Players/MultiplayerSpawner


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(AudioData.Music.BGM)
	
	# TODO: - Multiplayer capabilities
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	if multiplayer.is_server():
		_spawn_player(multiplayer.get_unique_id())
		print("Server Mode: ON (listening for connections...)")


func _on_peer_connected(peer_id: int):
	if not multiplayer.is_server():
		return
	
	_spawn_player(peer_id)


func _spawn_player(peer_id: int):
	var player := player_scene.instantiate() as Player
	
	if player == null:
		print("Main: Error creating player.")
		return
	
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)
	players.add_child(player)
	
	# Signal connections
	player.hp_did_update.connect(hud.hp_did_update)
	player.died.connect(hud.player_died)
	player.resurrect_ready.connect(hud.player_resurrect_ready)
	player.did_resurrect.connect(hud.player_did_resurrect)
	player.resurrect_timer_did_update.connect(hud.resurrect_timer_did_update)
	player.final_death.connect(level_map.show_final_label)
	player.final_death.connect(hud.player_died_finally)
	player.final_death.connect(hud_final.show_final_results)
	
	player.input_component.gamepad_aiming_did_update.connect(
		level_map.update_labels
	)
	
	player.combat_component.timers_did_update.connect(
		hud.special_did_update
	)
	
	player.relic_component.timer_did_update.connect(
		hud.relic_did_update
	)
	
	hud.special_ready.connect(player.special_is_ready)
	hud.relic_ready.connect(player.relic_is_ready)
