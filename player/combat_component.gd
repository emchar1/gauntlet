extends Node
class_name CombatComponent


# PROPERTIES

signal attack_executed(ability: Ability)

@export var input_component: InputComponent
@export var dodge_component: DodgeComponent

# Abilities Resources
@export var quick_arrow: Ability
@export var charged_arrow: Ability
@export var timed_bomb: Ability
#@export var ultimate_arrow: Ability

var ability_timers: Dictionary = {}

# States
var is_aiming := false
var is_performing_ultimate := false


# FUNCTIONS

# Initializes ability_timers for first use.
func set_ability_timers() -> void:
	ability_timers[quick_arrow] = 0.0
	ability_timers[charged_arrow] = 0.0
	ability_timers[timed_bomb] = 0.0
	#ability_timers[ultimate_arrow] = 0.0


# Update ability timers on a clock tick.
func update_ability_timers(delta: float) -> void:
	for ability in ability_timers:
		ability_timers[ability] -= delta
		print(ability_timers[ability])


# Executes attack for the specified actor (player, enemy, etc.)
func execute_attack(actor: CharacterBody3D, ability: Ability) -> void:
	if not _can_use(ability):
		return
	
	attack_executed.emit(ability)
	_use_ability(actor, ability)


# HELPER FUNCTIONS

# Uses attack ability. Assumes 'actor' has a property, 'facing_dir'.
func _use_ability(actor: CharacterBody3D, ability: Ability) -> void:
	# Create Ability object
	var obj = ability.scene.instantiate()
	obj.setup(actor.global_position, actor.facing_dir)
	
	ability.configure(obj)
	get_tree().current_scene.add_child(obj)
	
	# Update timers
	ability_timers[ability] = ability.cooldown


# Checks if ability cooldown has been met and is ready for use.
func _can_use(ability: Ability) -> bool:
	if dodge_component.is_dodging and not ability.usable_while_dodging:
		return false
	
	if not ability_timers.has(ability):
		return true
	
	return ability_timers[ability] <= 0
