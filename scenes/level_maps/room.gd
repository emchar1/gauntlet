@tool
extends Node3D


# PROPERTIES

enum SideType {
	WALL, NONE
}

@export var wall_top = SideType.NONE:
	set(value):
		wall_top = value
		_update_side(wall_top, Vector3(0, 0, -halves.y), Vector3.ZERO)

@export var wall_left = SideType.NONE:
	set(value):
		wall_left = value
		_update_side(wall_left, Vector3(-halves.x, 0, 0), Vector3(0, PI / 2, 0))

@export var wall_bottom = SideType.NONE:
	set(value):
		wall_bottom = value
		_update_side(wall_bottom, Vector3(0, 0, halves.y), Vector3.ZERO)

@export var wall_right = SideType.NONE:
	set(value):
		wall_right = value
		_update_side(wall_right, Vector3(halves.x, 0, 0), Vector3(0, PI / 2, 0))

@export var wall_scene: PackedScene

@onready var walls = $Walls
@onready var doors = get_tree().get_nodes_in_group("door")

var halves := Vector2(69.5, 39.5)
var room_clear_count: int = 0
var room_clear_threshold: int = 3
var room_clear_max: int = 90
var doors_open: bool = true


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_all_sides()


func _get_doors():
	return get_tree().get_nodes_in_group("door")


# FUNCTIONS

func open_doors(open_delay: float = 0.0):
	if doors_open:
		print("doors open, exiting..")
		return
	
	doors_open = true
	
	if open_delay > 0.0:
		await get_tree().create_timer(open_delay).timeout
	
	for door in _get_doors():
		door.set_doorway(true)
	
	if not AudioManager.is_playing(AudioData.AudioKey.DOOR_OPEN):
		AudioManager.play(AudioData.AudioKey.DOOR_OPEN)


func close_doors():
	if not doors_open:
		print("doors closed, exiting..")
		return
	
	doors_open = false
	
	for door in _get_doors():
		door.set_doorway(false)
	
	if not AudioManager.is_playing(AudioData.AudioKey.DOOR_CLOSE):
		AudioManager.play(AudioData.AudioKey.DOOR_CLOSE)


# HELPER FUNCTIONS

func _update_all_sides():
	for child in walls.get_children():
		child.queue_free()
	
	_create_side(wall_top, Vector3(0, 0, -halves.y), Vector3.ZERO)
	_create_side(wall_left, Vector3(-halves.x, 0, 0), Vector3(0, PI / 2, 0))
	_create_side(wall_bottom, Vector3(0, 0, halves.y), Vector3.ZERO)
	_create_side(wall_right, Vector3(halves.x, 0, 0), Vector3(0, PI / 2, 0))


func _update_side(side_type: SideType, pos: Vector3, rot: Vector3):
	if not is_instance_valid(walls):
		return
	
	# Remove existing side at this position.
	for child in walls.get_children():
		if child.position == pos:
			child.queue_free()
	
	# Nothing to create.
	if side_type == SideType.NONE:
		return
	
	_create_side(side_type, pos, rot)


func _create_side(side_type: SideType, pos: Vector3, rot: Vector3):
	var scene: PackedScene
	
	match side_type:
		SideType.WALL:
			scene = wall_scene
		SideType.NONE:
			return
	
	var side = scene.instantiate()
	side.position = pos
	side.rotation = rot
	
	if side_type == SideType.WALL:
		side.size.x = 30.0
	
	walls.add_child(side)


# SIGNAL CALLBACKS:

func _on_enemy_died():
	room_clear_count -= 1
	
	if room_clear_count <= room_clear_threshold:
		open_doors(2.0)
