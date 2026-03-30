extends Resource
class_name OnOpponentTrapActivation




func check_negation(activating_trap, seven_tools) -> bool:

    return activating_trap.owner.is_player_slot != seven_tools.owner.is_player_slot
