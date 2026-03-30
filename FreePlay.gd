extends Node2D

@onready var fade_rect: ColorRect = $FadeRect
@onready var gold_label = $GoldLabel
@onready var audio_player: AudioStreamPlayer = null
@onready var off_buttons = $VBoxContainer
@onready var unknown_button = $ScrollContainer / CharsGrid / UnknownChar
@onready var unknown_info = $BigChars / Unknown
@onready var unknown_text = $BigChars / Unknown / UnknownInfo
@onready var simon_muran_button = $ScrollContainer / CharsGrid / SimonMuranChar
@onready var simon_muran_info = $BigChars / SimonMuran
@onready var simon_muran_text = $BigChars / SimonMuran / SimonMuranInfo
@onready var teana_button = $ScrollContainer / CharsGrid / TeanaChar
@onready var teana_info = $BigChars / Teana
@onready var teana_text = $BigChars / Teana / TeanaInfo
@onready var jono_button = $ScrollContainer / CharsGrid / JonoChar
@onready var jono_info = $BigChars / Jono
@onready var jono_text = $BigChars / Jono / JonoInfo
@onready var villager1_button = $ScrollContainer / CharsGrid / Villager1Char
@onready var villager1_info = $BigChars / Villager1
@onready var villager1_text = $BigChars / Villager1 / Villager1Info
@onready var villager2_button = $ScrollContainer / CharsGrid / Villager2Char
@onready var villager2_info = $BigChars / Villager2
@onready var villager2_text = $BigChars / Villager2 / Villager2Info
@onready var villager3_button = $ScrollContainer / CharsGrid / Villager3Char
@onready var villager3_info = $BigChars / Villager3
@onready var villager3_text = $BigChars / Villager3 / Villager3Info
@onready var seto1_button = $ScrollContainer / CharsGrid / Seto1Char
@onready var seto1_info = $BigChars / Seto1
@onready var seto1_text = $BigChars / Seto1 / Seto1Info
@onready var heishin1_button = $ScrollContainer / CharsGrid / Heishin1Char
@onready var heishin1_info = $BigChars / Heishin1
@onready var heishin1_text = $BigChars / Heishin1 / Heishin1Info
@onready var commentator_button = $ScrollContainer / CharsGrid / CommentatorChar
@onready var commentator_info = $BigChars / Commentator
@onready var commentator_text = $BigChars / Commentator / CommentatorInfo
@onready var tea_button = $ScrollContainer / CharsGrid / TeaGardnerChar
@onready var tea_info = $BigChars / TeaGardner
@onready var tea_text = $BigChars / TeaGardner / TeaGardnerInfo
@onready var yugi_muto_button = $ScrollContainer / CharsGrid / YugiMutoChar
@onready var yugi_muto_info = $BigChars / YugiMuto
@onready var yugi_muto_text = $BigChars / YugiMuto / YugiMutoInfo
@onready var rex_raptor_button = $ScrollContainer / CharsGrid / RexRaptorChar
@onready var rex_raptor_info = $BigChars / RexRaptor
@onready var rex_raptor_text = $BigChars / RexRaptor / RexRaptorInfo
@onready var weevil_button = $ScrollContainer / CharsGrid / WeevilUnderwoodChar
@onready var weevil_info = $BigChars / WeevilUnderwood
@onready var weevil_text = $BigChars / WeevilUnderwood / WeevilUnderwoodInfo
@onready var bandit_keith_button = $ScrollContainer / CharsGrid / BanditKeithChar
@onready var bandit_keith_info = $BigChars / BanditKeith
@onready var bandit_keith_text = $BigChars / BanditKeith / BanditKeithInfo
@onready var bonz_button = $ScrollContainer / CharsGrid / BonzChar
@onready var bonz_info = $BigChars / Bonz
@onready var bonz_text = $BigChars / Bonz / BonzInfo


@onready var amon_button = $ScrollContainer / CharsGrid / AmonChar
@onready var amon_info = $BigChars / Amon
@onready var amon_text = $BigChars / Amon / AmonInfo
@onready var jonathan_button = $ScrollContainer / CharsGrid / JonathanChar
@onready var jonathan_info = $BigChars / Jonathan
@onready var jonathan_text = $BigChars / Jonathan / JonathanInfo

var last_click_time_unknown: int = 0
var last_click_time_simon: int = 0
var last_click_time_teana: int = 0
var last_click_time_jono: int = 0
var last_click_time_villager1: int = 0
var last_click_time_villager2: int = 0
var last_click_time_villager3: int = 0
var last_click_time_seto1: int = 0
var last_click_time_heishin1: int = 0
var last_click_time_commentator: int = 0
var last_click_time_tea: int = 0
var last_click_time_yugi_muto: int = 0
var last_click_time_rex_raptor: int = 0
var last_click_time_weevil: int = 0
var last_click_time_bandit_keith: int = 0
var last_click_time_bonz: int = 0


var last_click_time_amon: int = 0
var last_click_time_jonathan: int = 0


func _ready() -> void :
    fade_rect.visible = true
    fade_rect.color = Color(0, 0, 0, 1)
    _setup_hover_effects()
    _apply_unlocks()
    _play_bgm()
    update_gold_display()

func _apply_unlocks() -> void :

    var characters = {
        "Unknown": unknown_button, 
        "Simon Muran": simon_muran_button, 
        "Teana": teana_button, 
        "Jono": jono_button, 
        "Joseph": villager1_button, 
        "Noah": villager2_button, 
        "Issam": villager3_button, 
        "Seto 1": seto1_button, 
        "Heishin 1": heishin1_button, 
        "Commentator": commentator_button, 
        "Tea Gardner": tea_button, 
        "Yugi Muto": yugi_muto_button, 
        "Rex Raptor": rex_raptor_button, 
        "Weevil Underwood": weevil_button, 
        "Bandit Keith": bandit_keith_button, 
        "Bonz": bonz_button, 


        "Amon": amon_button, 
        "Jonathan Bicalho": jonathan_button
    }

    for btn in characters.values():
        if btn != null:
            btn.visible = false


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        for enemy in global.unlocked_duelists:
            if characters.has(enemy) and characters[enemy] != null:
                characters[enemy].visible = true

func update_gold_display():
    if gold_label and has_node("/root/Global"):
        var global = get_node("/root/Global")


        gold_label.text = "[img=40]res://assets/starchip.png[/img]x%d" % global.gold

func _setup_hover_effects():

    if unknown_button:
        _connect_button_hover(unknown_button)
    if simon_muran_button:
        _connect_button_hover(simon_muran_button)
    if teana_button:
        _connect_button_hover(teana_button)
    if jono_button:
        _connect_button_hover(jono_button)
    if villager1_button:
        _connect_button_hover(villager1_button)
    if villager2_button:
        _connect_button_hover(villager2_button)
    if villager3_button:
        _connect_button_hover(villager3_button)
    if seto1_button:
        _connect_button_hover(seto1_button)
    if heishin1_button:
        _connect_button_hover(heishin1_button)
    if commentator_button:
        _connect_button_hover(commentator_button)
    if tea_button:
        _connect_button_hover(tea_button)
    if yugi_muto_button:
        _connect_button_hover(yugi_muto_button)
    if rex_raptor_button:
        _connect_button_hover(rex_raptor_button)
    if weevil_button:
        _connect_button_hover(weevil_button)
    if bandit_keith_button:
        _connect_button_hover(bandit_keith_button)
    if bonz_button:
        _connect_button_hover(bonz_button)


    if amon_button:
        _connect_button_hover(amon_button)
    if jonathan_button:
        _connect_button_hover(jonathan_button)


    if off_buttons:
        for btn in off_buttons.get_children():
            if btn is BaseButton or btn is TextureButton:
                _connect_button_hover(btn)

func _connect_button_hover(btn):
    if not btn.is_connected("mouse_entered", _on_button_hover):
        btn.mouse_entered.connect(_on_button_hover.bind(btn))
    if not btn.is_connected("mouse_exited", _on_button_unhover):
        btn.mouse_exited.connect(_on_button_unhover.bind(btn))

func _on_button_hover(btn):
    var tween = create_tween()
    tween.tween_property(btn, "modulate", Color(0.392, 0.392, 0.392, 1.0), 0.1)


    if btn == unknown_button:
        update_enemy_info("Unknown", unknown_text)
        unknown_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == simon_muran_button:
        update_enemy_info("Simon Muran", simon_muran_text)
        simon_muran_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == teana_button:
        update_enemy_info("Teana", teana_text)
        teana_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == jono_button:
        update_enemy_info("Jono", jono_text)
        jono_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == villager1_button:
        update_enemy_info("Joseph", villager1_text)
        villager1_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == villager2_button:
        update_enemy_info("Noah", villager2_text)
        villager2_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == villager3_button:
        update_enemy_info("Issam", villager3_text)
        villager3_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == seto1_button:
        update_enemy_info("Seto 1", seto1_text)
        seto1_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == heishin1_button:
        update_enemy_info("Heishin 1", heishin1_text)
        heishin1_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == commentator_button:
        update_enemy_info("Commentator", commentator_text)
        commentator_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == tea_button:
        update_enemy_info("Tea Gardner", tea_text)
        tea_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == yugi_muto_button:
        update_enemy_info("Yugi Muto", yugi_muto_text)
        yugi_muto_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == rex_raptor_button:
        update_enemy_info("Rex Raptor", rex_raptor_text)
        rex_raptor_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == weevil_button:
        update_enemy_info("Weevil Underwood", weevil_text)
        weevil_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == bandit_keith_button:
        update_enemy_info("Bandit Keith", bandit_keith_text)
        bandit_keith_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == bonz_button:
        update_enemy_info("Bonz", bonz_text)
        bonz_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false


    elif btn == amon_button:
        update_enemy_info("Amon", amon_text)
        amon_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false
    elif btn == jonathan_button:
        update_enemy_info("Jonathan Bicalho", jonathan_text)
        jonathan_info.visible = true
        off_buttons.visible = false
        gold_label.visible = false

func _on_button_unhover(btn):
    var tween = create_tween()
    tween.tween_property(btn, "modulate", Color.WHITE, 0.1)


    if btn == unknown_button:
        unknown_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == simon_muran_button:
        simon_muran_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == teana_button:
        teana_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == jono_button:
        jono_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == villager1_button:
        villager1_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == villager2_button:
        villager2_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == villager3_button:
        villager3_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == seto1_button:
        seto1_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == heishin1_button:
        heishin1_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == commentator_button:
        commentator_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == tea_button:
        tea_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == yugi_muto_button:
        yugi_muto_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == rex_raptor_button:
        rex_raptor_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == weevil_button:
        weevil_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == bandit_keith_button:
        bandit_keith_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == bonz_button:
        bonz_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true


    elif btn == amon_button:
        amon_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true
    elif btn == jonathan_button:
        jonathan_info.visible = false
        off_buttons.visible = true
        gold_label.visible = true

func update_enemy_info(enemy_key: String, label: Label):
    var global = get_node("/root/Global")
    var wins = global.get_enemy_stat(enemy_key, "wins")
    var losses = global.get_enemy_stat(enemy_key, "losses")
    var unlocked_count = _calculate_unlocked_cards(enemy_key)
    var total_drops = _get_total_unique_drops(enemy_key)

    var text = "Name: %s\n" % enemy_key
    text += "Wins: %d\n" % wins
    text += "Losses: %d\n" % losses
    text += "Cards Unlocked: %d/%d" % [unlocked_count, total_drops]

    label.text = text

func _calculate_unlocked_cards(enemy_key: String) -> int:
    var drops = _get_unique_drop_ids(enemy_key)
    var global = get_node("/root/Global")
    var count = 0

    for card_id in drops:
        if global.cards_unlocked.has(card_id):
            count += 1

    return count

func _get_total_unique_drops(enemy_key: String) -> int:
    return _get_unique_drop_ids(enemy_key).size()

func _get_unique_drop_ids(enemy_key: String) -> Array:
    if not has_node("/root/EnemyDeckDatabase"):
        return []

    var database = get_node("/root/EnemyDeckDatabase")

    if not database.has_enemy(enemy_key):
        return []

    var drops_data = database.get_enemy_drops(enemy_key)
    var unique_dict = {}

    for rarity in drops_data:
        for card_id in drops_data[rarity]:
            unique_dict[card_id] = true

    return unique_dict.keys()



func _process(delta: float) -> void :
    pass


func _on_build_deck_button_pressed() -> void :

    _play_confirm_sound()
    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/deck_builder/DeckBuilder.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/deck_builder/DeckBuilder.tscn")
    )


func _on_back_button_pressed() -> void :
    _play_confirm_sound()
    if has_node("/root/SceneManage"):
        var scene_manager = get_node("/root/SceneManage")
        scene_manager.go_back()
    else:

        get_tree().change_scene_to_file("res://main_menu.tscn")


func _start_duel(enemy_key: String) -> void :

    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.next_enemy_deck_key = enemy_key


    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/duel/duel.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/duel/duel.tscn")
    )

func _play_bgm():
    var player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/freeplay.mp3")
    if stream:
        stream.loop = true
        player.stream = stream
        player.bus = "Master"
        add_child(player)
        player.play()

func _play_confirm_sound():

    var sound_path = "res://assets/sounds/sfx/confirmbutton.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func _on_unknown_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_unknown) > 500:
            last_click_time_unknown = current_time
            _on_button_hover(unknown_button)
            return

    _play_confirm_sound()
    _start_duel("Unknown")

func _on_simon_muran_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_simon) > 500:
            last_click_time_simon = current_time
            _on_button_hover(simon_muran_button)
            return

    _play_confirm_sound()
    _start_duel("Simon Muran")

func _on_teana_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_teana) > 500:
            last_click_time_teana = current_time
            _on_button_hover(teana_button)
            return

    _play_confirm_sound()
    _start_duel("Teana")

func _on_jono_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_jono) > 500:
            last_click_time_jono = current_time
            _on_button_hover(jono_button)
            return

    _play_confirm_sound()
    _start_duel("Jono")

func _on_villager_1_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_villager1) > 500:
            last_click_time_villager1 = current_time
            _on_button_hover(villager1_button)
            return

    _play_confirm_sound()
    _start_duel("Joseph")

func _on_villager_2_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_villager2) > 500:
            last_click_time_villager2 = current_time
            _on_button_hover(villager2_button)
            return

    _play_confirm_sound()
    _start_duel("Noah")


func _on_villager_3_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_villager3) > 500:
            last_click_time_villager3 = current_time
            _on_button_hover(villager3_button)
            return

    _play_confirm_sound()
    _start_duel("Issam")


func _on_amon_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_amon) > 500:
            last_click_time_amon = current_time
            _on_button_hover(amon_button)
            return

    _play_confirm_sound()
    _start_duel("Amon")


func _on_seto_1_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_seto1) > 500:
            last_click_time_seto1 = current_time
            _on_button_hover(seto1_button)
            return

    _play_confirm_sound()
    _start_duel("Seto 1")


func _on_heishin_1_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_heishin1) > 500:
            last_click_time_heishin1 = current_time
            _on_button_hover(heishin1_button)
            return

    _play_confirm_sound()
    _start_duel("Heishin 1")


func _on_jonathan_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_jonathan) > 500:
            last_click_time_jonathan = current_time
            _on_button_hover(jonathan_button)
            return

    _play_confirm_sound()
    _start_duel("Jonathan Bicalho")


func _on_commentator_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_commentator) > 500:
            last_click_time_commentator = current_time
            _on_button_hover(commentator_button)
            return

    _play_confirm_sound()
    _start_duel("Commentator")


func _on_tea_gardner_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_tea) > 500:
            last_click_time_tea = current_time
            _on_button_hover(tea_button)
            return

    _play_confirm_sound()
    _start_duel("Tea Gardner")


func _on_yugi_muto_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_yugi_muto) > 500:
            last_click_time_yugi_muto = current_time
            _on_button_hover(yugi_muto_button)
            return

    _play_confirm_sound()
    _start_duel("Yugi Muto")


func _on_rex_raptor_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_rex_raptor) > 500:
            last_click_time_rex_raptor = current_time
            _on_button_hover(rex_raptor_button)
            return

    _play_confirm_sound()
    _start_duel("Rex Raptor")


func _on_weevil_underwood_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_weevil) > 500:
            last_click_time_weevil = current_time
            _on_button_hover(weevil_button)
            return

    _play_confirm_sound()
    _start_duel("Weevil Underwood")


func _on_bandit_keith_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_bandit_keith) > 500:
            last_click_time_bandit_keith = current_time
            _on_button_hover(bandit_keith_button)
            return

    _play_confirm_sound()
    _start_duel("Bandit Keith")


func _on_bonz_char_pressed() -> void :
    if OS.get_name() in ["Android", "iOS"]:
        var current_time = Time.get_ticks_msec()
        if (current_time - last_click_time_bonz) > 500:
            last_click_time_bonz = current_time
            _on_button_hover(bonz_button)
            return

    _play_confirm_sound()
    _start_duel("Bonz")
