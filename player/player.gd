extends CharacterBody3D
class_name Player


# PROPERTIES

enum State {
	IDLE, RUN, ATTACK, HURT, DEAD
}

# Components
@onready var input_component = %InputComponent
@onready var movement_component = %MovementComponent
@onready var combat_component = %CombatComponent
@onready var dodge_component = %DodgeComponent
@onready var animation_component = %AnimationComponent

var move_state: State
var attack_state: State


# FUNCTIONS

func _ready() -> void:
	move_state = State.IDLE
	attack_state = State.IDLE


func _physics_process(_delta: float) -> void:
	_player_move()
	_player_attack()
	
	move_and_slide()


# HELPER FUNCTIONS

# Player movement function.
func _player_move():
	if attack_state == State.ATTACK:
		return
	
	input_component.read_movement()
	
	movement_component.move_dir = input_component.move_direction
	movement_component.update_movement(self)
	
	if movement_component.is_moving:
		_update_move_state(State.RUN)
	else:
		_update_move_state(State.IDLE)


# Player attack function.
func _player_attack():
	if movement_component.is_moving:
		return
	
	input_component.read_combat()
	
	if input_component.main_pressed:
		combat_component.start_attack(self)
	elif input_component.main_released:
		combat_component.end_attack(self)
	
	if combat_component.is_attacking:
		_update_attack_state(State.ATTACK)
	else:
		_update_attack_state(State.IDLE)


# Updates the move state and animation
func _update_move_state(state: State):
	move_state = state
	animation_component.play_animation(state)


# Updates the attack state and animation
func _update_attack_state(state: State):
	attack_state = state
	animation_component.play_animation(state)
