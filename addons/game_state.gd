extends Node


# PROPERTIES

# Collision Layers/Masks
const COLLISION_WORLD = 1
const COLLISION_PLAYER_BODY = 2
const COLLISION_ENEMY_BODY = 3
const COLLISION_SPAWNER_BODY = 4
const COLLISION_PLAYER_HIT = 5
const COLLISION_ENEMY_HIT = 6
const COLLISION_SPAWNER_HIT = 7
const COLLISION_PLAYER_HURT = 8
const COLLISION_ENEMY_HURT = 9
const COLLISION_SPAWNER_HURT = 10
const COLLISION_DESTRUCTIBLE = 11
const COLLISION_COLLECTIBLE = 12
const COLLISION_ZONE_TRIGGER = 13

var music_volume := 1.0
var sfx_volume := 1.0


# FUNCTIONS

func map_2d_to_3d(vector2: Vector2) -> Vector3:
	return Vector3(vector2.x, 0.0, vector2.y)


func map_3d_to_2d(vector3: Vector3) -> Vector2:
	return Vector2(vector3.x, vector3.z)


func shake_main_camera(strength: float, speed: float):
	var main_scene = get_tree().current_scene
	var camera_controller = main_scene.get_node("CameraController")
	
	if not camera_controller:
		print("Unable to get CameraController. Check main.tscn.")
		return
	
	camera_controller.shake(strength, speed)
