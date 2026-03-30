extends Resource
class_name ReleaseFromStoneEffect





func apply_on_summon(_summoned_slot, _card_data, trap) -> void :
    print("Release from Stone: Ativando efeito!")

    var dm = EffectManager.duel_manager
    if not dm:
        push_error("ReleaseFromStoneEffect: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    var owner_is_player = trap.owner.is_player_slot


    var owner_slots = dm.player_slots if owner_is_player else dm.enemy_slots
    var empty_slot = null
    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Release from Stone: Nenhum slot vazio disponível!")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return


    var owner_graveyard = dm.player_graveyard if owner_is_player else dm.enemy_graveyard
    var rock_monsters = []

    for card in owner_graveyard:
        if card and card.type and card.type.to_lower() == "rock":
            rock_monsters.append(card)

    if rock_monsters.is_empty():
        print("Release from Stone: Nenhum monstro Rock encontrado no cemitério.")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return


    rock_monsters.shuffle()
    var chosen_monster = rock_monsters[0]

    print("Release from Stone: Revivendo '%s' (ATK %d) do cemitério!" % [chosen_monster.name, chosen_monster.atk])


    var new_card_data = chosen_monster.get_copy()


    owner_graveyard.erase(chosen_monster)


    if owner_is_player:
        if dm.player_gy_visual and dm.player_gy_visual.has_method("update_graveyard"):
            dm.player_gy_visual.update_graveyard(dm.player_graveyard)
    else:
        if dm.enemy_gy_visual and dm.enemy_gy_visual.has_method("update_graveyard"):
            dm.enemy_gy_visual.update_graveyard(dm.enemy_graveyard)


    await dm.get_tree().create_timer(0.5).timeout




    if dm.has_method("spawn_card_on_field"):

        await dm.spawn_card_on_field(
            new_card_data, 
            empty_slot, 
            false, 
            owner_is_player, 
            false, 
            true
        )

    print("Release from Stone: '%s' invocado com sucesso!" % new_card_data.name)


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
