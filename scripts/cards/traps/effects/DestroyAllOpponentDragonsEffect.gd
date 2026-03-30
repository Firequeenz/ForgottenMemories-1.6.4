extends Resource
class_name DestroyAllOpponentDragonsEffect






func apply(_attacker, _defender, trap) -> void :
    print("Dragon Capture Jar: Ativando efeito!")


    var opponent_is_player = not trap.owner.is_player_slot



    var dm = EffectManager.duel_manager
    if not dm:
        push_error("DestroyAllOpponentDragonsEffect: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    var opponent_slots = dm.player_slots if opponent_is_player else dm.enemy_slots


    var dragons_to_destroy: Array = []


    for slot in opponent_slots:
        if not slot.is_occupied:
            continue

        var card_data = slot.stored_card_data
        if not card_data:
            continue


        if card_data.monster_type != "Dragon":



            if card_data.type != "Dragon":
                 continue
            pass

        if card_data.type != "Dragon":
            continue


        if slot.spawn_point.get_child_count() == 0:
            continue

        var visual = slot.spawn_point.get_child(0)
        var is_face_up = true


        if visual.has_method("is_face_down"):
            is_face_up = not visual.is_face_down

        if is_face_up:
            print("Dragon Capture Jar: Marcando para destruição: ", card_data.name)
            dragons_to_destroy.append(slot)


    for slot in dragons_to_destroy:
        if slot.stored_card_data:
            print("Dragon Capture Jar: Destruindo ", slot.stored_card_data.name)
            await dm._destroy_card(slot)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Dragon Capture Jar: ", dragons_to_destroy.size(), " dragon(s) destruído(s)!")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
