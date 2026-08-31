extends Area3D


# PROPERTIES

enum BombType { 
	NORMAL, FOCUSED
}

@export var bomb_type: BombType

var direction := Vector2.ZERO

var damage: float = 2
var speed: float = 10
var knockback: float = 0
var interrupt: int = 0
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


func setup(pos: Vector3, dir: Vector2):
	var player_offset = Vector3(0, -2.5, 0)
	
	if bomb_type == BombType.NORMAL:
		position = pos + player_offset
		AudioManager.play(AudioData.AudioKey.BOMB_COOK)
	else:
		position = pos
	
	direction = dir
	rotation.y = -direction.angle() - (PI / 2.0)


# SIGNAL CALLBACK FUNCTIONS

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("hurtbox"):
		
		# Handle Enemy Hurt
		var enemy = area.get_parent() as Enemy
		if enemy:
			var direction_to_enemy = enemy.global_position - global_position
			var knockback_direction = GameState.map_3d_to_2d(direction_to_enemy)
			
			enemy.damage(damage, knockback_direction, knockback, interrupt)
		
		# Handle Spawner Hurt
		var spawner = area.get_parent() as EnemySpawner
		if spawner:
			spawner.damage(damage)


func _is_exploding():
	if bomb_type == BombType.NORMAL:
		GameState.shake_main_camera(1.5, 5)
		AudioManager.stop(AudioData.AudioKey.BOMB_COOK)
		AudioManager.play(AudioData.AudioKey.BOMB_EXPLODE)
		AudioManager.play(
			AudioData.AudioKey.BOMB_SPARKLE,
			0.0,
			Vector2.ZERO,
			true,
			1.2
		)
	else:
		var sound_volume := 0.0
		var sound_position := Vector2.ZERO
		var sound_should_vary_pitch := true
		var sound_pitch_scale := 1.5 
		
		GameState.shake_main_camera(2.5, 10)
		AudioManager.play(
			AudioData.AudioKey.BOMB_EXPLODE,
			sound_volume, 
			sound_position, 
			sound_should_vary_pitch, 
			sound_pitch_scale
		)
		AudioManager.play(
			AudioData.AudioKey.BOMB_SPARKLE,
			sound_volume, 
			sound_position, 
			sound_should_vary_pitch, 
			sound_pitch_scale
		)


# Must free up bomb after it explodes otherwise it'll keep stacking.
func _did_explode():
	queue_free()
