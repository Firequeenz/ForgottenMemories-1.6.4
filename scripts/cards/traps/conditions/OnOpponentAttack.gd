extends Resource
class_name OnOpponentAttack








func check(attacker, _defender, trap: TrapData) -> bool:


    return attacker.is_player_slot != trap.owner.is_player_slot
