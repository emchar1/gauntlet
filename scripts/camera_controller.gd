extends Node3D

# PROPERTIES

enum CameraMode {
	FOLLOW, ANCHOR
}

@onready var camera = $Camera3D
@onready var player = get_tree().get_first_node_in_group("player")

# Camera Presets
@export var follow_offset = Vector3(0.0, 30.0, 4.0)
@export_range(0.0, 1.0) var follow_smoothing = 0.05

var zones = []
var mode = CameraMode.FOLLOW
var tween: Tween
var current_zone: Zone

var shake_offset: Vector3 = Vector3.ZERO
var shake_strength: float = 0
var shake_speed: float = 5


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zones = get_tree().get_nodes_in_group("zone")
	
	for zone in zones:
		zone.zone_entered.connect(_on_zone_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mode == CameraMode.FOLLOW:
		follow_player()
	
	_update_shake(delta)


# Call this in _process() to track the object
func follow_player():
	if player == null:
		return
	
	if current_zone == null:
		return
	
	global_position = global_position.lerp(
		player.global_position + follow_offset,
		follow_smoothing
	)


func _on_zone_entered(zone: Zone):
	current_zone = zone
	
	if zone.zone_type == Zone.ZoneType.ROOM and not zone.is_cleared:
		switch_to_anchor(zone)
	else:
		switch_to_follow()


func switch_to_follow():
	mode = CameraMode.FOLLOW
	
	var target_fov := 55.0
	var zoom_duration := 2.0
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(
		camera,
		"fov",
		target_fov,
		zoom_duration
	)


func switch_to_anchor(zone: Zone):
	if zone.center_point == null:
		return
	
	mode = CameraMode.ANCHOR
	
	var target_fov = 75.0
	var zoom_duration := 1.0
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(
		camera,
		"fov",
		target_fov,
		zoom_duration
	)
	tween.parallel().tween_property(
		self,
		"global_position",
		zone.center_point.global_position,
		zoom_duration
	)


func _update_shake(delta: float):
	shake_strength = lerpf(shake_strength, 0.0, shake_speed * delta)
	
	shake_offset = Vector3(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength * 0.5, shake_strength * 0.5),
		randf_range(-shake_strength, shake_strength)
	)
	
	global_position += shake_offset


func shake(strength: float, speed: float = 5):
	shake_speed = speed
	shake_strength = max(shake_strength, strength)
