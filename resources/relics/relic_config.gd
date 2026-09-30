extends Resource
class_name RelicConfig

# VISUALS/SPAWNING

@export var scene: PackedScene


# STATS

@export var cooldown: float = 30.0
@export var damage: float = 1.0


# FUNCTIONS

func configure(obj):
	obj.cooldown = cooldown
	obj.damage = damage
