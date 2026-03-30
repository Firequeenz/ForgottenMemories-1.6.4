extends Resource
class_name ReinforcementsEffect




func apply(_attacker, defender, _trap) -> void :
    var duel_manager = EffectManager.duel_manager

    if not duel_manager:
        print("ReinforcementsEffect: DuelManager não encontrado.")
        return

    var def_card = defender.stored_card_data
    if not def_card:
        return


    var bonus = 500

    print("=== REINFORCEMENTS DEBUG ===")
    print("  -> def_card antes: ", def_card.atk)

    def_card.atk += bonus
    print("  -> def_card depois: ", def_card.atk)
    print("Reinforcements: Concedendo %d ATK para %s" % [bonus, def_card.name])


    duel_manager.reinforcements_active_monsters.append({
        "card": def_card, 
        "amount": bonus
    })


    if defender.spawn_point.get_child_count() > 0:
        var visual = defender.spawn_point.get_child(0)
        if visual.has_method("update_stats"):
            visual.update_stats(def_card.atk, def_card.def)
            print("Reinforcements: Visual atualizado via update_stats!")
        elif visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(def_card.atk, def_card.def)
            print("Reinforcements: Visual atualizado via animate_stats_bonus!")


    if duel_manager:
        await duel_manager.get_tree().create_timer(0.5).timeout
