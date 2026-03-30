extends Resource
class_name DecreaseAttackerAtkEffect





const ATK_DECREASE = 700

func apply(attacker, _defender, _trap) -> void :
    print("Shadow Spell: Ativando efeito!")


    if not attacker or not attacker.stored_card_data:
        push_error("DecreaseAttackerAtkEffect: Atacante inválido!")
        return

    var card_data = attacker.stored_card_data


    var original_atk = card_data.atk


    card_data.atk = max(0, card_data.atk - ATK_DECREASE)

    print("Shadow Spell: ", card_data.name)
    print("  ATK: ", original_atk, " -> ", card_data.atk, " (-", ATK_DECREASE, ")")


    if attacker.spawn_point.get_child_count() > 0:
        var visual = attacker.spawn_point.get_child(0)
        if visual.has_method("update_stats"):
            visual.update_stats(card_data.atk, card_data.def)
            print("Shadow Spell: Visual atualizado!")
        elif visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(card_data.atk, card_data.def)
            print("Shadow Spell: Visual atualizado!")


    var dm = EffectManager.duel_manager
    if dm:
        await dm.get_tree().create_timer(0.5).timeout

    print("Shadow Spell: Efeito aplicado! O ataque continua com ATK reduzido.")
