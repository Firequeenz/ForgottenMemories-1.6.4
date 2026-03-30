extends Resource
class_name OnOpponentMagicActivation



func check(target_card, _defender, _trap: TrapData) -> bool:
    if target_card == null or not (target_card is CardData):
        return false


    if target_card.type == "Magic":
        return true

    return false
