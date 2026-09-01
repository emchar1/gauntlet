extends Control

# PROPERTIES

@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_label(enemies_defeated: int, spawners_destroyed: int, died: int):
	label.text = "Enemies Defeated: %d\nSpawners Destroyed: %d\nDied: %d" % \
	[enemies_defeated, spawners_destroyed, died]


func show_label():
	var tween = create_tween()
	tween.tween_property(
		label,
		"modulate:a",
		1.0,
		2.0
	)


# SIGNAL CALLBACK FUNCTIONS
func show_final_results():
	await get_tree().create_timer(4.0).timeout
	
	update_label(
		GameState.enemies_killed,
		GameState.spawners_destroyed,
		GameState.died_count
	)
	
	show_label()
