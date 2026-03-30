extends Node



const MAX_COLLECTION_QUANTITY = 3
const MAX_DECK_QUANTITY = 3


var unlocked_cards: Dictionary = {}
var deck_cards: Array[int] = []
var sort_mode: String = "id"

var last_added_cards: Array = []


func _ready():
    initialize_collection()

func initialize_collection():
    load_deck()
    load_collection()
    print_card_collection_stats()

func initialize_new_player():
    "Inicializa um novo jogador com o deck inicial"
    print("=== INICIALIZANDO NOVO JOGADOR NO CARDCOLLECTION ===")

    initialize_collection()


    if has_node("/root/PlayerDeck"):
        var player_deck = get_node("/root/PlayerDeck")
        if player_deck.has_method("get_deck"):
            deck_cards = player_deck.get_deck()


            unlocked_cards.clear()
            for card_id in deck_cards:
                if unlocked_cards.has(card_id):
                    unlocked_cards[card_id] += 1
                else:
                    unlocked_cards[card_id] = 1

            print("Novo jogador inicializado:")
            print("- Cartas desbloqueadas: ", unlocked_cards.size())
            print("- Cartas no deck: ", deck_cards.size())


            if has_node("/root/Global"):
                var global = get_node("/root/Global")
                global.player_deck = deck_cards.duplicate()
                global.cards_unlocked = unlocked_cards.duplicate()
                global.save_player_data()

            return true

    print("ERRO: Falha ao inicializar novo jogador")
    return false

func print_card_collection_stats():
    print("=== COLECAO INICIALIZADA ===")
    print("Cartas desbloqueadas: ", unlocked_cards.size())
    print("Cartas no deck: ", deck_cards.size())
    print("=============================")


func load_collection() -> bool:
    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.load_player_data()


        if global.cards_unlocked.size() > 0:
            unlocked_cards = global.get_unlocked_cards()
            print("Coleção carregada do Global: ", unlocked_cards.size(), " cartas únicas")
            return true
        else:
            print("Global não tem cartas desbloqueadas, mantendo coleção atual")
            return false
    return false

func save_collection() -> bool:
    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.cards_unlocked = unlocked_cards.duplicate()
        global.save_player_data()
        print("Coleção salva")
        return true
    return false

func unlock_card(card_id: int, quantity: int = 1) -> void :
    if not CardDatabase.card_exists(card_id):
        print("AVISO: Carta ID inválida: ", card_id)
        return


    if unlocked_cards.has(card_id):
        unlocked_cards[card_id] += quantity
        if unlocked_cards[card_id] > MAX_COLLECTION_QUANTITY:
            unlocked_cards[card_id] = MAX_COLLECTION_QUANTITY
    else:
        unlocked_cards[card_id] = min(quantity, MAX_COLLECTION_QUANTITY)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")

        global.cards_unlocked = unlocked_cards.duplicate()
        global.add_recently_unlocked(card_id)
        global.save_player_data()

    print("Carta ", card_id, " desbloqueada na coleção. Total: ", unlocked_cards[card_id])

func get_card_quantity(card_id: int) -> int:
    return unlocked_cards.get(card_id, 0)

func get_card_quantity_in_deck(card_id: int) -> int:
    var count = 0
    for id in deck_cards:
        if id == card_id:
            count += 1
    return count

func get_all_unlocked_cards() -> Dictionary:
    return unlocked_cards.duplicate()

func get_unlocked_card_ids() -> Array:
    return unlocked_cards.keys()

func get_total_cards_count() -> int:
    var total = 0
    for quantity in unlocked_cards.values():
        total += quantity
    return total


func load_deck() -> bool:

    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.load_player_data()

        if global.player_deck.size() > 0:
            deck_cards = global.player_deck.duplicate()
            print("Deck carregado do Global: ", deck_cards.size(), " cartas")
            return true


    if has_node("/root/PlayerDeck"):
        var player_deck = get_node("/root/PlayerDeck")
        if player_deck.has_method("get_deck"):
            deck_cards = player_deck.get_deck()
            print("Deck carregado do PlayerDeck (fallback): ", deck_cards.size(), " cartas")
            return true

    print("ERRO: Não foi possível carregar o deck")
    return false

func save_deck() -> bool:
    if deck_cards.size() != 40:
        print("ERRO: Deck precisa ter 40 cartas. Atual: ", deck_cards.size())
        return false


    var success_global = false
    var success_playerdeck = false


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.player_deck = deck_cards.duplicate()
        success_global = global.save_player_data()


    if has_node("/root/PlayerDeck"):
        var player_deck = get_node("/root/PlayerDeck")
        if player_deck.has_method("set_deck"):
            success_playerdeck = player_deck.set_deck(deck_cards)

    print("Deck salvo - Global: ", success_global, " PlayerDeck: ", success_playerdeck)
    return success_global or success_playerdeck

func can_add_to_deck(card_id: int) -> bool:
    if not CardDatabase.card_exists(card_id):
        return false

    var total_owned = get_card_quantity(card_id)
    var in_deck = get_card_quantity_in_deck(card_id)

    if total_owned <= in_deck:
        return false

    var card_data = CardDatabase.get_card(card_id)
    if card_data:
        var max_allowed = card_data.limit
        if in_deck >= max_allowed:
            return false
    else:
        if in_deck >= 3:
            return false

    return true

func add_to_deck(card_id: int) -> bool:
    if not can_add_to_deck(card_id):
        return false

    deck_cards.append(card_id)
    return true

func remove_from_deck(card_id: int, specific_index: int = -1) -> bool:
    if deck_cards.is_empty():
        return false

    if specific_index >= 0 and specific_index < deck_cards.size():
        if deck_cards[specific_index] == card_id:
            deck_cards.remove_at(specific_index)
            return true

    var index = deck_cards.find(card_id)
    if index != -1:
        deck_cards.remove_at(index)
        return true

    return false

func clear_deck():
    deck_cards.clear()

func get_deck_count() -> int:
    return deck_cards.size()

func get_deck() -> Array:
    return deck_cards.duplicate()

func get_deck_cards() -> Array:
    return deck_cards.duplicate()


func get_sorted_cards(mode: String = "id") -> Array:
    var card_ids = get_unlocked_card_ids()

    match mode:
        "id":
            card_ids.sort()
        "name":
            card_ids.sort_custom(_sort_by_name)
        "atk":
            card_ids.sort_custom(_sort_by_atk)
        "def":
            card_ids.sort_custom(_sort_by_def)
        "type":
            card_ids.sort_custom(_sort_by_type)
        "attribute":
            card_ids.sort_custom(_sort_by_attribute)
        "new":
            card_ids.sort_custom(_sort_by_new)

    return card_ids

func _sort_by_name(a, b) -> bool:
    var card_a = CardDatabase.get_card(a)
    var card_b = CardDatabase.get_card(b)
    if card_a and card_b:
        return card_a.name.naturalnocasecmp_to(card_b.name) < 0
    return a < b

func _sort_by_atk(a, b) -> bool:
    var card_a = CardDatabase.get_card(a)
    var card_b = CardDatabase.get_card(b)
    if card_a and card_b:
        if card_a.atk != card_b.atk:
            return card_a.atk > card_b.atk
        return a < b
    return a < b

func _sort_by_def(a, b) -> bool:
    var card_a = CardDatabase.get_card(a)
    var card_b = CardDatabase.get_card(b)
    if card_a and card_b:
        if card_a.def != card_b.def:
            return card_a.def > card_b.def
        return a < b
    return a < b

func _sort_by_type(a, b) -> bool:
    var card_a = CardDatabase.get_card(a)
    var card_b = CardDatabase.get_card(b)
    if card_a and card_b:
        var type_compare = card_a.type.naturalnocasecmp_to(card_b.type)
        if type_compare != 0:
            return type_compare < 0
        return a < b
    return a < b

func _sort_by_attribute(a, b) -> bool:
    var card_a = CardDatabase.get_card(a)
    var card_b = CardDatabase.get_card(b)
    if card_a and card_b:
        var attr_compare = card_a.attribute.naturalnocasecmp_to(card_b.attribute)
        if attr_compare != 0:
            return attr_compare < 0
        return a < b
    return a < b

func _sort_by_new(a, b) -> bool:
    var global = get_node_or_null("/root/Global")
    if not global:
        return a < b

    var a_is_new = global.is_recently_unlocked(a)
    var b_is_new = global.is_recently_unlocked(b)

    if a_is_new and not b_is_new:
        return true
    elif not a_is_new and b_is_new:
        return false
    elif a_is_new and b_is_new:

        var a_idx = global.recently_unlocked.find(a)
        var b_idx = global.recently_unlocked.find(b)
        return a_idx < b_idx
    else:
        return a < b
