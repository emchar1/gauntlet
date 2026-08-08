extends Node
class_name InputComponent


# PROPERTIES

# D-Pad
const MOVE_UP = "move_up"
const MOVE_LEFT = "move_left"
const MOVE_DOWN = "move_down"
const MOVE_RIGHT = "move_right"

# Attack
const ATTACK_MAIN = "attack_main"
const ATTACK_CHARGE = "attack_charge"
const ATTACK_SPECIAL = "attack_special"

# Special
const DODGE = "dodge"
const USE_POTION = "use_potion"
const USE_RELIC = "use_relic"

# States
var move_direction := Vector2.ZERO
var aim_direction := Vector2.ZERO
var main_pressed := false
var main_released := false
var charge_pressed := false
var charge_released := false
var special_pressed := false
var potion_pressed := false
var dodge_pressed := false
var relic_pressed := false


# FUNCTIONS

# Convenience function. Reads all input: movement, combat, aiming.
func read_input(actor: CharacterBody3D) -> void:
	read_movement()
	read_combat()
	read_aiming(actor)


# Reads in directional movement input.
func read_movement() -> void:
	# Modern implementation to d-movement. DO NOT CHANGE THIS ORDER!
	move_direction = Input.get_vector(
		MOVE_LEFT,
		MOVE_RIGHT,
		MOVE_UP,
		MOVE_DOWN
	)


# Reads in attack combat input.
func read_combat() -> void:
	main_pressed = Input.is_action_pressed(ATTACK_MAIN)
	main_released = Input.is_action_just_released(ATTACK_MAIN)
	charge_pressed = Input.is_action_pressed(ATTACK_CHARGE)
	charge_released = Input.is_action_just_released(ATTACK_CHARGE)
	special_pressed = Input.is_action_just_pressed(ATTACK_SPECIAL)
	potion_pressed = Input.is_action_just_pressed(USE_POTION)
	dodge_pressed = Input.is_action_just_pressed(DODGE)
	relic_pressed = Input.is_action_just_pressed(USE_RELIC)


# Reads in mouse and actor positioning to calculate aiming.
func read_aiming(actor: CharacterBody3D) -> void:
	var camera := actor.get_viewport().get_camera_3d()
	var mouse_pos := actor.get_viewport().get_mouse_position()
	
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_direction := camera.project_ray_normal(mouse_pos)
	var plane_y := actor.global_position.y
	
	if abs(ray_direction.y) > 0.0001:
		var distance := (plane_y - ray_origin.y) / ray_direction.y
		var target := ray_origin + ray_direction * distance
		
		var direction_3d := target - actor.global_position
		direction_3d.y = 0.0
		
		# Prevents edge case where arrows shoot backwards if mouse too high up.
		if distance < 0.0:
			direction_3d = -direction_3d
		
		aim_direction = GameState.map_3d_to_2d(direction_3d).normalized()
