extends Resource
class_name EnemyConfig

# TYPE

enum EnemyType {
	MELEE, FAST, TANK, CASTER
}

@export var enemy_type: EnemyType = EnemyType.MELEE


# PROPERTIES

@export var hp: float = 4
@export var speed: float = 8
@export var acceleration: float = 4
@export var attack_dmg: float = 5
@export var spawn_duration: float = 1
@export var slay_duration: float = 0.5
