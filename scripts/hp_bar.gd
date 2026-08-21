extends Node2D

# PROPERTIES

@export var bar_scale := 1.0

@onready var health_bar = $Control/Bar
@onready var show_hp_timer = $ShowHPTimer

var max_health: float = 4.0
var timer_tween: Tween
var camera: Camera3D


# FUNCTIONS

func setup_values(max_hp: float):
	max_health = max_hp
	camera = get_viewport().get_camera_3d()
	modulate.a = 0
	$Control.scale = Vector2(bar_scale, bar_scale)


func position_hp(actor: Node3D):
	var offset := Vector3(-1.5 * bar_scale, 0, 2)
	var world_position := actor.global_position + offset + Vector3.UP * 1.5
	position = camera.unproject_position(world_position)


func update_health(new_health: int) -> void:
	var ratio = float(new_health) / max_health
	health_bar.scale.x = ratio
	
	modulate.a = 1.0
	show_hp_timer.start()


func _on_show_hp_timer_timeout() -> void:
	if timer_tween:
		timer_tween.kill()
	
	timer_tween = create_tween()
	timer_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.5
	)
