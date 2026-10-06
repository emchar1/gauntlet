extends Node2D

# PROPERTIES

@export var bar_scale := 0.08
@export var color: GradientTexture2D

@onready var show_timer = $Timer

var timer_tween: Tween
var camera: Camera3D


# FUNCTIONS

func setup_values():
	camera = get_viewport().get_camera_3d()
	scale = Vector2.ZERO
	$Control.scale = Vector2(bar_scale, bar_scale)


func position_bar(actor: Node3D, x_offset: float):
	var offset := Vector3(x_offset, 15, 0)
	var world_position := actor.global_position + offset + Vector3.UP * 1.5
	position = camera.unproject_position(world_position)


func show_bar() -> void:
	if timer_tween:
		timer_tween.kill()
	
	timer_tween = create_tween()
	timer_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.1
	)
	
	show_timer.start()


func _on_timer_timeout() -> void:
	if timer_tween:
		timer_tween.kill()
	
	timer_tween = create_tween()
	timer_tween.tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.1
	)
