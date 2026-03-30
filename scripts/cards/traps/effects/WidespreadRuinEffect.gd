extends Resource
class_name WidespreadRuinEffect





func apply(attacker, _defender, _trap) -> void :
    var dm = EffectManager.duel_manager
    if not dm:
        push_error("WidespreadRuinEffect: DuelManager não encontrado!")
        return

    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1


    var attacker_is_player = attacker.is_player_slot
    var attacker_slots = dm.player_slots if attacker_is_player else dm.enemy_slots

    var best_slot = null
    var best_atk = -1


    for slot in attacker_slots:
        if not slot.is_occupied or not slot.stored_card_data:
            continue

        if slot.spawn_point.get_child_count() == 0:
            continue

        var visual = slot.spawn_point.get_child(0)


        var is_face_up = true
        if visual.has_method("is_face_down"):
            is_face_up = not visual.is_face_down()
        if not is_face_up:
            continue


        var rot = visual.rotation_degrees
        var is_attack_pos = (abs(rot) < 5 or abs(rot - 180) < 5 or abs(rot + 180) < 5)
        if not is_attack_pos:
            continue

        var atk = slot.stored_card_data.atk
        if atk > best_atk:
            best_atk = atk
            best_slot = slot

    await dm.get_tree().create_timer(0.5).timeout

    if best_slot and best_slot.is_occupied and best_slot.stored_card_data:
        print("Widespread Ruin: Destruindo ", best_slot.stored_card_data.name, " (ATK: ", best_atk, ")")
        await dm._destroy_card(best_slot)
    else:
        print("Widespread Ruin: Nenhum alvo válido encontrado.")

    await dm.get_tree().create_timer(0.3).timeout

    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
