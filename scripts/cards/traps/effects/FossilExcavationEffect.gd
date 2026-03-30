extends Resource
class_name FossilExcavationEffect




func apply_on_summon(_summoned_slot, _card_data, trap: TrapData) -> void :
    var dm = EffectManager.duel_manager
    if not dm:
        return


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock += 1

    var owner_is_player = trap.owner.is_player_slot
    var graveyard = dm.player_graveyard if owner_is_player else dm.enemy_graveyard


    var dino_cards = []
    for card in graveyard:
        if card and card.type and card.type.to_lower() == "dinosaur":
            dino_cards.append(card)

    if dino_cards.is_empty():
        print("Fossil Excavation: Nenhum Dinossauro no cemitério para invocar.")
        if "additional_processing_lock" in dm:
            dm.additional_processing_lock -= 1
        return


    var chosen_card = dino_cards[randi() % dino_cards.size()]


    var owner_slots = dm.player_slots if owner_is_player else dm.enemy_slots
    var target_slot = null
    for slot in owner_slots:
        if not slot.is_occupied:
            target_slot = slot
            break

    if target_slot:
        print("Fossil Excavation: Invocando ", chosen_card.name, " do cemitério.")


        graveyard.erase(chosen_card)


        var new_card_data = chosen_card.get_copy()


        dm.update_graveyard_ui()




        await dm.spawn_card_on_field(new_card_data, target_slot, false, owner_is_player, false, true)
    else:
        print("Fossil Excavation: Sem slots vazios para invocar.")


    if "additional_processing_lock" in dm:
        dm.additional_processing_lock -= 1

func apply(target_slot, _defender, trap: TrapData) -> void :
    await apply_on_summon(target_slot, null, trap)
