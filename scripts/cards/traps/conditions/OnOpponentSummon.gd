extends Resource
class_name OnOpponentSummon




func check_summon(summoned_slot, _card_data, trap: TrapData) -> bool:

    if summoned_slot == null or trap.owner == null:
        return false


    var is_opponent_summon = (summoned_slot.is_player_slot != trap.owner.is_player_slot)

    if is_opponent_summon:
        print("OnOpponentSummon detectou invocação válida para ativar.")
        return true

    return false
