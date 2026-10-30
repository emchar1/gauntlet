extends Resource
class_name RelicConfig

# VISUALS/SPAWNING

@export var scene: PackedScene


# STATS

@export var cooldown: float = 25.0
@export var damage: float = 0.0


# FUNCTIONS

func configure(obj: Area3D):
	obj.cooldown = cooldown
	obj.damage = damage
