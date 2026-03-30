extends Resource
class_name SevenToolsEffect




func apply(_attacker, _defender, trap) -> void :
    var duel_manager = EffectManager.duel_manager
    if not duel_manager:
        return

    var is_player = trap.owner.is_player_slot


    if is_player:
        duel_manager.player_lp = max(0, duel_manager.player_lp - 1000)
    else:
        duel_manager.enemy_lp = max(0, duel_manager.enemy_lp - 1000)

    duel_manager.update_lp_ui()
    print("Seven Tools: Dono perdeu 1000 LP. LP restante: ", duel_manager.player_lp if is_player else duel_manager.enemy_lp)
