extends Resource
class_name RelicConfig

# VISUALS/SPAWNING

enum Type { 
	FREEZE, TORNADO, SPEED
}

# STATS

@export var type: Type
@export var cooldown: float = 25.0
@export var damage: float = 0.0


# FUNCTIONS

func configure(obj: Area3D):
	obj.cooldown = cooldown
	obj.damage = damage


func get_scene() -> PackedScene:
	match type:
		Type.FREEZE:
			return load("res://scenes/relics/freeze.tscn")
		Type.TORNADO:
			return null
		Type.SPEED:
			return null
	
	return null
