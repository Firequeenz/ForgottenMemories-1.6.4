extends Resource
class_name OnOpponentAttacksAttackPosition








func check(attacker, defender, trap) -> bool:

    var is_opponent_attack = (attacker.is_player_slot != trap.owner.is_player_slot)
    if not is_opponent_attack:
        return false


    if defender == null:
        return false


    if defender.is_player_slot != trap.owner.is_player_slot:
        return false


    if defender.spawn_point.get_child_count() > 0:
        var def_visual = defender.spawn_point.get_child(0)
        var rot = def_visual.rotation_degrees

        var is_attack = (abs(rot) < 5 or abs(rot - 180) < 5 or abs(rot + 180) < 5)
        if is_attack:
            return true

    return false
