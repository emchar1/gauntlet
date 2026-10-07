extends Node3D

# PROPERTIES

@onready var label = $Instructions/Label
@onready var label3 = $Instructions/Label3
@onready var label4 = $Instructions/Label4
@onready var label11 = $Instructions/Label11
@onready var label12 = $Instructions/Label12
@onready var label15 = $Instructions/Label15
@onready var final_label = $Instructions/Label10


# FUNCTIONS

func show_final_label():
	var tween = create_tween()
	tween.tween_property(final_label, "transparency", 0.0, 3.0).set_delay(2.0)


func update_labels(gamepad_aiming: bool):
	if gamepad_aiming:
		label.text = "Tilt L3 to move.\nTilt R3 to fire arrows."
		label3.text = "Easy, right? Hold\nR2 to switch\nto sniper mode." \
		+ "\nArrows are deadlier."
		label4.text = "Tap L2 to place a timed bomb.\n"\
		+ "Watch enemies go boom. Fun!\nTry it in sniper mode!"
		label11.text = "If you do die,\npress X to resurrect."
		label12.text = "Do a dodge/roll\nby hitting O."
		label15.text = "Can't take the heat?\nTap R1 to unleash your\n" \
		+ "Freeze Relic attack!"
	else:
		label.text = "WASD to move.\nTap or hold LMB\nto fire arrows."
		label3.text = "Easy, right? Hold\nSHIFT to switch\nto sniper mode." \
		+ "\nArrows are deadlier."
		label4.text = "Tap RMB to place a timed bomb.\n"\
		+ "Watch enemies go boom. Fun!\nTry it in sniper mode!"
		label11.text = "If you do die,\npress Enter to resurrect."
		label12.text = "Do a dodge/roll\nby hitting Space."
		label15.text = "Can't take the heat?\nTap E to unleash your\n" \
		+ "Freeze Relic attack!"
