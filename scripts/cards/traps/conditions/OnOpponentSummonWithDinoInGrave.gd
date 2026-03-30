extends Resource
class_name OnOpponentSummonWithDinoInGrave






func check_summon(summoned_slot, _card_data, trap: TrapData) -> bool:

    if summoned_slot.is_player_slot == trap.owner.is_player_slot:
        return false

    var dm = EffectManager.duel_manager
    if not dm:
        return false

    var owner_is_player = trap.owner.is_player_slot


    var owner_slots = dm.player_slots if owner_is_player else dm.enemy_slots
    var has_empty_slot = false
    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        return false


    var owner_graveyard = dm.player_graveyard if owner_is_player else dm.enemy_graveyard
    var has_dino = false
    for card in owner_graveyard:
        if card and card.type and card.type.to_lower() == "dinosaur":
            has_dino = true
            break

    if not has_dino:
        return false

    print("Fossil Excavation: Invocação oponente detectada e condições atendidas.")
    return true
