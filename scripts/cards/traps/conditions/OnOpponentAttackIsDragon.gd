extends Resource
class_name OnOpponentAttackIsDragon








func check(attacker, _defender, trap) -> bool:

    if attacker.is_player_slot == trap.owner.is_player_slot:
        return false


    var stored_card_data = attacker.stored_card_data
    if stored_card_data == null:
        return false
    return stored_card_data.type == "Dragon"
