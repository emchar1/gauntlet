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
@onready var enemy_spawn_location = $Path3D/PathFollow3D
@onready var enemy_timer = $EnemyTimer

# Room Spawner specific
@onready var spawn_timer = get_node_or_null("SpawnTimer")
@onready var hp_bar = get_node_or_null("HPBar")
@onready var anim_player = get_node_or_null("AnimationPlayer")

var current_enemy: int = 0

# Room Spawner specific
var current_hp: float
var is_deactivated: bool = true


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawn_type == SpawnType.ROOM:
		if hp_bar:
			current_hp = room_spawner_hp
			hp_bar.setup_values(room_spawner_hp)
		
		if spawn_timer:
			spawn_timer.wait_time = room_spawner_wait_time


func _physics_process(_delta: float) -> void:
	if spawn_type == SpawnType.ROOM:
		hp_bar.position_hp(self)


func _get_enemy_configs() -> Array[EnemyConfig]:
	return [
		enemy_type1,
		enemy_type2
	]


func damage(amount: float):
	if is_deactivated:
		return
	
	current_hp -= amount
	current_hp = clamp(current_hp, 0, room_spawner_hp)
	hp_bar.update_health(current_hp)
	
	if current_hp <= 0:
		is_deactivated = true
		
		if anim_player:
			anim_player.play("died")
			
		enemy_timer.stop()
		
		if spawn_timer:
			spawn_timer.stop()
		
		GameState.shake_main_camera(2.0, 5)
	else:
		if anim_player:
			anim_player.play("damage")


# CALLBACK FUNCTIONS

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if spawn_type == SpawnType.CORRIDOR:
			enemy_timer.start()
		else:
			if not is_deactivated:
				return
			
			print("Activating room timers")
			
			is_deactivated = false
			
			enemy_timer.start()
			
			if spawn_timer:
				spawn_timer.start()


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
	
	get_tree().current_scene.add_child(enemy)
	
	# MUST come AFTER add_child!!
	enemy.global_position = enemy_spawn_location.global_position


# TODO: - 
func _on_spawn_timer_timeout() -> void:
	current_enemy = 0
	enemy_timer.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "died":
		queue_free()
