extends Node

# PROPERTIES

signal connection_succeeded

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
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
	print("Connecting to ", ip)


# SIGNAL FUNCTIONS

func _on_peer_connected(peer_id: int) -> void:
	print("Peer connected: ", peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer disconnected: ", peer_id)


func _on_connected_to_server() -> void:
	print("Connected! My peer ID: ", multiplayer.get_unique_id())
	
	# Emit signal to defer next steps until after connection is established.
	connection_succeeded.emit()


func _on_connection_failed() -> void:
	print("Connection failed.")


# PLAYER LOOKUP FUNCTIONS

func find_player(peer_id: int) -> Player:
	var tree := get_tree()
	var players := tree.get_nodes_in_group("player")
	
	print("Looking for peer: ", peer_id)
	print("NetworkManager path: ", get_path())
	print("Scene tree root: ", tree.root.get_path())
	print("Players found: ", players.size())
	
	for node in players:
		print(
			"Player candidate: ", node.name,
			" | path: ", node.get_path(),
			" | type: ", node.get_class(),
			" | instance valid: ", is_instance_valid(node)
		)
		
		var candidate := node as Player
		
		if candidate != null and candidate.name == str(peer_id):
			print("Found local player: ", candidate.name)
			return candidate
	
	return null
