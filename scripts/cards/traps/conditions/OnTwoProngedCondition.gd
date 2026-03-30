extends Resource
class_name OnTwoProngedCondition







func check_summon(summoned_slot, card_data, trap) -> bool:

    if summoned_slot.is_player_slot == trap.owner.is_player_slot:
        return false
    if card_data == null:
        return false


    if summoned_slot.spawn_point.get_child_count() == 0:
        return false
    var visual = summoned_slot.spawn_point.get_child(0)
    var is_face_up = true
    if visual.has_method("is_face_down"):
        is_face_up = not visual.is_face_down()
    if not is_face_up:
        return false

    var dm = EffectManager.duel_manager
    if not dm: return false


    var my_slots = dm.player_slots if trap.owner.is_player_slot else dm.enemy_slots


    var my_monsters_count = 0
    var my_highest_atk = -1

    for slot in my_slots:
        if slot.is_occupied and slot.stored_card_data:

            var c = slot.stored_card_data
            if not dm._is_monster(c): continue


            if slot.spawn_point.get_child_count() == 0: continue
            var v = slot.spawn_point.get_child(0)
            var face_up = true
            if v.has_method("is_face_down"):
                face_up = not v.is_face_down()

            if face_up:
                my_monsters_count += 1
                if c.atk > my_highest_atk:
                    my_highest_atk = c.atk


    if my_monsters_count < 2:
        return false



    return card_data.atk > my_highest_atk
