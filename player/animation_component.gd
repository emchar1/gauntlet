extends Node
class_name AnimationComponent


# PROPERTIES

const LOCOMOTION_PLAYBACK_PATH = "parameters/Locomotion/playback"
const COMBAT_ONESHOT_PATH = "parameters/OneShot/request"

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree


# FUNCTIONS

func play_animation(state: Player.State):
	match state:
		Player.State.IDLE:
			get_locomotion().travel("idle")
		Player.State.RUN:
			get_locomotion().travel("run")
		Player.State.ATTACK:
			play_one_shot()
		Player.State.HURT:
			animation_player.speed_scale = 1.0
			animation_player.play("hurt")
		Player.State.DEAD:
			animation_player.speed_scale = 1.0


func play_locomotion(state: Player.State):
	match state:
		Player.State.IDLE:
			get_locomotion().travel("idle")
		Player.State.RUN:
			get_locomotion().travel("run")


func play_combat(state: Player.State):
	if state == Player.State.ATTACK:
		play_one_shot()
	elif state == Player.State.NONE:
		print("You dun fucked up.")


# Helper function to get locomotion playback parameter
func get_locomotion() -> AnimationNodeStateMachinePlayback:
	return animation_tree[LOCOMOTION_PLAYBACK_PATH]


# OneShot Helper
func play_one_shot():
	animation_tree[COMBAT_ONESHOT_PATH] = \
	AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
