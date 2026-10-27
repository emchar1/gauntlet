extends Node

# PROPERTIES

signal connection_succeeded

const PORT = 7008
const MAX_PLAYERS = 2


# FUNCTIONS

func _ready() -> void:
	# The following emit on both clients and servers
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	# The rest only emit for clients
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_PLAYERS)
	
	if error != OK:
		print("Failed to host: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	
	print("Hosting. My peer ID: ", multiplayer.get_unique_id())


func join(ip: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip, PORT)
	
	if error != OK:
		print("Failed to connect: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	
	print("Connecting to ", ip)


# SIGNAL FUNCTIONS

func _on_peer_connected(peer_id: int) -> void:
	print("Host peer connected: ", peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	print("Host peer disconnected: ", peer_id)


func _on_connected_to_server() -> void:
	print("Client connected SUCCESS! Peer ID: ", multiplayer.get_unique_id())
	
	# Emit signal to defer next steps until after connection is established.
	connection_succeeded.emit()


func _on_connection_failed() -> void:
	print("Client connection failed.")


func _on_server_disconnected() -> void:
	print("Server disconnected.")


# PLAYER LOOKUP FUNCTIONS

func find_player(peer_id: int) -> Player:
	var players := get_tree().get_nodes_in_group("player")
	
	for node in players:
		var candidate := node as Player
		
		if candidate != null and candidate.peer_id == peer_id:
			print("Found local player: ", candidate.peer_id)
			return candidate
	
	return null
