extends Node

# PROPERTIES

const PORT = 7000
const MAX_PLAYERS = 2


# FUNCTIONS

func host() -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_PLAYERS)
	
	if error != OK:
		print("Failed to host: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	print("Hosting. My peer ID: ", multiplayer.get_unique_id())


func join(ip: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip, PORT)
	
	if error != OK:
		print("Failed to connect: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
	print("Connecting to ", ip)


func _on_peer_connected(peer_id: int) -> void:
	print("Peer connected: ", peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer disconnected: ", peer_id)


func _on_connected() -> void:
	print("Connected! My peer ID: ", multiplayer.get_unique_id())


func _on_connection_failed() -> void:
	print("Connection failed.")
