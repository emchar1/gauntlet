extends Control

# PROPERTIES

@onready var hp_filled = $HP/Filled
@onready var special_filled = $Special/Filled

var hp_tween: Tween


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# SIGNAL CALLBACK FUNCTIONS

func hp_did_update(current_hp: float, max_hp: float):
	if hp_tween:
		hp_tween.kill()
	
	hp_tween = create_tween()
	hp_tween.tween_property(
		hp_filled,
		"scale:x",
		current_hp / max_hp,
		0.25
	)


func special_did_update(_timer: float, cooldown: float):
	var _timer_clamped = clamp(_timer, 0, cooldown)
	
	special_filled.scale.x = (cooldown - _timer_clamped) / cooldown
