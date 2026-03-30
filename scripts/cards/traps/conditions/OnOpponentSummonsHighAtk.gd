extends Resource
class_name OnOpponentSummonsHighAtk








const MIN_ATK = 1500

func check_summon(summoned_slot, card_data, trap) -> bool:

    if summoned_slot.is_player_slot == trap.owner.is_player_slot:
        return false


    if card_data == null:
        return false

    return card_data.atk >= MIN_ATK
