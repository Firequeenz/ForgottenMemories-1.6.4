extends Resource
class_name HalveAttackerStatsEffect





func apply(attacker, _defender, _trap) -> void :
    print("Spellbinding Circle: Ativando efeito!")


    if not attacker or not attacker.stored_card_data:
        push_error("HalveAttackerStatsEffect: Atacante inválido!")
        return

    var card_data = attacker.stored_card_data


    var original_atk = card_data.atk
    var original_def = card_data.def


    card_data.atk = int(card_data.atk / 2)
    card_data.def = int(card_data.def / 2)

    print("Spellbinding Circle: ", card_data.name)
    print("  ATK: ", original_atk, " -> ", card_data.atk)
    print("  DEF: ", original_def, " -> ", card_data.def)


    if attacker.spawn_point.get_child_count() > 0:
        var visual = attacker.spawn_point.get_child(0)
        if visual.has_method("update_stats"):
            visual.update_stats(card_data.atk, card_data.def)
        elif visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(card_data.atk, card_data.def)
            print("Spellbinding Circle: Visual atualizado!")

    var dm = EffectManager.duel_manager
    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Spellbinding Circle: Efeito aplicado! O ataque continua com stats reduzidos.")
