extends Node
class_name CombatComponent


# PROPERTIES

signal attack_executed(ability: Ability)
signal charge_started
signal charge_ended

@export var input_component: InputComponent
@export var dodge_component: DodgeComponent

# Abilities Resources
@export var quick_arrow: Ability
@export var charged_arrow: Ability
#@export var timed_bomb: Ability
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
	#ability_timers[timed_bomb] = 0.0
	#ability_timers[ultimate_arrow] = 0.0


# Update ability timers on a clock tick.
func update_ability_timers(delta: float) -> void:
	for ability in ability_timers:
		ability_timers[ability] -= delta
		print(ability_timers[ability])


# Executes attack for the specified actor (player, enemy, etc.)
func execute_attack(actor: CharacterBody3D) -> void:
	if input_component.charge_pressed:
		print("charge_pressed")
		charge_started.emit()
		
	elif input_component.charge_released:
		print("charge_released")
		charge_ended.emit()
		
		if not _can_use(charged_arrow):
			return
		
		attack_executed.emit(charged_arrow)
		_use_ability(actor, charged_arrow)
		
	elif input_component.main_pressed:
		print("quick_pressed")
		if not _can_use(quick_arrow):
			return
		
		attack_executed.emit(quick_arrow) # ORDER MATTERS!!! MUST GO HERE!
		_use_ability(actor, quick_arrow)
		
	# No need to check input_component.main_released (yet).


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
