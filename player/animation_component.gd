extends Node
class_name AnimationComponent


# PROPERTIES

# Animation constants
const ANIM_IDLE = "idle"
const ANIM_RUN = "run"
const ANIM_DODGE = "dodge"
const ANIM_ATTACK_START = "attack_start"
const ANIM_ATTACK_LOOP = "attack_loop"
const ANIM_ATTACK_LOOP_SLOW = "attack_loop_slow"
const ANIM_ATTACK_END = "attack_end"

# AnimationTree constants
const LOCOMOTION_PLAYBACK_PATH = "parameters/Locomotion/playback"
const COMBAT_PLAYBACK_PATH = "parameters/Combat/playback"
const ONESHOT_PATH = "parameters/OneShot/request"

@export var animation_tree: AnimationTree


# FUNCTIONS

func play_locomotion(state: Player.MoveState):
	match state:
		Player.MoveState.IDLE:
			get_locomotion().travel(ANIM_IDLE)
		Player.MoveState.RUN:
			get_locomotion().travel(ANIM_RUN)
		Player.MoveState.DODGE:
			get_locomotion().travel(ANIM_DODGE)


func play_combat(state: Player.AttackState, charged: bool):
	match state:
		Player.AttackState.NONE:
			stop_one_shot()
		Player.AttackState.STARTING:
			play_one_shot()
			get_combat().travel(ANIM_ATTACK_START)
		Player.AttackState.CHARGED:
			# Hold the final frame of attack_start.
			pass
		Player.AttackState.FIRING:
			play_one_shot()
			
			if charged:
				get_combat().travel(ANIM_ATTACK_LOOP_SLOW)
			else:
				get_combat().travel(ANIM_ATTACK_LOOP)
		Player.AttackState.ENDING:
			get_combat().travel(ANIM_ATTACK_END)


# HELPER FUNCTIONS

# Returns true if dodge animation is currently playing.
func is_dodge_animation_playing() -> bool:
	return get_locomotion().get_current_node() == ANIM_DODGE


# Helper function to get locomotion playback parameter
func get_locomotion() -> AnimationNodeStateMachinePlayback:
	return animation_tree[LOCOMOTION_PLAYBACK_PATH]


# Helper function to get combat playback parameter
func get_combat() -> AnimationNodeStateMachinePlayback:
	return animation_tree[COMBAT_PLAYBACK_PATH]


# OneShot Play Helper
func play_one_shot():
	animation_tree[ONESHOT_PATH] = \
	AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


# OneShot Stop Helper
func stop_one_shot():
	animation_tree[ONESHOT_PATH] = \
	AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
