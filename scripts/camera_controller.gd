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


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zones = get_tree().get_nodes_in_group("zone")
	
	for zone in zones:
		zone.zone_entered.connect(_on_zone_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mode == CameraMode.FOLLOW:
		follow_player()


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
