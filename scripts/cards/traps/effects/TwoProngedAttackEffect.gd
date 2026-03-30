extends Resource
class_name TwoProngedAttackEffect




func apply_on_summon(_summoned_slot, _card_data, trap) -> void :
    print("Two-Pronged Attack: Ativando efeito!")

    var dm = EffectManager.duel_manager
    if not dm: return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    var is_player_owner = trap.owner.is_player_slot
    var my_slots = dm.player_slots if is_player_owner else dm.enemy_slots
    var opp_slots = dm.enemy_slots if is_player_owner else dm.player_slots


    var my_monsters = []

    for slot in my_slots:
        if slot.is_occupied and slot.stored_card_data and dm._is_monster(slot.stored_card_data):
            if _is_face_up(slot):
                my_monsters.append(slot)


    my_monsters.sort_custom( func(a, b): return a.stored_card_data.atk < b.stored_card_data.atk)

    if my_monsters.size() < 2:
        print("Two-Pronged Attack: Falha - Menos de 2 monstros para sacrificar.")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return

    var sacrifices = [my_monsters[0], my_monsters[1]]


    var opp_monsters = []
    for slot in opp_slots:
        if slot.is_occupied and slot.stored_card_data and dm._is_monster(slot.stored_card_data):
             if _is_face_up(slot):
                opp_monsters.append(slot)


    opp_monsters.sort_custom( func(a, b): return a.stored_card_data.atk > b.stored_card_data.atk)

    var target = null
    if opp_monsters.size() > 0:
        target = opp_monsters[0]




    await dm.get_tree().create_timer(0.5).timeout


    for slot in sacrifices:
        print("Two-Pronged Attack: Sacrificando ", slot.stored_card_data.name)
        await dm._destroy_card(slot)


    if target:
        print("Two-Pronged Attack: Destruindo alvo ", target.stored_card_data.name)
        await dm._destroy_card(target)

    print("Two-Pronged Attack: Efeito completo!")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1

func _is_face_up(slot) -> bool:
    if slot.spawn_point.get_child_count() == 0: return false
    var v = slot.spawn_point.get_child(0)
    if v.has_method("is_face_down"):
        return not v.is_face_down()
    return true
