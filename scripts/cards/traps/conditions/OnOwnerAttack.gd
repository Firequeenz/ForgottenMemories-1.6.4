extends Resource
class_name OnOwnerAttack





func check(attacker, _defender, trap: TrapData) -> bool:
    if attacker == null or not is_instance_valid(attacker):
        return false


    var owner_is_player = trap.owner.is_player_slot
    var attacker_is_player = attacker.is_player_slot


    if owner_is_player == attacker_is_player:
        return true

    return false
