extends Node

const SAVE_VERSION = 2.0
const SAVE_PASS = "DuelCardMaster_Secure_2026"
const DEBUG_SAVE_PATH = "user://editor_saves/debug_save.json"

var player_name: String = "Player"
var player_deck: Array[int] = []
var cards_unlocked: Dictionary = {}


var _obs_gold: int = 0
var _gold_key: int = 0
var gold: int:
    get:
        return _obs_gold ^ _gold_key
    set(value):
        _gold_key = randi()
        _obs_gold = value ^ _gold_key

var wins: int = 0
var losses: int = 0
var next_enemy_deck_key: String = ""
var enemy_stats: Dictionary = {}
var recently_unlocked: Array[int] = []
var unlocked_duelists: Array = []
var shop_rng_seed: int = 0



var SPECIAL_FRAME_CONDITIONS: Dictionary = {
    17: {"enemy_wins": {"Simon Muran": 100}}, 
    18: {"enemy_wins": {"Simon Muran": 100}}, 
    19: {"enemy_wins": {"Simon Muran": 100}}, 
    20: {"enemy_wins": {"Simon Muran": 100}}, 
    21: {"enemy_wins": {"Simon Muran": 300}}, 
    38: {"enemy_wins": {"Seto 1": 700}}, 
    217: {"enemy_wins": {"Heishin 1": 900}}, 
    613: {"enemy_wins": {"Commentator": 700}}, 
    763: {"enemy_wins": {"Tea Gardner": 600}}, 
    775: {"enemy_wins": {"Yugi Muto": 700}}, 
    82: {"enemy_wins": {"Rex Raptor": 700}}, 
    67: {"enemy_wins": {"Weevil Underwood": 800}}, 
    803: {"enemy_wins": {"Bonz": 100}}, 
    374: {"enemy_wins": {"Jonathan Bicalho": 1100}}
}


var campaign_step: int = 0
var is_campaign_duel: bool = false
var campaign_return_step: int = -1


var game_volume: float = 1.0
var game_speed: int = 1
var selected_avatar: int = 0
var selected_card_back: int = 0
var windowed_mode: bool = false


var player_deck_slots: Array = [[], [], []]

func _ready():

    if OS.has_feature("editor"):
        var dir = DirAccess.open("user://")
        if dir and not dir.dir_exists("editor_saves"):
            dir.make_dir("editor_saves")


    load_player_data()

func get_save_path(filename: String) -> String:
    if OS.has_feature("editor"):
        return "user://editor_saves/" + filename
    else:
        return "user://" + filename

func get_enemy_stat(enemy_name: String, stat: String) -> int:
    if enemy_stats.has(enemy_name):
        return enemy_stats[enemy_name].get(stat, 0)
    return 0

func register_enemy_win(enemy_name: String):
    wins += 1
    if not enemy_stats.has(enemy_name):
        enemy_stats[enemy_name] = {"wins": 0, "losses": 0}
    enemy_stats[enemy_name]["wins"] = enemy_stats[enemy_name].get("wins", 0) + 1
    save_player_data()

func register_enemy_loss(enemy_name: String):
    losses += 1
    if not enemy_stats.has(enemy_name):
        enemy_stats[enemy_name] = {"wins": 0, "losses": 0}
    enemy_stats[enemy_name]["losses"] = enemy_stats[enemy_name].get("losses", 0) + 1
    save_player_data()

func unlock_duelist(enemy_name: String) -> void :
    if not unlocked_duelists.has(enemy_name):
        unlocked_duelists.append(enemy_name)
        save_player_data()
        print("Duelista desbloqueado: ", enemy_name)


func load_player_data():
    "Carrega dados do save file"
    var save_file = get_save_path("player_save.dat")
    var save_data = null


    if OS.has_feature("editor") and FileAccess.file_exists(DEBUG_SAVE_PATH):
        var json_file = FileAccess.open(DEBUG_SAVE_PATH, FileAccess.READ)
        if json_file:
            var json_text = json_file.get_as_text()
            var json = JSON.new()
            if json.parse(json_text) == OK:
                save_data = json.data
                print("DEBUG: Carregando dados do JSON (Debug Mode)")
            json_file.close()


    if save_data == null and FileAccess.file_exists(save_file):

        var file = FileAccess.open_encrypted_with_pass(save_file, FileAccess.READ, SAVE_PASS)


        if file == null:
            print("Tentando carregar save antigo (não criptografado)...")
            file = FileAccess.open(save_file, FileAccess.READ)

        if file:
            save_data = file.get_var()
            file.close()


    if save_data:
            var loaded_version = save_data.get("version", 1.0)
            if loaded_version < SAVE_VERSION:
                print("Versão do save muito antiga. Resetando...")
                initialize_new_player()
                return

            player_name = save_data.get("player_name", "Player")
            player_deck.assign(save_data.get("player_deck", []).map( func(v): return int(v)))


            var raw_cards = save_data.get("cards_unlocked", {})
            cards_unlocked.clear()
            for key in raw_cards:
                cards_unlocked[int(key)] = int(raw_cards[key])

            gold = int(save_data.get("gold", 0))
            wins = int(save_data.get("wins", 0))
            losses = int(save_data.get("losses", 0))
            enemy_stats = save_data.get("enemy_stats", {})
            recently_unlocked.assign(save_data.get("recently_unlocked", []).map( func(v): return int(v)))
            unlocked_duelists = save_data.get("unlocked_duelists", [])
            campaign_step = int(save_data.get("campaign_step", 0))
            game_volume = float(save_data.get("game_volume", 1.0))
            game_speed = int(save_data.get("game_speed", 1))
            selected_avatar = int(save_data.get("selected_avatar", 0))
            selected_card_back = int(save_data.get("selected_card_back", 0))
            windowed_mode = bool(save_data.get("windowed_mode", false))
            shop_rng_seed = int(save_data.get("shop_rng_seed", 0))

            if shop_rng_seed == 0:
                randomize()
                shop_rng_seed = randi()

            var raw_slots = save_data.get("player_deck_slots", [[], [], []])
            player_deck_slots.clear()
            for slot in raw_slots:
                if slot is Array:
                    player_deck_slots.append(slot.map( func(v): return int(v)))
                else:
                    player_deck_slots.append([])



            while player_deck_slots.size() < 3:
                player_deck_slots.append([])


            _apply_volume()
            _apply_window_mode()

            print("Dados carregados com sucesso!")
            print("Cartas desbloqueadas: ", cards_unlocked.size())
    else:
        print("Nenhum save encontrado")

        initialize_new_player()


        if shop_rng_seed == 0:
            randomize()
            shop_rng_seed = randi()


func save_player_data():
    "Salva dados no arquivo"
    var save_data = {
        "player_name": player_name, 
        "player_deck": player_deck, 
        "cards_unlocked": cards_unlocked, 
        "gold": gold, 
        "wins": wins, 
        "losses": losses, 
        "enemy_stats": enemy_stats, 
        "recently_unlocked": recently_unlocked, 
        "unlocked_duelists": unlocked_duelists, 
        "campaign_step": campaign_step, 
        "game_volume": game_volume, 
        "game_speed": game_speed, 
        "selected_avatar": selected_avatar, 
        "selected_card_back": selected_card_back, 
        "windowed_mode": windowed_mode, 
        "shop_rng_seed": shop_rng_seed, 
        "player_deck_slots": player_deck_slots, 
        "version": SAVE_VERSION
    }


    var file = FileAccess.open_encrypted_with_pass(get_save_path("player_save.dat"), FileAccess.WRITE, SAVE_PASS)
    if file:
        file.store_var(save_data)
        file.close()


        if OS.has_feature("editor"):
            var json_file = FileAccess.open(DEBUG_SAVE_PATH, FileAccess.WRITE)
            if json_file:
                json_file.store_line(JSON.stringify(save_data, "\t"))
                json_file.close()

        print("Dados salvos e criptografados para: ", player_name)
        return true

    return false


func export_save_to_clipboard() -> bool:
    var source_path = get_save_path("player_save.dat")


    save_player_data()

    if not FileAccess.file_exists(source_path):
        return false

    var file = FileAccess.open(source_path, FileAccess.READ)
    if not file:
        return false

    var buffer = file.get_buffer(file.get_length())
    file.close()

    var b64_string = Marshalls.raw_to_base64(buffer)
    DisplayServer.clipboard_set(b64_string)

    return true

func import_save_from_clipboard() -> int:

    if not DisplayServer.clipboard_has():
        return 1

    var b64_string = DisplayServer.clipboard_get().strip_edges()
    if b64_string == "":
        return 1

    var raw_data = Marshalls.base64_to_raw(b64_string)
    if raw_data.size() == 0:
        return 2


    var temp_path = "user://temp_clipboard_import.dat"
    var temp_file = FileAccess.open(temp_path, FileAccess.WRITE)
    if not temp_file:
        return 2

    temp_file.store_buffer(raw_data)
    temp_file.close()


    var test_file = FileAccess.open_encrypted_with_pass(temp_path, FileAccess.READ, SAVE_PASS)
    if test_file == null:
        if DirAccess.dir_exists_absolute("user://") and FileAccess.file_exists(temp_path):
            DirAccess.remove_absolute(temp_path)
        return 2

    var data = test_file.get_var()
    test_file.close()

    if typeof(data) != TYPE_DICTIONARY or not data.has("version"):
        if DirAccess.dir_exists_absolute("user://") and FileAccess.file_exists(temp_path):
            DirAccess.remove_absolute(temp_path)
        return 2


    var target_path = get_save_path("player_save.dat")
    if DirAccess.dir_exists_absolute("user://"):
        if FileAccess.file_exists(target_path):
            DirAccess.remove_absolute(target_path)

        if DirAccess.copy_absolute(temp_path, target_path) == OK:
            DirAccess.remove_absolute(temp_path)


            load_player_data()
            if has_node("/root/CardCollection"):
                get_node("/root/CardCollection").load_collection()
            return 0

    return 2




func get_unlocked_cards() -> Dictionary:
    "Retorna todas as cartas desbloqueadas"
    return cards_unlocked.duplicate()

func unlock_card(card_id: int, quantity: int = 1):
    "Desbloqueia uma carta"
    if card_id in cards_unlocked:
        cards_unlocked[card_id] += quantity
    else:
        cards_unlocked[card_id] = quantity

    add_recently_unlocked(card_id)
    print("Carta ", card_id, " desbloqueada. Total: ", cards_unlocked[card_id])

func has_card(card_id: int, required_quantity: int = 1) -> bool:
    "Verifica se tem a carta na quantidade necessária"
    return cards_unlocked.get(card_id, 0) >= required_quantity

func get_card_quantity(card_id: int) -> int:
    "Quantidade de cópias de uma carta"
    return cards_unlocked.get(card_id, 0)

func is_special_frame_unlocked(card_id: int) -> bool:
    "Verifica se o frame especial (Full Art) está desbloqueado para esta carta"

    if card_id in SPECIAL_FRAME_CONDITIONS:
        var conditions = SPECIAL_FRAME_CONDITIONS[card_id]


        if "enemy_wins" in conditions:
            var enemy_reqs = conditions["enemy_wins"]
            for enemy_name in enemy_reqs:
                if get_enemy_stat(enemy_name, "wins") < enemy_reqs[enemy_name]:
                    return false
            return true




    return get_card_quantity(card_id) >= 3



func add_recently_unlocked(card_id: int) -> void :
    "Adiciona carta à lista de recém-desbloqueadas (máx 20, mais recente primeiro)"

    var idx = recently_unlocked.find(card_id)
    if idx != -1:
        recently_unlocked.remove_at(idx)


    recently_unlocked.insert(0, card_id)


    if recently_unlocked.size() > 20:
        recently_unlocked.resize(20)

func is_recently_unlocked(card_id: int) -> bool:
    "Verifica se a carta está na lista de recém-desbloqueadas"
    return card_id in recently_unlocked



func _apply_volume():
    var db = linear_to_db(game_volume)
    AudioServer.set_bus_volume_db(0, db)
    if game_volume <= 0.0:
        AudioServer.set_bus_mute(0, true)
    else:
        AudioServer.set_bus_mute(0, false)

func get_avatar_texture_path() -> String:
    return "res://assets/portraits/player%d.png" % selected_avatar

func get_card_back_texture_path() -> String:
    if selected_card_back == 0:
        return "res://assets/cards/card_back.png"
    else:
        return "res://assets/cards/card_back%d.png" % selected_card_back

func _apply_game_speed():


    pass

func _apply_window_mode():

    if OS.has_feature("mobile") or OS.has_feature("web") or OS.has_feature("HTML5"):
        return

    print("Aplicando modo de janela: ", "Windowed" if windowed_mode else "Fullscreen")

    if windowed_mode:

        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)

        var screen_size = DisplayServer.screen_get_size()
        var win_size = Vector2i(int(screen_size.x * 0.75), int(screen_size.y * 0.75))
        DisplayServer.window_set_size(win_size)

        var win_pos = Vector2i((screen_size.x - win_size.x) / 2, (screen_size.y - win_size.y) / 2)
        DisplayServer.window_set_position(win_pos)
    else:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func save_deck_to_slot(slot_index: int, deck: Array) -> bool:
    if slot_index < 0 or slot_index >= 3:
        return false
    if deck.size() != 40:
        print("ERRO: Deck precisa ter 40 cartas para salvar no slot. Atual: ", deck.size())
        return false


    while player_deck_slots.size() < 3:
        player_deck_slots.append([])

    player_deck_slots[slot_index] = deck.duplicate()
    save_player_data()
    print("Deck salvo no slot ", slot_index + 1)
    return true

func load_deck_from_slot(slot_index: int) -> Array:
    if slot_index < 0 or slot_index >= 3:
        return []


    while player_deck_slots.size() < 3:
        player_deck_slots.append([])

    return player_deck_slots[slot_index].duplicate()

func is_deck_slot_empty(slot_index: int) -> bool:
    if slot_index < 0 or slot_index >= 3:
        return true
    if player_deck_slots.size() <= slot_index:
        return true
    return player_deck_slots[slot_index].size() == 0



func initialize_new_player():
    "Inicializa um novo jogador com o deck inicial"
    print("=== INICIALIZANDO NOVO JOGADOR ===")

    if not has_node("/root/PlayerDeck"):
        print("ERRO: PlayerDeck não encontrado!")
        return

    var player_deck_node = get_node("/root/PlayerDeck")
    if not player_deck_node.has_method("get_deck"):
        print("ERRO: PlayerDeck não tem método get_deck!")
        return


    var deck = player_deck_node.get_deck()
    player_deck = deck.duplicate()


    cards_unlocked.clear()
    for card_id in deck:
        if card_id in cards_unlocked:
            cards_unlocked[card_id] += 1
        else:
            cards_unlocked[card_id] = 1


    save_player_data()

    print("Novo jogador criado:")
    print("- Cartas desbloqueadas: ", cards_unlocked.size())
    print("- Cartas no deck: ", player_deck.size())



func debug_print_cards():
    "Debug: imprime todas as cartas desbloqueadas"
    print("=== CARDS UNLOCKED DEBUG ===")
    print("Total de tipos de cartas: ", cards_unlocked.size())

    var sorted_keys = cards_unlocked.keys()
    sorted_keys.sort()

    for card_id in sorted_keys:
        print("ID: %4d | Quantidade: %2d" % [card_id, cards_unlocked[card_id]])
    print("============================")

func debug_print_deck():
    "Debug: imprime o deck atual"
    print("=== DECK DEBUG ===")
    print("Cartas no deck: ", player_deck.size())

    var card_counts = {}
    for card_id in player_deck:
        card_counts[card_id] = card_counts.get(card_id, 0) + 1

    var sorted_ids = card_counts.keys()
    sorted_ids.sort()

    for card_id in sorted_ids:
        var card_data = CardDatabase.get_card(card_id) if has_node("/root/CardDatabase") else null
        if card_data:
            print("ID: %4d | Nome: %-25s | Quantidade: %d" % [card_id, card_data.name.substr(0, 25), card_counts[card_id]])
        else:
            print("ID: %4d | (Desconhecida) | Quantidade: %d" % [card_id, card_counts[card_id]])
    print("==================")


func sync_with_cardcollection():
    "Sincroniza dados com o CardCollection"
    if has_node("/root/CardCollection"):
        var collection = get_node("/root/CardCollection")
        if collection.has_method("get_deck_cards"):
            player_deck = collection.get_deck_cards()
        if collection.has_method("get_all_unlocked_cards"):
            cards_unlocked = collection.get_all_unlocked_cards()
        save_player_data()
        print("Global sincronizado com CardCollection")
