extends Resource
class_name RobbinGoblinActivateEffect




func apply(_attacker, _defender, trap: TrapData) -> void :
    var owner_is_player = trap.owner.is_player_slot

    if owner_is_player:
        EffectManager.robbin_goblin_active_player = true
        print("Robbin' Goblin (Player) ativada pelo resto do turno!")
    else:
        EffectManager.robbin_goblin_active_enemy = true
        print("Robbin' Goblin (Enemy) ativada pelo resto do turno!")
