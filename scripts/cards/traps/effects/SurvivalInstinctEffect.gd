extends Resource
class_name SurvivalInstinctEffect




func apply_on_destruction(_slot_node, _card_data, trap: TrapData) -> void :
    var dm = EffectManager.duel_manager
    if not dm:
        return

    var owner_is_player = trap.owner.is_player_slot
    var graveyard = dm.player_graveyard if owner_is_player else dm.enemy_graveyard

    var dino_count = 0
    for card in graveyard:
        if card and card.type and card.type.to_lower() == "dinosaur":
            dino_count += 1

    var lp_gain = dino_count * 400

    if lp_gain > 0:
        print("Survival Instinct: Ganhando ", lp_gain, " LP (", dino_count, " Dinossauros no cemitério).")
        dm.heal_lp(owner_is_player, lp_gain)
    else:
        print("Survival Instinct: Nenhum Dinossauro no cemitério. Nenhum LP ganho.")

func apply(target_slot, _defender, trap: TrapData) -> void :

    apply_on_destruction(target_slot, null, trap)
