extends CharacterBody3D
class_name Enemy

# PROPERTIES

enum State {
	NONE, IDLE, RUN, ATTACK, HURT, DEAD
}

@onready var animation_player = $AnimationPlayer

var current_state: State


# FUNCTIONS

func _ready() -> void:
	_update_state(State.RUN)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	move_and_slide()


# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta


# Updates the current state and animation
func _update_state(state: State):
	current_state = state
	
	match state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		_:
			animation_player.play("RESET")
