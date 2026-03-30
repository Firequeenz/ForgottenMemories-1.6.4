extends Resource
class_name CrushCardEffect




const MIN_ATK = 1500
var MONSTER_CARD = [CardData.CardCategory.NORMAL_MONSTER, CardData.CardCategory.EFFECT_MONSTER, CardData.CardCategory.FUSION_MONSTER, CardData.CardCategory.RITUAL_MONSTER, CardData.CardCategory.SYNCHRO_MONSTER, CardData.CardCategory.XYZ_MONSTER, CardData.CardCategory.PENDULUM_MONSTER, CardData.CardCategory.LINK_MONSTER]

func apply_on_summon(summoned_slot, _card_data, trap) -> void :
    print("Crush Card: Ativando efeito!")

    var dm = EffectManager.duel_manager
    if not dm:
        push_error("CrushCardEffect: DuelManager não encontrado!")
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1


    var opponent_is_player = not trap.owner.is_player_slot


    var opponent_slots = dm.player_slots if opponent_is_player else dm.enemy_slots
    var monsters_to_destroy: Array = []


    if summoned_slot and summoned_slot.stored_card_data:

        if EffectManager._is_card_face_up(summoned_slot, opponent_is_player):
            if summoned_slot.stored_card_data.atk >= MIN_ATK:
                print("Crush Card: Marcando monstro invocado: ", summoned_slot.stored_card_data.name)
                monsters_to_destroy.append(summoned_slot)


    for slot in opponent_slots:
        if slot == summoned_slot:
            continue

        if not slot.is_occupied:
            continue

        var card = slot.stored_card_data
        if not card:
            continue


        if card.category not in MONSTER_CARD:
            continue

        if card.atk < MIN_ATK:
            continue


        if EffectManager._is_card_face_up(slot, opponent_is_player):
            print("Crush Card: Marcando para destruição no campo: ", card.name, " (ATK: ", card.atk, ")")
            monsters_to_destroy.append(slot)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout


    for slot in monsters_to_destroy:
        print("Crush Card: Destruindo ", slot.stored_card_data.name)
        await dm._destroy_card(slot)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Crush Card: ", monsters_to_destroy.size(), " monstro(s) destruído(s) no campo!")


    var opponent_deck = dm.player_deck_pile if opponent_is_player else dm.enemy_deck_pile

    if opponent_deck.is_empty():
        print("Crush Card: Deck do oponente está vazio!")
        if "additional_processing_lock" in dm: dm.additional_processing_lock -= 1
        return


    var high_atk_indices: Array = []
    for i in range(opponent_deck.size()):
        var card = opponent_deck[i]
        if card.category in MONSTER_CARD and card.atk >= MIN_ATK:
            high_atk_indices.append(i)

    if high_atk_indices.is_empty():
        print("Crush Card: Nenhum monstro com ATK >= 1500 no deck do oponente!")
        if "additional_processing_lock" in dm: dm.additional_processing_lock -= 1
        return


    var random_index = high_atk_indices[randi() % high_atk_indices.size()]
    var destroyed_card = opponent_deck[random_index]

    print("Crush Card: Destruindo do deck: ", destroyed_card.name, " (ATK: ", destroyed_card.atk, ")")

    if dm:
        await dm.get_tree().create_timer(0.5).timeout


    opponent_deck[random_index] = destroyed_card
    opponent_deck.remove_at(random_index)


    if opponent_is_player:
        dm.player_graveyard.append(destroyed_card)
        if dm.player_gy_visual and dm.player_gy_visual.has_method("update_graveyard"):
            dm.player_gy_visual.update_graveyard(dm.player_graveyard)
    else:
        dm.enemy_graveyard.append(destroyed_card)
        if dm.enemy_gy_visual and dm.enemy_gy_visual.has_method("update_graveyard"):
            dm.enemy_gy_visual.update_graveyard(dm.enemy_graveyard)

    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Crush Card: Carta enviada do deck para o cemitério!")
    print("Crush Card: Efeito completo!")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1
