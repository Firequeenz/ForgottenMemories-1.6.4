extends Resource
class_name StopAttackEffect






func apply(attacker, _defender, _trap) -> void :
    print("StopAttackEffect: Ataque cancelado!")

    if attacker and attacker.stored_card_data:
        print("  Atacante parado: ", attacker.stored_card_data.name)

        if "has_attacked_this_turn" in attacker:
            attacker.has_attacked_this_turn = true

        var attacker_visual = attacker.spawn_point.get_child(0) if attacker.spawn_point.get_child_count() > 0 else null
        if attacker_visual and attacker_visual.has_method("set_exhausted"):
            attacker_visual.set_exhausted(true)

    var dm = EffectManager.duel_manager
    if dm:

        await dm.get_tree().create_timer(0.5).timeout

    print("StopAttackEffect: Fim do efeito.")
