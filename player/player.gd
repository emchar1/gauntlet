extends CharacterBody3D
class_name Player


# PROPERTIES

enum State {
	IDLE, RUN, ATTACK, HURT, DEAD, NONE
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
	attack_state = State.NONE


func _physics_process(_delta: float) -> void:
	_player_move()
	_player_attack()
	
	move_and_slide()


# HELPER FUNCTIONS

# Player movement function.
func _player_move():
	input_component.read_movement()
	
	movement_component.move_dir = input_component.move_direction
	movement_component.update_movement(self)
	
	if movement_component.is_moving:
		_update_move_state(State.RUN)
	else:
		_update_move_state(State.IDLE)


# Player attack function.
func _player_attack():
	input_component.read_combat()
	
	if input_component.main_pressed:
		combat_component.start_attack(self)
	#elif input_component.main_released: # Handled in attack_finished()
		#combat_component.end_attack(self)
	
	if combat_component.is_attacking:
		_update_attack_state(State.ATTACK)
	#else: # Handled in attack_finished()
		#_update_attack_state(State.NONE)


# Updates the move state and animation
func _update_move_state(state: State):
	if move_state == state:
		return
	
	move_state = state
	animation_component.play_locomotion(state)


# Updates the attack state and animation
func _update_attack_state(state: State):
	if attack_state == state:
		return
	
	attack_state = state
	animation_component.play_combat(state)


func attack_finished():
	combat_component.end_attack(self)
	_update_attack_state(State.NONE)
