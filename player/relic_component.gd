extends Node
class_name RelicComponent

# PROPERTIES

signal relic_did_activate
signal timer_did_update(_timer: float, cooldown: float)

enum Type {
	FREEZE, TORNADO, SPEED
}

@export var type: Type
@export var freeze_relic: RelicConfig
@export var tornado_relic: RelicConfig
@export var speed_relic: RelicConfig

var timer: float


# FUNCTIONS

# Initializes timer for first use.
func set_timer() -> void:
	timer = 0.0


# Update timer on a clock tick.
func update_timer(delta: float) -> void:
	timer -= delta
	
	timer_did_update.emit(timer, _get_current_relic().cooldown)


func activate(actor: Node3D, config: RelicConfig):
	if not config:
		print("Invalid relic. Check RelicComponent node in Player.tscn.")
		return
	
	if timer > 0:
		return
	
	# Create RelicConfig object
	var obj = config.scene.instantiate()
	get_tree().current_scene.add_child(obj)
	
	obj.setup(actor.global_position)
	config.configure(obj)
	
	# Update timers and emit
	timer = config.cooldown
	relic_did_activate.emit()


# HELPER FUNCTIONS

func _get_current_relic() -> RelicConfig:
	var current_relic: RelicConfig
	
	match type:
		Type.FREEZE:
			current_relic = freeze_relic
		Type.TORNADO:
			current_relic = tornado_relic
		Type.SPEED:
			current_relic = speed_relic
	
	return current_relic
