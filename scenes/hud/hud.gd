extends Control

# PROPERTIES

@onready var hp_filled = $HP/Filled
@onready var special_filled = $Special/Filled
@onready var resurrect_control = $Resurrect
@onready var resurrect_label = $Resurrect/Label
@onready var resurrect_timer_label = $Resurrect/Countdown

var hp_tween: Tween
var resurrect_tween: Tween
var resurrect_timer: int


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resurrect_control.hide()
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


func player_died():
	resurrect_control.show()
	resurrect_label.show()


# Kill the damn thing once and for all...
func player_died_finally():
	resurrect_control.hide()


func player_resurrect_ready():
	resurrect_label.hide()
	resurrect_timer_label.text = "PRESS START"
	
	if resurrect_tween:
		resurrect_tween.kill()
	
	var blink_speed: float = 0.1
	
	resurrect_tween = create_tween()
	resurrect_tween.set_loops()

	resurrect_tween.tween_property(
		resurrect_timer_label,
		"modulate",
		Color.MAGENTA,
		blink_speed
	)
	resurrect_tween.tween_property(
		resurrect_timer_label,
		"modulate",
		Color.YELLOW,
		blink_speed
	)
	resurrect_tween.tween_property(
		resurrect_timer_label,
		"modulate",
		Color.GREEN,
		blink_speed
	)
	resurrect_tween.tween_property(
		resurrect_timer_label,
		"modulate",
		Color.CYAN,
		blink_speed
	)


func player_did_resurrect():
	resurrect_control.hide()
	
	if resurrect_tween:
		resurrect_tween.kill()
		resurrect_tween = null
		resurrect_timer_label.modulate = Color.WHITE


func resurrect_timer_did_update(_timer: float):
	resurrect_timer = int(_timer) + 1
	resurrect_timer_label.text = str(resurrect_timer)


func special_did_update(_timer: float, cooldown: float):
	var _timer_clamped = clamp(_timer, 0, cooldown)
	
	special_filled.scale.x = (cooldown - _timer_clamped) / cooldown
