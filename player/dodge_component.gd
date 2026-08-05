extends Node
class_name DodgeComponent


# PROPERTIES

signal dodge_started
signal dodge_executing
signal dodge_finished

@export var dodge_speed: float = 10.0
@export var dodge_duration := 0.5

var is_dodging := false
var dodge_timer := 0.0


# FUNCTIONS

# Executes a dodge/roll action.
func execute_dodge(delta: float) -> void:
	if is_dodging:
		dodge_timer -= delta
		
		dodge_executing.emit()
		
		if dodge_timer <= 0:
			is_dodging = false
			
			dodge_finished.emit()
		
	else:
		if Input.is_action_just_pressed("dodge"):
			is_dodging = true
			dodge_timer = dodge_duration
			
			dodge_started.emit()


# Gets the dodge distance.
func get_dodge_distance() -> float:
	return dodge_speed * dodge_duration
