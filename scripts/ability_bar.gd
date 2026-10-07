extends Node2D

# PROPERTIES

@export var bar_scale := 1.0
@export var color: Color

@onready var control = $Control
@onready var background = $Control/Background
@onready var show_timer = $Timer

var timer_tween: Tween
var camera: Camera3D


# FUNCTIONS

func setup_values():
	camera = get_viewport().get_camera_3d()
	scale = Vector2.ZERO
	control.scale = Vector2(bar_scale, bar_scale)
	background.color = color


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
