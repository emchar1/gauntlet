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
const ATTACK_SPECIAL = "attack_special"
const ATTACK_CHARGE_KB = "attack_charge_keyboard"
const ATTACK_CHARGE_PAD = "attack_charge_gamepad"

# Attack - Gamepad
const AIM_UP = "aim_up"
const AIM_LEFT = "aim_left"
const AIM_DOWN = "aim_down"
const AIM_RIGHT = "aim_right"

# Special
const DODGE = "dodge"
const USE_POTION = "use_potion"
const USE_RELIC = "use_relic"
const START = "start"

# States
var move_direction := Vector2.ZERO
var aim_direction := Vector2.ZERO
var main_pressed := false
var main_released := false
var special_pressed := false
var potion_pressed := false
var dodge_pressed := false
var relic_pressed := false
var start_pressed := false
var start_released := false

# Charge States
var charge_pressed := false
var charge_held := false
var charge_released := false
var charge_pressed_kb := false
var charge_held_kb := false
var charge_released_kb := false
var charge_pressed_pad := false
var charge_held_pad := false
var charge_released_pad := false

# Gamepad - charged attacking
var gamepad_aim_pressed := false
var gamepad_aiming := false


# FUNCTIONS

# Revert to mouse control if gamepad not used
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		gamepad_aiming = false


# Convenience function. Reads all input: movement, combat, aiming.
func read_input(actor: CharacterBody3D) -> void:
	read_start()
	read_movement()
	read_combat()
	read_aiming(actor)


func read_start() -> void:
	start_pressed = Input.is_action_just_pressed(START)
	start_released = Input.is_action_just_released(START)


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
	special_pressed = Input.is_action_just_pressed(ATTACK_SPECIAL)
	potion_pressed = Input.is_action_just_pressed(USE_POTION)
	dodge_pressed = Input.is_action_just_pressed(DODGE)
	relic_pressed = Input.is_action_just_pressed(USE_RELIC)
	
	# Charge Inputs
	charge_pressed_kb = Input.is_action_just_pressed(ATTACK_CHARGE_KB)
	charge_held_kb = Input.is_action_pressed(ATTACK_CHARGE_KB)
	charge_released_kb = Input.is_action_just_released(ATTACK_CHARGE_KB)
	charge_pressed_pad = Input.is_action_just_pressed(ATTACK_CHARGE_PAD)
	charge_held_pad = Input.is_action_pressed(ATTACK_CHARGE_PAD)
	charge_released_pad = Input.is_action_just_released(ATTACK_CHARGE_PAD)
	charge_pressed = charge_pressed_kb or charge_pressed_pad
	charge_held = charge_held_kb or charge_held_pad
	charge_released = charge_released_kb or charge_released_pad


# Reads in mouse/gamepad and actor positioning to calculate aiming.
func read_aiming(actor: CharacterBody3D) -> void:
	# Gamepad aiming
	var gamepad_stick_direction := Input.get_vector(
		AIM_LEFT,
		AIM_RIGHT,
		AIM_UP,
		AIM_DOWN
	)
	
	if gamepad_stick_direction.length() > 0.1:
		gamepad_aiming = true
		gamepad_aim_pressed = true
		aim_direction = gamepad_stick_direction
		return
	
	gamepad_aim_pressed = false
	
	if gamepad_aiming:
		return
	
	
	# Mouse aiming
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
