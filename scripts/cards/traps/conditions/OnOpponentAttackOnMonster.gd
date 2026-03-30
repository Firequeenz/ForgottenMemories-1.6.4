extends Resource
class_name OnOpponentAttackOnMonster





func check(attacker, defender, trap) -> bool:

    if attacker == null or trap.owner == null:
        return false

    if trap.owner.is_player_slot == attacker.is_player_slot:

        return false


    if defender == null or not defender.is_occupied:
        print("Ataque direto. Kunai with Chain não ativa.")
        return false


    return true
