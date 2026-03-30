extends Node
@warning_ignore_start("unused_signal")




signal attack_declared(attacker, defender)


signal monster_summoned(slot, card_data, is_player_owner)


signal equip_applied(target_slot, equip_id, is_player_equipping)


signal trap_activated(trap)


signal trap_consumed(trap, attacker, defender)



signal trap_triggered(trap)



signal trap_removed(trap)


signal resolve_effect_trap_finished(attacker)

signal monster_destroyed(slot, card_data, is_player_owner)
