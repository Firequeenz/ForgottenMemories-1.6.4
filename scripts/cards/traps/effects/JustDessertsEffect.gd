extends Resource
class_name JustDessertsEffect





func apply_on_summon(summoned_slot, _card_data, _trap) -> void :
    print("Just Desserts: Ativando efeito!")

    var dm = EffectManager.duel_manager
    if not dm:
        push_error("JustDessertsEffect: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1


    var is_player_target = summoned_slot.is_player_slot


    var target_slots = dm.player_slots if is_player_target else dm.enemy_slots


    var monster_count = 0
    for slot in target_slots:
        if slot.is_occupied:
            monster_count += 1

    print("Just Desserts: Inimigo possui %d monstros em campo." % monster_count)


    var total_damage = monster_count * 500

    if total_damage <= 0:
        print("Just Desserts: Zero monstros no oponente (inesperado), dano zero.")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return

    print("Just Desserts: Aplicando %d de dano!" % total_damage)


    await dm.get_tree().create_timer(1.0).timeout


    if is_player_target:
        dm.player_lp -= total_damage
    else:
        dm.enemy_lp -= total_damage


    if dm.has_method("update_lp_ui"):
        dm.update_lp_ui()


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1

    print("Just Desserts: Efeito concluído!")
