extends Resource
class_name WabokuEffect






func apply(_attacker, _defender, trap) -> void :
    var dm = EffectManager.duel_manager
    if not dm:
        push_error("WabokuEffect: DuelManager não encontrado!")
        return


    var owner_is_player = trap.owner.is_player_slot

    if owner_is_player:
        dm.waboku_active_player = true
        print("Waboku: Proteção ativada para o Jogador neste turno!")
    else:
        dm.waboku_active_enemy = true
        print("Waboku: Proteção ativada para o Inimigo neste turno!")
