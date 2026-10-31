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
	
	relic_did_activate.emit()
	
	# Update and spawn across peers.
	_update_cooldown_timer.rpc(config.cooldown)
	_spawn_relic.rpc(actor.global_position, int(config.type))


@rpc("authority", "call_local", "reliable")
func _update_cooldown_timer(cooldown: float) -> void:
	timer = cooldown


@rpc("authority", "call_local", "reliable")
func _spawn_relic(pos: Vector3, config_type: int) -> void:
	var config := get_relic_for(config_type)
	if not config:
		push_error("Relic configuration not found.")
		return
	
	var scene := config.get_scene()
	if not scene:
		push_error("Relic scene not found.")
		return
	
	var obj := scene.instantiate()
	get_tree().current_scene.add_child(obj)
	
	obj.setup(pos)
	config.configure(obj)


# HELPER FUNCTIONS

func get_current_relic() -> RelicConfig:
	return get_relic_for(type)


func get_relic_for(relic_type: int) -> RelicConfig:
	var current_relic: RelicConfig
	
	match relic_type:
		RelicConfig.Type.FREEZE:
			current_relic = load("res://resources/relics/freeze.tres")
		RelicConfig.Type.TORNADO:
			current_relic = null
		RelicConfig.Type.SPEED:
			current_relic = null
	
	return current_relic
