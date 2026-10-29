extends Resource
class_name Ability


# VISUALS / SPAWNING

enum Type {
	QUICK_ARROW, CHARGED_ARROW, MAGIC_ARROW, MAGIC_BOMB, MAGIC_BOMB_FOCUSED
}

# STATS
# Interrupt values:
#    0 - no interrupt
#    1 - half interrupt
#    2 - complete interrupt

@export var type: Type
@export var cooldown: float = 0.2
@export var damage: float = 2
@export var speed: float = 10
@export var knockback: float = 0
@export var interrupt: int = 0
@export var max_distance: float = 40


# FLAGS

@export var obeys_gravity: bool = true
@export var piercing: bool = false
@export var explodes: bool = false
@export var usable_while_dodging: bool = false


# FUNCTIONS

func configure(obj: Area3D):
	obj.damage = damage
	obj.speed = speed
	obj.knockback = knockback
	obj.interrupt = interrupt
	obj.max_distance = max_distance
	
	obj.obeys_gravity = obeys_gravity
	obj.piercing = piercing
	obj.explodes = explodes
	obj.usable_while_dodging = usable_while_dodging


func get_scene() -> PackedScene:
	match type:
		# Do not use preload() here. It causes crashes???
		
		Ability.Type.QUICK_ARROW:
			return load("res://scenes/attacks/arrow.tscn")
		Ability.Type.CHARGED_ARROW:
			return load("res://scenes/attacks/arrow.tscn")
		Ability.Type.MAGIC_ARROW:
			return load("res://scenes/attacks/arrow.tscn")
		Ability.Type.MAGIC_BOMB:
			return load("res://scenes/attacks/magic_bomb.tscn")
		Ability.Type.MAGIC_BOMB_FOCUSED:
			return load("res://scenes/attacks/magic_bomb_focused.tscn")
	
	return null
