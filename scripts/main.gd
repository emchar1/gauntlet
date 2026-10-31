extends Node3D

# PROPERTIES

@export var player_scene: PackedScene
@export var hud_scene: PackedScene

@onready var level_map = $LevelMap
@onready var hud_final = $HudFinal

# Player Properties
@onready var players = $Players
@onready var huds = $Huds


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(AudioData.Music.BGM)
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	players.child_entered_tree.connect(_on_player_entered)
	
	if multiplayer.is_server():
		# Don't do anything. Host player gets spawned in _client_main_ready()
		print("Server Mode: ON (listening for connections...)")
	else:
		_client_main_ready.rpc_id(1)
		print("Client: sent ready RPC to host")


# MULTIPLAYER FUNCTIONS

# Remote Procedure Call (RPC) requested by a client; server executes function.
@rpc("any_peer", "reliable")
func _client_main_ready():
	if not multiplayer.is_server():
		return
	
	var peer_id := multiplayer.get_remote_sender_id()
	_spawn_host_player()
	
	if not players.has_node(str(peer_id)):
		_spawn_player(peer_id)


func _on_peer_connected(peer_id: int):
	if not multiplayer.is_server():
		return
	
	print("Peer connected; waiting for client Main to be ready: ", peer_id)


func _on_player_entered(node: Node) -> void:
	var player = node as Player
	
	if player:
		_spawn_hud.call_deferred(player)


# PLAYER SPAWNING FUNCTIONS

func _spawn_host_player():
	var host_id := multiplayer.get_unique_id()
	
	if not players.has_node(str(host_id)):
		_spawn_player(host_id)


func _spawn_player(peer_id: int):
	var player := player_scene.instantiate() as Player
	
	if player == null:
		print("Main: Error creating player.")
		return
	
	player.setup(peer_id)
	players.add_child(player)
	
	# Signal connections
	player.final_death.connect(level_map.show_final_label)
	player.final_death.connect(hud_final.show_final_results)
	
	player.input_component.gamepad_aiming_did_update.connect(
		level_map.update_labels
	)


func _spawn_hud(player: Player) -> void:
	var hud := hud_scene.instantiate() as Hud
	
	if hud == null:
		print("Main: error creating HUD.")
		return
	
	var player_num := players.get_children().find(player)
	hud.position.y = player_num * 60
	huds.add_child(hud)
	
	# Signal connections
	player.hp_did_update.connect(hud.hp_did_update)
	
	player.combat_component.timers_did_update.connect(
		hud.special_did_update
	)
	
	player.relic_component.timer_did_update.connect(
		hud.relic_did_update
	)
	
	if player.is_multiplayer_authority():
		player.died.connect(hud.player_died)
		player.resurrect_ready.connect(hud.player_resurrect_ready)
		player.did_resurrect.connect(hud.player_did_resurrect)
		player.resurrect_timer_did_update.connect(hud.resurrect_timer_did_update)
		player.final_death.connect(hud.player_died_finally)
		hud.special_ready.connect(player.special_is_ready)
		hud.relic_ready.connect(player.relic_is_ready)
