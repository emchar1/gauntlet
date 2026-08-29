extends Node3D
class_name EnemySpawner


# PROPERTIES

enum SpawnType {
	ROOM, CORRIDOR
}

@export var spawn_type: SpawnType = SpawnType.CORRIDOR
@export var total_enemies: int = 9
@export var enemy_type1: EnemyConfig
@export var enemy_type2: EnemyConfig

# Room Spawner specific
@export var room_spawner_hp: float = 100
@export var room_spawner_wait_time: float = 10

@onready var player = get_tree().get_first_node_in_group("player")
@onready var enemy_timer = $EnemyTimer
@onready var spawn_timer = get_node_or_null("SpawnTimer")
@onready var enemy_spawn_location = $Path3D/PathFollow3D
@onready var hp_bar = get_node_or_null("HPBar")

var current_enemy: int = 0
var current_hp: float


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawn_type == SpawnType.ROOM:
		if hp_bar:
			current_hp = room_spawner_hp
			hp_bar.setup_values(room_spawner_hp)
		
		if spawn_timer:
			spawn_timer.wait_time = room_spawner_wait_time
			
			# FIXME: - temporary
			# Start the timers!!
			spawn_timer.start()
			enemy_timer.start()


func _physics_process(_delta: float) -> void:
	if spawn_type == SpawnType.ROOM:
		hp_bar.position_hp(self)


func _get_enemy_configs() -> Array[EnemyConfig]:
	return [
		enemy_type1,
		enemy_type2
	]


func damage(amount: float):
	print("damaged: ", amount)
	current_hp -= amount
	current_hp = clamp(current_hp, 0, room_spawner_hp)
	hp_bar.update_health(current_hp)


# CALLBACK FUNCTIONS

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		enemy_timer.start()


func _on_enemy_timer_timeout() -> void:
	if current_enemy >= total_enemies:
		enemy_timer.stop()
		return
	
	current_enemy += 1
	
	enemy_spawn_location.progress_ratio = randf()
	
	var enemy_config = _get_enemy_configs().pick_random()
	var enemy = enemy_config.enemy_scene.instantiate()
	enemy.player = player
	enemy.enemy_config = enemy_config
	enemy.spawn()
	
	add_child(enemy)
	
	# MUST come AFTER add_child!!
	enemy.global_position = enemy_spawn_location.global_position


# TODO: - 
func _on_spawn_timer_timeout() -> void:
	current_enemy = 0
	enemy_timer.start()
