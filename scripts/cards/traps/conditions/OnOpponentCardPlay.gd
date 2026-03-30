extends Resource
class_name OnOpponentCardPlay









func check(_trap: TrapData, target_card, _defender) -> bool:
    if target_card == null or not (target_card is CardData):
        return false

    return true
