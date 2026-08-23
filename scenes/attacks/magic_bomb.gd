extends Area3D


# PROPERTIES

var color: Color

var damage: float = 2
var speed: float = 10
var knockback: float = 0
var max_distance: float = 40

var obeys_gravity: bool = true
var piercing: bool = false
var explodes: bool = false
var usable_while_dodging: bool = false


# FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func setup(pos: Vector3, _dir: Vector2):
	position = pos


# SIGNAL CALLBACK FUNCTIONS

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurtbox"):
		var enemy = area.get_parent() as Enemy
		
		if not enemy:
			return
		
		var direction_to_enemy = enemy.global_position - global_position
		var direction = GameState.map_3d_to_2d(direction_to_enemy)
		
		enemy.damage(damage, direction, knockback)


# Must free up bomb after it explodes otherwise it'll keep stacking.
func _did_explode():
	queue_free()
