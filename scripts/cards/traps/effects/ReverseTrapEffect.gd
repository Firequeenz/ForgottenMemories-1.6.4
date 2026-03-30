extends Resource
class_name ReverseTrapEffect



func apply_on_equip(target_slot, _equip_id, _trap) -> void :
    var dm = EffectManager.duel_manager
    if not dm:
        push_error("ReverseTrapEffect: DuelManager não encontrado!")
        return



    var target_is_player = target_slot.is_player_slot

    if target_is_player:
        dm.reverse_trap_active_player = true
        print("Reverse Trap: Efeito ativado para o JOGADOR neste turno!")
    else:
        dm.reverse_trap_active_enemy = true
        print("Reverse Trap: Efeito ativado para o INIMIGO neste turno!")
