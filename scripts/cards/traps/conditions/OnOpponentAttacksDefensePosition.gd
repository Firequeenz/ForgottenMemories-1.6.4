extends Resource
class_name OnOpponentAttacksDefensePosition








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



        var is_defense = false
        if abs(rot - 90) < 5 or abs(rot + 90) < 5 or abs(rot - 270) < 5 or abs(rot + 270) < 5:
            is_defense = true

        if is_defense:
            return true

    return false
