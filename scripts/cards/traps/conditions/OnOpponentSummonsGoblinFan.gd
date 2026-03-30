extends Resource
class_name OnOpponentSummonsGoblinFan



func is_met(trigger_type: String, data: Dictionary, trap) -> bool:
    if trigger_type != "summon":
        return false


    var is_player_trap = trap.owner.is_player_slot
    var is_player_summon = data.get("is_player_summon", false)


    if is_player_trap == is_player_summon:
        return false

    var summoned_card = data.get("summoned_card")
    if not summoned_card:
        return false

    var dm = EffectManager.duel_manager
    if not dm or not dm._is_monster(summoned_card):
        return false


    var level = summoned_card.level if "level" in summoned_card else 0
    if level > 2:
        return false


    var summoned_slot = data.get("summoned_slot")
    if not summoned_slot:
         return false

    if summoned_slot.spawn_point.get_child_count() == 0:
        return false

    var visual = summoned_slot.spawn_point.get_child(0)
    var is_face_up = true

    if visual.has_method("is_face_down"):
        is_face_up = not visual.is_face_down()

    return is_face_up
