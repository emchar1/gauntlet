extends Area3D

# PROPERTIES

@onready var anim_player = $AnimationPlayer

var cooldown: float = 20.0
var damage: float = 2.0


# FUNCTIONS

func setup(pos: Vector3):
	global_position = Vector3(pos.x, 0.05, pos.z)
	anim_player.play("activate")


# SIGNAL CALLBACKS

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurtbox"):
		print("Hit!!")


func _did_finish_activating():
	queue_free()
