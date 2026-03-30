extends Node


class_name EnemyDropSystem


class DropResult:
    var card_ids: Array = []
    var gold: int = 0
    var rank: String = "D"
    var surplus_card_ids: Array = []

    func _init(rank_result: String, cards: Array, gold_amount: int):
        rank = rank_result
        card_ids = cards
        gold = gold_amount
        surplus_card_ids = []


var global_ref = null
var card_database_ref = null

func _ready():

    if has_node("/root/Global"):
        global_ref = get_node("/root/Global")

    if has_node("/root/CardDatabase"):
        card_database_ref = get_node("/root/CardDatabase")


func calculate_drops(enemy_name: String, rank: String) -> DropResult:
    if not EnemyDeckDatabase.has_enemy(enemy_name):
        push_error("Inimigo não encontrado: " + enemy_name)
        return DropResult.new("D", [], 0)

    var enemy_data = EnemyDeckDatabase.enemy_decks_data[enemy_name]


    if not EnemyDeckDatabase.has_drops(enemy_name):
        print("Inimigo não tem drops definidos, usando drops padrão")
        return _get_default_drops(rank, enemy_data)

    var drops = EnemyDeckDatabase.get_enemy_drops(enemy_name)
    var drop_rates = EnemyDeckDatabase.get_enemy_drop_rates(enemy_name)


    var cards_to_drop = _get_cards_count_by_rank(rank)
    var dropped_cards = []


    for i in range(cards_to_drop):
        var rarity = _get_random_rarity(drop_rates)
        var card_pool = drops.get(rarity, [])


        if card_pool.is_empty():
            card_pool = drops.get("common", [])


        if card_pool.is_empty():
            for p in drops.values():
                if not p.is_empty():
                    card_pool = p
                    break

        if not card_pool.is_empty():
            var random_card = card_pool[randi() % card_pool.size()]
            dropped_cards.append(random_card)
        else:
            print("AVISO: Nenhum pool de drop encontrado para o inimigo!")



    if dropped_cards.is_empty() and not drops.is_empty():

        var common_pool = drops.get("common", [])
        if not common_pool.is_empty():
            dropped_cards.append(common_pool[randi() % common_pool.size()])


    var gold_amount = _get_gold_by_rank(rank)

    print("=== DROPS CALCULADOS ===")
    print("Inimigo: ", enemy_name)
    print("Rank: ", rank)
    print("Cartas: ", dropped_cards)
    print("Gold: ", gold_amount)
    print("======================")

    return DropResult.new(rank, dropped_cards, gold_amount)

func apply_drops_to_collection(drop_result: DropResult):
    if global_ref == null:
        if has_node("/root/Global"):
            global_ref = get_node("/root/Global")
        else:
            push_error("Global não encontrado!")
            return


    var collection = null
    if has_node("/root/CardCollection"):
        collection = get_node("/root/CardCollection")


    global_ref.gold += drop_result.gold


    drop_result.surplus_card_ids = []
    var surplus_gold_total = 0


    for i in range(drop_result.card_ids.size()):
        var card_id = drop_result.card_ids[i]
        var current_qty = global_ref.cards_unlocked.get(card_id, 0)

        print("[DROP %d/%d] Card ID: %d | Qty no Global: %d" % [i + 1, drop_result.card_ids.size(), card_id, current_qty])

        if current_qty >= 3:

            drop_result.surplus_card_ids.append(card_id)
            surplus_gold_total += 1
            drop_result.gold += 1
            global_ref.gold += 1
            print("  → SURPLUS! Carta %d já tem %d cópias. +1 gold (surplus total: %d)" % [card_id, current_qty, surplus_gold_total])
        else:

            if global_ref.has_method("unlock_card"):
                global_ref.unlock_card(card_id, 1)
            else:

                if card_id in global_ref.cards_unlocked:
                    global_ref.cards_unlocked[card_id] += 1
                else:
                    global_ref.cards_unlocked[card_id] = 1
                global_ref.add_recently_unlocked(card_id)
            print("  → UNLOCKED! Carta %d desbloqueada. Nova qty: %d" % [card_id, global_ref.cards_unlocked.get(card_id, 0)])


    if collection:
        collection.unlocked_cards = global_ref.cards_unlocked.duplicate()


    if global_ref.has_method("save_player_data"):
        global_ref.save_player_data()

    print("=== DROPS APLICADOS ===")
    print("Gold base (rank): ", drop_result.gold - surplus_gold_total)
    print("Gold surplus: +", surplus_gold_total)
    print("Gold total neste drop: ", drop_result.gold)
    print("Gold total do jogador: ", global_ref.gold)
    print("Cartas recebidas: ", drop_result.card_ids)
    print("Cartas sobressalentes: ", drop_result.surplus_card_ids, " (", drop_result.surplus_card_ids.size(), " cartas)")
    print("=======================")

func get_drop_display_text(drop_result: DropResult) -> String:

    var text = "[img=30x30]res://assets/starchip.png[/img] +" + str(drop_result.gold) + "\n"
    text += "Cards Obtained:\n"

    for i in range(drop_result.card_ids.size()):
        var card_id = drop_result.card_ids[i]


        var card_data = CardDatabase.get_card(card_id) if CardDatabase else null

        if card_data and card_data.name:
            text += "  • " + card_data.name + " (#" + str(card_id) + ")\n"
        else:
            text += "  • Card #" + str(card_id) + "\n"

    return text


static func _get_cards_count_by_rank(rank: String) -> int:
    match rank:
        "S": return 5
        "A": return 4
        "B": return 3
        "C": return 2
        "D": return 1
        _: return 1

static func _get_gold_by_rank(rank: String) -> int:
    match rank:
        "S": return 10
        "A": return 8
        "B": return 6
        "C": return 4
        "D": return 2
        _: return 2

static func _get_random_rarity(drop_rates: Dictionary) -> String:
    var rand = randf()
    var cumulative = 0.0

    for rarity in drop_rates.keys():
        cumulative += drop_rates[rarity]
        if rand <= cumulative:
            return rarity


    return "common"

static func _get_default_drops(rank: String, enemy_data: Dictionary) -> DropResult:

    var all_cards = []
    var deck = enemy_data.get("deck", {})

    for card_id in deck.keys():
        all_cards.append(card_id)


    var cards_to_drop = _get_cards_count_by_rank(rank)
    var dropped_cards = []

    if not all_cards.is_empty():
        for i in range(cards_to_drop):
            var random_card = all_cards[randi() % all_cards.size()]
            dropped_cards.append(random_card)


    var gold_amount = _get_gold_by_rank(rank)

    return DropResult.new(rank, dropped_cards, gold_amount)
