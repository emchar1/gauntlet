extends Node3D

# PROPERTIES

@export var enemy_scene: PackedScene
@onready var player = $Player

var enemy_configs = [
	preload("res://resources/enemies/enemy_melee.tres"),
	#preload("res://resources/enemies/enemy_fast.tres"),
	#preload("res://resources/enemies/enemy_caster.tres"),
	#preload("res://resources/enemies/enemy_tank.tres")
]


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	var enemy_spawn_location = $EnemySpawn/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	var enemy = enemy_scene.instantiate()
	
	enemy.player = player
	enemy.position = enemy_spawn_location.position
	enemy.enemy_config = enemy_configs.pick_random()
	#enemy.apply_config()
	enemy.spawn()
	
	add_child(enemy)
