extends Node2D

# PROPERTIES

@export var texture: Texture

@onready var icon = $Icon
@onready var show_timer = $Timer

var timer_tween: Tween
var camera: Camera3D

var icon_length: float = 30.0


# FUNCTIONS

func setup_values():
	var texture_size = texture.get_size()
	
	camera = get_viewport().get_camera_3d()
	scale = Vector2.ZERO
	
	icon.texture = texture
	icon.scale = Vector2(icon_length, icon_length) / texture_size


func position_bar(actor: Node3D, x_offset: float):
	var offset := Vector3(x_offset, 0, -2.5)
	var world_position := actor.global_position + offset
	
	position = camera.unproject_position(world_position)


func show_bar() -> void:
	if timer_tween:
		timer_tween.kill()
	
	timer_tween = create_tween()
	timer_tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	
	show_timer.start()


func _on_timer_timeout() -> void:
	if timer_tween:
		timer_tween.kill()
	
	timer_tween = create_tween()
	timer_tween.tween_property(self, "scale", Vector2.ZERO, 0.1)
