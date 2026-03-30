extends Resource
class_name OnOpponentPlaysEquip



func check_equip(target_slot, _equip_id, trap) -> bool:

    if target_slot.is_player_slot == trap.owner.is_player_slot:
        return false


    return true
