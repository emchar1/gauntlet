extends CharacterBody3D
class_name Enemy

# PROPERTIES

signal died

enum State {
	NONE, IDLE, RUN, ATTACK, HURT, DEAD
}

@onready var animation_player = $AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var hp_bar = $HPBar

var enemy_config: EnemyConfig
var player: Player
var current_state: State
var player_in_attack_range: bool = false

var has_spawned: bool = false
var is_slaying: bool = false
var fast_is_attacking: bool = false
var fast_is_lunging: bool = false
var current_hp: float
var knockback_strength: float = 0
var interrupt_strength: int = 0

var current_speed: float = 0
var move_dir: Vector3 = Vector3.ZERO

var death_sounds_melee: Array[AudioData.AudioKey] = [
	AudioData.AudioKey.ENEMY0_DIE1,
	AudioData.AudioKey.ENEMY0_DIE2,
	AudioData.AudioKey.ENEMY0_DIE3,
	AudioData.AudioKey.ENEMY0_DIE4,
]

var death_sounds_fast: Array[AudioData.AudioKey] = [
	AudioData.AudioKey.ENEMY1_DIE1,
	AudioData.AudioKey.ENEMY1_DIE2,
	AudioData.AudioKey.ENEMY1_DIE3,
	AudioData.AudioKey.ENEMY1_DIE4,
]


# FUNCTIONS

func _ready() -> void:
	_setup_enemy()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_process_movement()
	hp_bar.position_hp(self)
	
	if fast_is_attacking and not is_slaying:
		_move_towards_player(enemy_config.speed * 2, false)
	
	move_and_slide()


func _setup_enemy():
	hp_bar.setup_values(enemy_config.hp)
	current_hp = enemy_config.hp
	_update_state(State.RUN)


# Anchors the player to the ground.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta


# Movement and follow player
func _process_movement():
	if is_slaying:
		_stop_movement()
		return
	
	if not _can_target_player():
		_stop_movement()
		player_in_attack_range = false
		_update_state(State.IDLE)
		return
	
	if current_state == State.IDLE:
		await get_tree().create_timer(2.0).timeout
		current_speed = 0
		_update_state(State.RUN)
	
	if current_state != State.RUN:
		_stop_movement()
		return
	
	current_speed = move_toward(
		current_speed,
		enemy_config.speed,
		enemy_config.acceleration * get_physics_process_delta_time()
	)
	
	_move_towards_player(current_speed)


func _move_towards_player(movement_speed: float, snap_follow: bool = true):
	if not _can_target_player():
		_stop_movement()
		return
	
	nav_agent.target_position = player.global_position
	
	var next_nav_point = nav_agent.get_next_path_position()
	var path_dir = next_nav_point - global_position
	
	path_dir.y = 0
	path_dir = path_dir.normalized()
	
	if snap_follow:
		move_dir = path_dir
	else:
		if not fast_is_lunging:
			# Loosely follows the player, i.e. used for fast enemy attack.
			move_dir = move_dir.slerp(path_dir, 0.1).normalized()
	
	velocity.x = move_dir.x * movement_speed
	velocity.z = move_dir.z * movement_speed
	
	# Rotate enemy to face player
	if path_dir.length_squared() > 0.0:
		look_at(global_position + move_dir, Vector3.UP)


# Updates the current state and animation
func _update_state(state: State):
	current_state = state
	
	if current_state != State.ATTACK:
		fast_is_attacking = false
		fast_is_lunging = false
	
	match state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.ATTACK:
			animation_player.play("attack")
		State.HURT:
			if knockback_strength > 1:
				animation_player.play("hurt_knockback")
			else:
				animation_player.play("hurt")
		State.DEAD:
			animation_player.play("dead")
		_:
			animation_player.play("RESET")


func _can_target_player() -> bool:
	return player != null and player.move_state != Player.MoveState.DEAD


func _stop_movement():
	velocity.x = 0
	velocity.z = 0


# OTHER FUNCTIONS

func spawn():
	if has_spawned:
		return
	
	has_spawned = true
	
	#var tween = create_tween()
	#tween.tween_property(
		#self,
		#"scale",
		#mob_config.scale,
		#mob_config.spawn_duration
	#)


# This is what registers enemy hurtbox from player's hitbox, i.e. arrow.
func damage(
	amount: float,
	direction: Vector2,
	knockback: float,
	interrupt: int
):
	if not has_spawned:
		return
	
	if is_slaying:
		return
	
	match interrupt:
		1: current_speed *= 0.5
		2: current_speed = 0
	
	current_hp -= amount
	current_hp = clamp(current_hp, 0, enemy_config.hp)
	hp_bar.update_health(current_hp, amount > 0)
	
	# Need to preserve these values!!!
	knockback_strength = knockback
	interrupt_strength = interrupt
	
	if interrupt > 0:
		_update_state(State.HURT)
	
	if knockback > 1:
		apply_knockback(direction, knockback)
	
	if current_hp <= 0:
		call_deferred("slay")


func apply_knockback(direction: Vector2, knockback: float):
	var knockback_direction := GameState.map_2d_to_3d(direction.normalized())
	var target_position := global_position + knockback_direction * knockback
	
	var knockback_tween := create_tween()
	knockback_tween.set_trans(Tween.TRANS_CUBIC)
	knockback_tween.set_ease(Tween.EASE_OUT)
	knockback_tween.set_parallel(true)
	
	knockback_tween.tween_property(
		self,
		"global_position",
		target_position,
		0.5
	)


func slay():
	if is_slaying:
		return
	
	is_slaying = true
	turn_off_collisions()
	_update_state(State.DEAD)
	
	var meshes := $Visuals.find_children("*", "MeshInstance3D", true, false)
	var slay_speed := 3.0
	var slay_tween := create_tween()
	slay_tween.set_parallel(true)
	
	for mesh in meshes:
		var material = mesh.get_active_material(0)
		
		if material == null:
			continue
		
		material = material.duplicate()
		mesh.material_override = material
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		
		slay_tween.tween_property(
			material,
			"albedo_color",
			Color.BLACK,
			slay_speed
		)
		
		slay_tween.tween_property(
			material,
			"albedo_color:a",
			0.0,
			slay_speed
		)
	
	var death_sound = death_sounds_melee.pick_random()
	
	if enemy_config.enemy_type == EnemyConfig.EnemyType.FAST:
		death_sound = death_sounds_fast.pick_random()
	
	if not AudioManager.is_playing(death_sound):
		AudioManager.play(death_sound)
	
	if not AudioManager.is_playing(AudioData.AudioKey.ARROW_KILL):
		AudioManager.play(
			AudioData.AudioKey.ARROW_KILL,
			0.0,
			Vector2.ZERO,
			true
		)
	
	slay_tween.finished.connect(queue_free)
	died.emit()


func turn_off_collisions():
	set_collision_layer_value(GameState.COLLISION_ENEMY_BODY, false)
	set_collision_mask_value(GameState.COLLISION_PLAYER_BODY, false)
	set_collision_mask_value(GameState.COLLISION_ENEMY_BODY, false)
	set_collision_mask_value(GameState.COLLISION_SPAWNER_BODY, false)
	
	$Hurtbox.set_collision_layer_value(GameState.COLLISION_ENEMY_HURT, false)
	$Hurtbox.set_collision_mask_value(GameState.COLLISION_PLAYER_HIT, false)
	
	$Hitbox.set_collision_layer_value(GameState.COLLISION_ENEMY_HIT, false)
	$Hitbox.set_collision_mask_value(GameState.COLLISION_PLAYER_HURT, false)


# SIGNAL FUNCTIONS

# And this registers when player gets hit by enemy.
func _on_hitbox_area_entered(area: Area3D) -> void:
	if not _can_target_player():
		return
	
	if area.is_in_group("hurtbox"):
		player.update_hp(-enemy_config.attack_dmg)


# This detector triggers when player enters enemy's PlayerDetector.
func _on_player_detector_body_entered(body: Node3D) -> void:
	if not _can_target_player():
		return
	
	if body.is_in_group("player"):
		player_in_attack_range = true
		
		if current_state == State.RUN:
			_update_state(State.ATTACK)


# This triggers when player leaves PlayerDetector.
func _on_player_detector_body_exited(body: Node3D) -> void:
	if not _can_target_player():
		return
	
	if body.is_in_group("player"):
		player_in_attack_range = false


# And this causes enemy to re-attack if player is still in detector.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not _can_target_player():
		return
	
	if is_slaying:
		return
	
	if anim_name == "attack" \
	or anim_name == "hurt" \
	or anim_name == "hurt_knockback":
		if player_in_attack_range:
			_update_state(State.ATTACK)
		else:
			if anim_name == "hurt" or anim_name == "hurt_knockback":
				if interrupt_strength > 0:
					_update_state(State.IDLE)
					await get_tree().create_timer(interrupt_strength).timeout
					
					if is_slaying:
						return
			
			_update_state(State.RUN)


# ANIMATION CALLBACK FUNCTIONS

func _fast_attack_start():
	if enemy_config.enemy_type == EnemyConfig.EnemyType.FAST:
		fast_is_attacking = true


func _fast_attack_commit():
	if enemy_config.enemy_type == EnemyConfig.EnemyType.FAST:
		fast_is_lunging = true


func _fast_attack_end():
	if enemy_config.enemy_type == EnemyConfig.EnemyType.FAST:
		fast_is_attacking = false
		fast_is_lunging = false
