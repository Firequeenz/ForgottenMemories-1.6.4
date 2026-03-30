extends Resource
class_name DestroySummonedMonsterEffect



func apply_on_summon(summoned_slot, card_data, _trap) -> void :
    print("DestroySummonedMonster: Ativando efeito!")

    var dm = EffectManager.duel_manager
    if not dm:
        push_error("DestroySummonedMonster: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    if not summoned_slot or not summoned_slot.stored_card_data:
        print("DestroySummonedMonster: Slot vazio ou inválido.")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return

    print("DestroySummonedMonster: Destruindo ", card_data.name)


    await dm.get_tree().create_timer(0.5).timeout


    await dm._destroy_card(summoned_slot)

    print("DestroySummonedMonster: Monstro destruído!")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
