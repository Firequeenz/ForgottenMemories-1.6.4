extends Node


class_name DuelScoreSystem


const TURN_SCORE = {
    "0-4": 33, 
    "5-8": 24, 
    "9-28": 18, 
    "29-32": 12, 
    "33-36": 6
}

const CARDS_USED_SCORE = {
    "0-8": 33, 
    "9-12": 24, 
    "13-32": 18, 
    "33-36": 12, 
    "37-40": 6
}

const LP_SCORE = {
    "0-99": 6, 
    "100-999": 12, 
    "1000-8999": 18, 
    "9000-9999": 24, 
    "10000-99999": 33
}


const RANK_THRESHOLDS = {
    "S": 80, 
    "A": 60, 
    "B": 40, 
    "C": 20, 
    "D": 1
}

const RANK_REWARDS = {
    "S": {"cards": 5, "gold": 10}, 
    "A": {"cards": 4, "gold": 8}, 
    "B": {"cards": 3, "gold": 6}, 
    "C": {"cards": 2, "gold": 4}, 
    "D": {"cards": 1, "gold": 2}
}


var total_turns: int = 0
var cards_used: int = 0
var final_lp: int = 0
var total_score: int = 0
var rank: String = "D"
var enemy_name: String = ""


func setup(enemy: String):
    enemy_name = enemy
    reset()

func reset():
    total_turns = 0
    cards_used = 0
    final_lp = 0
    total_score = 0
    rank = "D"


func calculate_score():
    var turn_score = _get_category_score(total_turns, TURN_SCORE)
    var cards_score = _get_category_score(cards_used, CARDS_USED_SCORE)
    var lp_score = _get_category_score(final_lp, LP_SCORE)

    total_score = turn_score + cards_score + lp_score
    rank = _calculate_rank(total_score)

    print("=== PONTUAÇÃO DO DUELO ===")
    print("Turnos: ", total_turns, " -> ", turn_score, " pontos")
    print("Cartas usadas: ", cards_used, " -> ", cards_score, " pontos")
    print("LP final: ", final_lp, " -> ", lp_score, " pontos")
    print("Total: ", total_score, " pontos")
    print("Rank: ", rank)
    print("==========================")

    return {
        "total_score": total_score, 
        "rank": rank, 
        "breakdown": {
            "turns": {"value": total_turns, "score": turn_score}, 
            "cards_used": {"value": cards_used, "score": cards_score}, 
            "final_lp": {"value": final_lp, "score": lp_score}
        }
    }

func _get_category_score(value: int, score_table: Dictionary) -> int:
    for range_str in score_table.keys():
        var range_parts = range_str.split("-")
        if range_parts.size() == 2:
            var min_val = int(range_parts[0])
            var max_val = int(range_parts[1])
            if value >= min_val and value <= max_val:
                return score_table[range_str]
        elif range_parts.size() == 1 and value == int(range_parts[0]):
            return score_table[range_str]
    return 0

func _calculate_rank(score: int) -> String:
    if score >= RANK_THRESHOLDS["S"]:
        return "S"
    elif score >= RANK_THRESHOLDS["A"]:
        return "A"
    elif score >= RANK_THRESHOLDS["B"]:
        return "B"
    elif score >= RANK_THRESHOLDS["C"]:
        return "C"
    else:
        return "D"


func get_rank() -> String:
    return rank

func get_total_score() -> int:
    return total_score

func get_rewards() -> Dictionary:
    return RANK_REWARDS.get(rank, RANK_REWARDS["D"])

func get_reward_cards_count() -> int:
    return get_rewards()["cards"]

func get_reward_gold() -> int:
    return get_rewards()["gold"]
