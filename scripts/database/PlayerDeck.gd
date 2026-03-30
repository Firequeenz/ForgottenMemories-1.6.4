extends Node

var my_deck_ids: Array[int] = []

var deck_save_file: String = ""

var CATEGORIES_TO_EXCLUDE: Array[CardData.CardCategory] = [
    CardData.CardCategory.FUSION_MONSTER, 
    CardData.CardCategory.RITUAL_MONSTER, 
    CardData.CardCategory.SYNCHRO_MONSTER, 
    CardData.CardCategory.XYZ_MONSTER, 
    CardData.CardCategory.LINK_MONSTER, 
    CardData.CardCategory.PENDULUM_MONSTER
]






var debug_cards: Dictionary = {




}




var EXCLUDED_FROM_STARTER_DECK: Array[int] = [
    17, 18, 19, 20, 21, 311, 651, 655, 665, 666, 304, 321, 693, 349, 
    657, 661, 658, 723, 613, 756, 761, 763, 99999, 99998, 765, 768, 775, 
    698, 713, 374, 778, 784, 781, 82, 67, 788, 791, 794, 795, 796, 747, 
    802, 801, 803, 217, 38
]


func _ready():
    deck_save_file = Global.get_save_path("player_deck.dat")

    if not load_deck():
        create_starter_deck()
        save_deck()

func create_starter_deck():
    my_deck_ids.clear()

    var recipe = _generate_random_starter_recipe()

    var total_count = 0
    for card_id in recipe:
        var quantity = recipe[card_id]
        for i in range(quantity):
            my_deck_ids.append(card_id)
            total_count += 1


    if not debug_cards.is_empty():
        var debug_total = 0
        for qty in debug_cards.values():
            debug_total += qty


        for i in range(mini(debug_total, my_deck_ids.size())):
            my_deck_ids.pop_back()
            total_count -= 1


        for card_id in debug_cards:
            var quantity = debug_cards[card_id]
            for i in range(quantity):
                my_deck_ids.append(card_id)
                total_count += 1

        print("DEBUG: %d cartas de debug injetadas no deck." % debug_total)

    if total_count != 40:
        push_error("ERRO CRÍTICO NO PLAYER DECK: A receita soma " + str(total_count) + " cartas. É obrigatório ter exatas 40.")
    else:
        print("Deck do Jogador criado com sucesso: 40 cartas.")
        print_deck()

func _generate_random_starter_recipe() -> Dictionary:

    var level1_monsters: Array[int] = []
    var level2_monsters: Array[int] = []
    var level3_monsters: Array[int] = []
    var level4_monsters: Array[int] = []
    var equip_cards: Array[int] = []
    var field_cards: Array[int] = []


    if CardDatabase.cards.is_empty():
        CardDatabase._init_cards()

    for card_id in CardDatabase.cards:
        var card = CardDatabase.cards[card_id]


        if card.category in CATEGORIES_TO_EXCLUDE:
            continue


        if card_id in EXCLUDED_FROM_STARTER_DECK:
            continue


        if card.type == "Equip":
            equip_cards.append(card_id)
            continue


        if card.type == "Field":
            field_cards.append(card_id)
            continue


        if card.category == CardData.CardCategory.MAGIC or card.category == CardData.CardCategory.TRAP:
            continue


        match card.level:
            1:
                if not card_id in [17, 18, 19, 20]:
                    level1_monsters.append(card_id)
            2: level2_monsters.append(card_id)
            3:
                if card_id != 21:
                    level3_monsters.append(card_id)
            4: level4_monsters.append(card_id)


    level1_monsters.shuffle()
    level2_monsters.shuffle()
    level3_monsters.shuffle()
    level4_monsters.shuffle()
    equip_cards.shuffle()
    field_cards.shuffle()

    var recipe: Dictionary = {}


    for i in range(4):
        recipe[level1_monsters[i]] = 3


    for i in range(5):
        recipe[level2_monsters[i]] = 3


    recipe[equip_cards[0]] = 2


    for i in range(3):
        recipe[level3_monsters[i]] = 2


    recipe[level4_monsters[0]] = 2


    recipe[field_cards[0]] = 2


    recipe[[336, 337].pick_random()] = 1


    return recipe

func get_deck() -> Array[int]:
    return my_deck_ids.duplicate()

func set_deck(new_deck_ids: Array[int]) -> bool:
    "Atualiza o deck do jogador"
    if new_deck_ids.size() != 40:
        push_error("ERRO: Deck deve ter exatamente 40 cartas")
        return false

    my_deck_ids = new_deck_ids.duplicate()
    print("Deck do jogador atualizado com ", my_deck_ids.size(), " cartas")
    return true

func save_deck() -> bool:
    var save_data = {
        "deck": my_deck_ids, 
        "last_updated": Time.get_datetime_string_from_system()
    }

    var file = FileAccess.open(deck_save_file, FileAccess.WRITE)
    if file:
        file.store_var(save_data)
        file.close()
        print("Deck salvo com sucesso")
        return true
    else:
        push_error("Erro ao salvar deck")
        return false

func load_deck() -> bool:
    if not FileAccess.file_exists(deck_save_file):
        print("Nenhum deck salvo encontrado")
        return false

    var file = FileAccess.open(deck_save_file, FileAccess.READ)
    if file:
        var save_data = file.get_var()
        file.close()

        if save_data and typeof(save_data) == TYPE_DICTIONARY:
            my_deck_ids = save_data.get("deck", [])


            if my_deck_ids.size() != 40:
                push_warning("Deck carregado tem ", my_deck_ids.size(), " cartas. Recriando...")
                return false

            print("Deck carregado com sucesso: ", my_deck_ids.size(), " cartas")
            return true

    push_error("Erro ao carregar deck")
    return false


func print_deck():
    print("=== DECK ATUAL ===")
    var card_counts = {}
    for card_id in my_deck_ids:
        if card_counts.has(card_id):
            card_counts[card_id] += 1
        else:
            card_counts[card_id] = 1

    var sorted_ids = card_counts.keys()
    sorted_ids.sort()

    for card_id in sorted_ids:
        var card_data = CardDatabase.get_card(card_id)
        if card_data:
            print("ID: ", card_id, " | Nome: ", card_data.name, " | Quantidade: ", card_counts[card_id])
        else:
            print("ID: ", card_id, " | (Não encontrada) | Quantidade: ", card_counts[card_id])
    print("Total cartas: ", my_deck_ids.size())
    print("=================")
