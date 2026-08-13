extends Area3D
class_name Zone

# PROPERTIES

enum ZoneType {
	ROOM, CORRIDOR
}

signal zone_entered(zone: Zone)

@export var zone_type: ZoneType

@onready var camera_boundary = $CollisionShape3D
@onready var center_point = get_node_or_null("CenterPoint")
@onready var spawner = get_node_or_null("Spawner")
@onready var spawner2 = get_node_or_null("Spawner2")

var is_cleared = false


# FUNCTIONS

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	zone_entered.emit(self)
	
	await get_tree().create_timer(1.0).timeout
	
	if spawner:
		spawner.activate()
	
	if spawner2:
		spawner2.activate()
