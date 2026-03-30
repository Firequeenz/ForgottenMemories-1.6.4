extends Resource
class_name OnOpponentSummonsLowAtk








const MAX_ATK = 500

func check_summon(summoned_slot, card_data, trap) -> bool:

    if summoned_slot.is_player_slot == trap.owner.is_player_slot:
        return false


    if card_data == null:
        return false


    if card_data.atk > MAX_ATK:
        return false


    if summoned_slot.spawn_point.get_child_count() == 0:
        return false

    var visual = summoned_slot.spawn_point.get_child(0)
    var is_face_up = true


    if visual.has_method("is_face_down"):
        is_face_up = not visual.is_face_down()

    return is_face_up
