extends Node
class_name RelicComponent

# PROPERTIES

signal relic_did_activate
signal timer_did_update(_timer: float, cooldown: float)

@export var type: RelicConfig.Type

var timer: float


# FUNCTIONS

# Initializes timer for first use.
func set_timer() -> void:
	timer = 0.0


# Update timer on a clock tick.
func update_timer(delta: float) -> void:
	timer -= delta
	
	var current_relic = get_current_relic()
	
	if current_relic:
		timer_did_update.emit(timer, current_relic.cooldown)


func activate(actor: Node3D, config: RelicConfig):
	if not config:
		print("Invalid relic. Check RelicComponent node in Player.tscn.")
		return
	
	if timer > 0:
		return
	
	# Create RelicConfig object
	var scene = config.get_scene()
	var obj = scene.instantiate()
	get_tree().current_scene.add_child(obj)
	
	obj.setup(actor.global_position)
	config.configure(obj)
	
	# Update timers and emit
	timer = config.cooldown
	relic_did_activate.emit()


# HELPER FUNCTIONS

func get_current_relic() -> RelicConfig:
	var current_relic: RelicConfig
	
	match type:
		RelicConfig.Type.FREEZE:
			current_relic = load("res://resources/relics/freeze.tres")
		RelicConfig.Type.TORNADO:
			current_relic = null
		RelicConfig.Type.SPEED:
			current_relic = null
	
	return current_relic
