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
# TODO: - Need 3D Raycasting to get mouse aiming to work in 3D.
func read_aiming(_actor: CharacterBody3D) -> void:
	#var mouse_position = actor.get_global_mouse_position()
	#var to_actor = mouse_position - actor.global_position
	#
	#aim_direction = to_actor.normalized()
	pass
