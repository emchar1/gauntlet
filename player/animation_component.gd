extends Node
class_name AnimationComponent


# PROPERTIES

const LOCOMOTION_PLAYBACK_PATH = "parameters/Locomotion/playback"

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree


# FUNCTIONS

func play_animation(state: Player.State):
	match state:
		Player.State.IDLE:
			#animation_player.speed_scale = 1.0
			#animation_player.play("idle")
			get_locomotion().travel("idle")
		Player.State.RUN:
			#animation_player.speed_scale = 1.5
			#animation_player.play("run")
			get_locomotion().travel("run")
		Player.State.ATTACK:
			#animation_player.speed_scale = 1.0
			#animation_player.play("attack1")
			get_locomotion().travel("attack1")
		Player.State.HURT:
			animation_player.speed_scale = 1.0
			animation_player.play("hurt")
		Player.State.DEAD:
			animation_player.speed_scale = 1.0


# Helper function to get locomotion playback parameter
func get_locomotion() -> AnimationNodeStateMachinePlayback:
	return animation_tree[LOCOMOTION_PLAYBACK_PATH]
