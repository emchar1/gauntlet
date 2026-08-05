extends Node
class_name CombatComponent


# PROPERTIES

#
#signal attack_executed(ability: Ability)
#signal charge_started
#signal charge_ended
#
## Abilities Resources
#@export var quick_arrow: Ability
#@export var charged_arrow: Ability
#@export var timed_bomb: Ability
#@export var ultimate_arrow: Ability
#
#var ability_timers: Dictionary = {}
#
## States
var is_attacking := false
#var is_aiming := false
#var is_performing_ultimate := false
#
#
## FUNCTIONS
#
## Initializes ability_timers for first use.
#func set_ability_timers() -> void:
	#ability_timers[quick_arrow] = 0.0
	#ability_timers[charged_arrow] = 0.0
	#ability_timers[timed_bomb] = 0.0
	#ability_timers[ultimate_arrow] = 0.0
#
#
## Update ability timers on a clock tick.
#func update_ability_timers(delta: float) -> void:
	#for ability in ability_timers:
		#ability_timers[ability] -= delta
#
#
# Executes attack for the specified actor (player, enemy, etc.)
func start_attack(_actor: CharacterBody3D) -> void:
	if is_attacking:
		return
	
	is_attacking = true
	## This ordering is important!
	#if input.ultimate_pressed:
		#if is_performing_ultimate:
			#return
		#
		#if not _can_use(ultimate_arrow, dodge_component):
			#return
		#
		#is_performing_ultimate = true
		#_use_ability(actor, ultimate_arrow)
		#attack_executed.emit(ultimate_arrow)
		#
		#await get_tree().create_timer(ultimate_arrow.cooldown).timeout
		#is_performing_ultimate = false
		#
	#elif input.special_pressed:
		#if is_performing_ultimate:
			#return
		#
		#if not _can_use(timed_bomb, dodge_component):
			#return
		#
		#_use_ability(actor, timed_bomb)
		#
	#elif input.charge_pressed:
		#if dodge_component.is_dodging:
			#return
		#
		#is_aiming = true
		#is_attacking = true
		#charge_started.emit()
		#
	#elif input.charge_released:
		#if dodge_component.is_dodging:
			#return
		#
		#is_aiming = false
		#charge_ended.emit()
		#
		#if not _can_use(charged_arrow, dodge_component):
			#return
		#
		#is_attacking = false
		#_use_ability(actor, charged_arrow)
		#
	#elif input.quick_pressed:
		#if is_performing_ultimate:
			#return
		#
		#if not _can_use(quick_arrow, dodge_component):
			#return
		#
		#is_attacking = true
		#attack_executed.emit(quick_arrow) # ORDER MATTERS!!! MUST GO HERE!
		#_use_ability(actor, quick_arrow)
	#
	#elif input.quick_released:
		#is_attacking = false


func end_attack(_actor: CharacterBody3D) -> void:
	is_attacking = false
#
#
## HELPER FUNCTIONS
#
## Uses attack ability. Assumes 'actor' has a property, 'facing_dir'.
#func _use_ability(actor: Node2D, ability: Ability) -> void:
	## Create Ability object
	#var obj = ability.scene.instantiate()
	#obj.setup(actor.global_position, actor.facing_dir)
	#
	#ability.configure(obj)
	#
	#get_tree().current_scene.add_child(obj)
	#
	## Update timers
	#ability_timers[ability] = ability.cooldown
#
#
## Checks if ability cooldown has been met and is ready for use.
#func _can_use(ability: Ability, dodge_component: DodgeComponent) -> bool:
	#if dodge_component.is_dodging and not ability.usable_while_dodging:
		#return false
	#
	#if not ability_timers.has(ability):
		#return true
	#
	#return ability_timers[ability] <= 0
