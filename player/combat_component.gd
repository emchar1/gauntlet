extends Node
class_name CombatComponent


# PROPERTIES

var is_attacking := false


# FUNCTIONS

# Executes attack for the specified actor (player, enemy, etc.)
func start_attack(_actor: CharacterBody3D) -> bool:
	if is_attacking:
		return false
	
	is_attacking = true
	return true


# Ends the attack for the player.
func end_attack(_actor: CharacterBody3D) -> void:
	is_attacking = false
