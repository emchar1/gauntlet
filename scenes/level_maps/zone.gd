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


# FUNCTIONS

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	zone_entered.emit(self)
