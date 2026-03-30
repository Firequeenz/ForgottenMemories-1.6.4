extends Resource
class_name OnOpponentCardPlayWithField






var required_field_id: int = 756

func check(target_card, _defender, _trap: TrapData) -> bool:
    if target_card == null or not (target_card is CardData):
        return false


    if EffectManager.active_field_id != required_field_id:
        return false

    return true
