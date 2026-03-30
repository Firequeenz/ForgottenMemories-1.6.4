extends Resource
class_name MirrorForceEffect






func apply(attacker, _defender, _trap):
    var dm = EffectManager.duel_manager
    if not dm:
        push_error("MirrorForceEffect: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    print("Mirror Force: Ativando efeito!")


    var opponent_is_player = attacker.is_player_slot


    var target_slots = dm.player_slots if opponent_is_player else dm.enemy_slots
    var monsters_to_destroy: Array = []


    if attacker and attacker.is_occupied:
        print("Mirror Force: Marcando atacante: ", attacker.stored_card_data.name)
        monsters_to_destroy.append(attacker)


    for slot in target_slots:
        if slot == attacker:
            continue

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



        var rotation = visual.rotation_degrees

        var is_attack_position = (abs(rotation) < 5 or abs(rotation - 180) < 5 or abs(rotation + 180) < 5)

        if is_attack_position:
            print("Mirror Force: Marcando para destruição extra: ", slot.stored_card_data.name)
            monsters_to_destroy.append(slot)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout


    for slot in monsters_to_destroy:
        if slot.is_occupied and slot.stored_card_data:
            print("Mirror Force: Destruindo ", slot.stored_card_data.name)
            await dm._destroy_card(slot)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Mirror Force: ", monsters_to_destroy.size(), " monstro(s) destruído(s) no total!")
    print("Mirror Force: Efeito completo!")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
