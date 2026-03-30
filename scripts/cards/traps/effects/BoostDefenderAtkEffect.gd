extends Resource
class_name BoostDefenderAtkEffect





func apply(_attacker, defender, _trap) -> void :
    print("Kunai With Chain: Ativando efeito!")


    if not defender or not defender.stored_card_data:
        print("Kunai With Chain: Sem defensor válido, efeito ignorado.")
        return

    var card_data = defender.stored_card_data


    var original_atk = card_data.atk


    card_data.atk += 500

    print("Kunai With Chain: ", card_data.name)
    print("  ATK: ", original_atk, " -> ", card_data.atk, " (+500)")


    if defender.spawn_point.get_child_count() > 0:
        var visual = defender.spawn_point.get_child(0)
        if visual.has_method("update_stats"):
            visual.update_stats(card_data.atk, card_data.def)
            print("Kunai With Chain: Visual atualizado!")
        elif visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(card_data.atk, card_data.def)
            print("Kunai With Chain: Visual atualizado!")


    var dm = EffectManager.duel_manager
    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Kunai With Chain: Efeito aplicado! O ataque continua com defensor fortalecido.")
