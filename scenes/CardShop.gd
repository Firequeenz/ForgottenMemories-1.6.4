extends Node2D


@onready var gold_label = $GoldLabel
@onready var back_button = $BackButton
@onready var text_label = $TextLabel
@onready var booster_panel = $BoosterPanel
@onready var solomon_muto = $SolomonMuto
@onready var aqua_panel = $BuyAquaBooster
@onready var beast_panel = $BuyBeastBooster
@onready var beast_warrior_panel = $BuyBeastWarriorBooster
@onready var dinosaur_panel = $BuyDinosaurBooster
@onready var dragon_panel = $BuyDragonBooster
@onready var fairy_panel = $BuyFairyBooster
@onready var fiend_panel = $BuyFiendBooster
@onready var fish_panel = $BuyFishBooster
@onready var insect_panel = $BuyInsectBooster
@onready var machine_panel = $BuyMachineBooster
@onready var plant_panel = $BuyPlantBooster
@onready var pyro_panel = $BuyPyroBooster
@onready var reptile_panel = $BuyReptileBooster
@onready var rock_panel = $BuyRockBooster
@onready var sea_serpent_panel = $BuySeaSerpentBooster
@onready var spellcaster_panel = $BuySpellcasterBooster
@onready var thunder_panel = $BuyThunderBooster
@onready var warrior_panel = $BuyWarriorBooster
@onready var winged_beast_panel = $BuyWingedBeastBooster
@onready var zombie_panel = $BuyZombieBooster
@onready var audio_player: AudioStreamPlayer = null

const CARD_VISUAL_SCENE = preload("res://scenes/CardVisual.tscn")
const FONT_MATRIX_BOLD = preload("res://assets/fonts/MatrixSmallCaps Bold.ttf")




var EXCLUDED_FROM_PACKS: Array[int] = [
    17, 18, 19, 20, 21, 311, 651, 655, 665, 666, 304, 321, 693, 337, 349, 
    657, 661, 658, 723, 613, 756, 761, 763, 99999, 99998, 765, 768, 775, 
    698, 713, 374, 778, 784, 781, 82, 67, 788, 791, 794, 795, 796, 747, 
    802, 801, 803, 217, 38
]


func _ready() -> void :
    _setup_transition_effect()
    update_gold_display()
    _setup_hover_effects()
    _update_booster_unlocked_stats()
    _play_intro_animations()
    _play_bgm()
    await get_tree().create_timer(0.5).timeout
    show_welcome_message()

func _update_booster_unlocked_stats() -> void :

    if Global.has_method("sync_with_cardcollection"):
        Global.sync_with_cardcollection()

    var types = [
        "Aqua", "Beast", "Beast-Warrior", "Dinosaur", "Dragon", 
        "Fairy", "Fiend", "Fish", "Insect", "Machine", 
        "Plant", "Pyro", "Reptile", "Rock", "Sea Serpent", 
        "Spellcaster", "Thunder", "Warrior", "Winged-Beast", "Zombie"
    ]

    for t in types:

        var type_cards = _get_cards_by_criteria(t)
        var total_unique_in_game = type_cards.size()


        var unique_unlocked = 0
        for card in type_cards:
            if Global.has_card(card.id, 1):
                unique_unlocked += 1



        var node_name_prefix = t.replace("-", "").replace(" ", "")

        var label_node_name = "Buy" + node_name_prefix + "Booster/" + node_name_prefix + "Text"
        if has_node(label_node_name):
            var label_node = get_node(label_node_name)











            var current_text = label_node.text

            var new_text = current_text.replace("Unlocked: x/y", "Unlocked: %d/%d" % [unique_unlocked, total_unique_in_game])
            label_node.text = new_text


func _play_intro_animations():
    var screen_size = get_viewport_rect().size
    var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


    if gold_label:
        var final_pos = gold_label.position
        gold_label.position.y -= 200
        tween.tween_property(gold_label, "position", final_pos, 1.0)

    if back_button:
        var final_pos = back_button.position
        back_button.position.y -= 200
        tween.tween_property(back_button, "position", final_pos, 1.0)


    if booster_panel:
        var final_pos = booster_panel.position
        booster_panel.position.y += screen_size.y
        tween.tween_property(booster_panel, "position", final_pos, 1.0)


    if solomon_muto:
        var final_pos = solomon_muto.position
        solomon_muto.position.x += 600
        tween.tween_property(solomon_muto, "position", final_pos, 1.0)

func _setup_hover_effects():

    if back_button:
        _connect_button_hover(back_button)



    if booster_panel:
        var buttons = booster_panel.find_children("", "BaseButton", true, false)
        for btn in buttons:
            _connect_button_hover(btn)

func _connect_button_hover(btn: BaseButton):
    if not btn.is_connected("mouse_entered", _on_button_hover):
        btn.mouse_entered.connect(_on_button_hover.bind(btn))
    if not btn.is_connected("mouse_exited", _on_button_unhover):
        btn.mouse_exited.connect(_on_button_unhover.bind(btn))

func _on_button_hover(btn: BaseButton):
    var tween = create_tween()
    tween.tween_property(btn, "modulate", Color(0.392, 0.392, 0.392, 1.0), 0.1)

func _on_button_unhover(btn: BaseButton):
    var tween = create_tween()
    tween.tween_property(btn, "modulate", Color.WHITE, 0.1)

func show_welcome_message():
    if text_label:
        text_label.text = "Hey!\nWhat are you buying today?"
        text_label.visible_ratio = 0.0

        var tween = create_tween()
        tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)

func update_gold_display():
    if gold_label and has_node("/root/Global"):
        var global = get_node("/root/Global")


        gold_label.text = "[img=40]res://assets/starchip.png[/img]x%d" % global.gold

func _setup_transition_effect():

    var fade_rect = ColorRect.new()
    fade_rect.color = Color(0, 0, 0, 1)
    fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
    fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    fade_rect.z_index = 100
    add_child(fade_rect)


    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 1.0)
    tween.tween_callback(fade_rect.queue_free)



func _process(delta: float) -> void :
    pass

func _on_back_button_pressed() -> void :
    _play_confirm_sound()

    if has_node("/root/SceneManage"):
        var scene_manager = get_node("/root/SceneManage")
        scene_manager.go_back()
    else:

        get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_aqua_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = true
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_beast_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = true
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_beast_warrior_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = true
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_dinosaur_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = true
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_dragon_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = true
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_fairy_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = true
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_fiend_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = true
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_fish_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = true
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_insect_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = true
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_machine_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = true
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_plant_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = true
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_pyro_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = true
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_reptile_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = true
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_rock_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = true
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_sea_serpent_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = true
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_spellcaster_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = true
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_thunder_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = true
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_warrior_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = true
    winged_beast_panel.visible = false
    zombie_panel.visible = false

func _on_winged_beast_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = true
    zombie_panel.visible = false

func _on_zombie_booster_pressed() -> void :
    _play_confirm_sound()
    _update_booster_unlocked_stats()
    aqua_panel.visible = false
    beast_panel.visible = false
    beast_warrior_panel.visible = false
    dinosaur_panel.visible = false
    dragon_panel.visible = false
    fairy_panel.visible = false
    fiend_panel.visible = false
    fish_panel.visible = false
    insect_panel.visible = false
    machine_panel.visible = false
    plant_panel.visible = false
    pyro_panel.visible = false
    reptile_panel.visible = false
    rock_panel.visible = false
    sea_serpent_panel.visible = false
    spellcaster_panel.visible = false
    thunder_panel.visible = false
    warrior_panel.visible = false
    winged_beast_panel.visible = false
    zombie_panel.visible = true

func _on_aqua_back_button_pressed() -> void :
    _play_confirm_sound()
    aqua_panel.visible = false

func _buy_pack(type_filter: String) -> void :
    if not has_node("/root/Global"):
        return

    var global = get_node("/root/Global")
    var cost = 150

    if global.gold >= cost:


        var rng = RandomNumberGenerator.new()
        rng.seed = global.shop_rng_seed


        var old_gold = global.gold
        global.gold -= cost
        animate_gold_change(old_gold, global.gold)
        _play_coin_sound()


        var unlocked_cards = []


        var type_cards = _get_cards_by_criteria(type_filter)
        for i in range(8):
            if type_cards.size() > 0:
                unlocked_cards.append(_pick_card_by_level_probability(type_cards, rng))


        var spell_trap_cards = _get_cards_by_criteria("", [CardData.CardCategory.MAGIC, CardData.CardCategory.TRAP])
        for i in range(2):
            if spell_trap_cards.size() > 0:
                unlocked_cards.append(spell_trap_cards[rng.randi() % spell_trap_cards.size()])


        var all_monster_cards = _get_all_monster_cards()
        for i in range(2):
            if all_monster_cards.size() > 0:
                unlocked_cards.append(_pick_card_by_level_probability(all_monster_cards, rng))


        global.shop_rng_seed = rng.randi()


        var collection = get_node("/root/CardCollection") if has_node("/root/CardCollection") else null
        var surplus_card_ids = []

        print("--- Pack Opened: 12 Cards (%s) ---" % type_filter)
        for card in unlocked_cards:

            var current_qty = global.cards_unlocked.get(card.id, 0)

            if current_qty >= 3:

                surplus_card_ids.append(card.id)
                global.gold += 1
                print("SURPLUS: %s (ID: %d) já tem %d cópias. +1 gold" % [card.name, card.id, current_qty])
            else:
                if collection:
                    collection.unlock_card(card.id)
                else:
                    global.unlock_card(card.id)
                print("Unlocked: %s (ID: %d)" % [card.name, card.id])


        if collection:
            collection.save_collection()
            if global.has_method("sync_with_cardcollection"):
                global.sync_with_cardcollection()
        else:
            global.save_player_data()


        if gold_label:
            gold_label.text = "[img=40]res://assets/starchip.png[/img]x%d" % global.gold

        if surplus_card_ids.size() > 0:
            print("--- Surplus: %d cartas convertidas em gold ---" % surplus_card_ids.size())

        await get_tree().create_timer(0.5).timeout


        await show_reward_window(unlocked_cards, surplus_card_ids)
        _play_packopen_sound()
        _update_booster_unlocked_stats()
    else:
        print("Not enough gold!")
        if text_label:
            text_label.text = "Not enough Starchips!"
            text_label.visible_ratio = 0.0
            var tween = create_tween()
            await tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)
            tween.tween_property(text_label, "modulate", Color.RED, 0.2)
            tween.tween_property(text_label, "modulate", Color.WHITE, 0.2)


func _on_buy_aqua_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Aqua")

func _on_buy_beast_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Beast")

func animate_gold_change(start_val: int, end_val: int):
    var tween = create_tween()
    tween.tween_method( func(val):
        if gold_label:
            gold_label.text = "[img=40]res://assets/starchip.png[/img]x%d" % int(val)
    , start_val, end_val, 0.5)

func _get_cards_by_criteria(type_filter: String = "", category_filters: Array = []) -> Array:
    var result = []
    if not has_node("/root/CardDatabase"):
        return result

    var db = get_node("/root/CardDatabase")
    for card_id in db.cards:
        var card = db.cards[card_id]


        if card_id in EXCLUDED_FROM_PACKS:
            continue

        var match_type = true
        var match_category = true

        if type_filter != "":
            if card.type.to_lower() != type_filter.to_lower():
                match_type = false

        if category_filters.size() > 0:
            if not (card.category in category_filters):
                match_category = false

        if match_type and match_category:
            result.append(card)

    return result

func _get_all_cards() -> Array:
    var result = []
    if not has_node("/root/CardDatabase"):
        return result

    var db = get_node("/root/CardDatabase")
    for card_id in db.cards:
        if card_id in EXCLUDED_FROM_PACKS:
            continue
        result.append(db.cards[card_id])
    return result

func _get_all_monster_cards() -> Array:
    var result = []
    if not has_node("/root/CardDatabase"):
        return result
    var db = get_node("/root/CardDatabase")
    for card_id in db.cards:
        if card_id in EXCLUDED_FROM_PACKS:
            continue
        var card = db.cards[card_id]
        if card.category != CardData.CardCategory.MAGIC and card.category != CardData.CardCategory.TRAP:
            result.append(card)
    return result

func _pick_card_by_level_probability(card_pool: Array, rng: RandomNumberGenerator) -> CardData:

    var common_cards = []
    var rare_cards = []
    var super_rare_cards = []
    var epic_cards = []
    var legendary_cards = []

    for card in card_pool:
        if card.category == CardData.CardCategory.MAGIC or card.category == CardData.CardCategory.TRAP:
            rare_cards.append(card)
            continue
        if card.level >= 11:
            legendary_cards.append(card)
        elif card.level >= 9:
            epic_cards.append(card)
        elif card.level >= 7:
            super_rare_cards.append(card)
        elif card.level >= 5:
            rare_cards.append(card)
        else:
            common_cards.append(card)


    var tiers = []
    if common_cards.size() > 0:
        tiers.append({"cards": common_cards, "weight": 0.89})
    if rare_cards.size() > 0:
        tiers.append({"cards": rare_cards, "weight": 0.094})
    if super_rare_cards.size() > 0:
        tiers.append({"cards": super_rare_cards, "weight": 0.01})
    if epic_cards.size() > 0:
        tiers.append({"cards": epic_cards, "weight": 0.005})
    if legendary_cards.size() > 0:
        tiers.append({"cards": legendary_cards, "weight": 0.001})

    if tiers.size() == 0:
        return card_pool[rng.randi() % card_pool.size()]


    var total_weight = 0.0
    for tier in tiers:
        total_weight += tier["weight"]


    var roll = rng.randf() * total_weight
    var cumulative = 0.0
    for tier in tiers:
        cumulative += tier["weight"]
        if roll <= cumulative:
            var current_tier_cards = tier["cards"]
            return current_tier_cards[rng.randi() % current_tier_cards.size()]


    var last_tier_cards = tiers[tiers.size() - 1]["cards"]
    return last_tier_cards[rng.randi() % last_tier_cards.size()]

func show_reward_window(cards_list: Array, surplus_ids: Array = []):

    var overlay = CanvasLayer.new()
    overlay.layer = 100
    add_child(overlay)


    var bg = ColorRect.new()
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.color = Color(0.0, 0.0, 0.0, 0.98)
    bg.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(bg)


    var title = Label.new()
    title.text = "YOU GOT A NEW PACK!"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.set_anchors_preset(Control.PRESET_TOP_WIDE)
    title.position.y = 250


    var settings = LabelSettings.new()
    settings.font = FONT_MATRIX_BOLD
    settings.font_size = 75
    settings.outline_size = 10
    settings.outline_color = Color.BLACK
    title.label_settings = settings
    overlay.add_child(title)


    var grid_center_container = CenterContainer.new()
    grid_center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
    overlay.add_child(grid_center_container)

    var grid = GridContainer.new()
    grid.columns = 6
    grid.add_theme_constant_override("h_separation", 15)
    grid.add_theme_constant_override("v_separation", 15)
    grid_center_container.add_child(grid)


    var details_label = Label.new()
    details_label.text = ""
    details_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    details_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    details_label.position.y = -340
    details_label.label_settings = LabelSettings.new()
    details_label.label_settings.font_size = 24
    overlay.add_child(details_label)


    for i in range(cards_list.size()):
        var card_data = cards_list[i]
        var wrapper = Control.new()
        wrapper.custom_minimum_size = Vector2(120, 180)
        grid.add_child(wrapper)

        var card_visual = CARD_VISUAL_SCENE.instantiate()
        wrapper.add_child(card_visual)
        card_visual.scale = Vector2(0.35, 0.35)
        card_visual.set_card_data(card_data, -1)


        card_visual.modulate.a = 0.0

        var tween = create_tween().bind_node(card_visual)
        tween.tween_interval(i * 0.15)
        tween.tween_property(card_visual, "modulate:a", 1.0, 0.3)

        card_visual.mouse_filter = Control.MOUSE_FILTER_PASS

        card_visual.mouse_entered.connect( func():
            details_label.text = "#%d %s" % [card_data.id, card_data.name]
            if card_data.category in [CardData.CardCategory.MAGIC, CardData.CardCategory.TRAP]:
                 details_label.text += " [%s]" % ("MAGIC" if card_data.category == CardData.CardCategory.MAGIC else "TRAP")
            else:
                 details_label.text += " [ATK: %d / DEF: %d]" % [card_data.atk, card_data.def]
        )
        card_visual.mouse_exited.connect( func():
            details_label.text = ""
        )


        if card_data.id in surplus_ids:

            surplus_ids.erase(card_data.id)


            tween.tween_callback( func():
                if is_instance_valid(card_visual):
                    card_visual.modulate = Color(0.3, 0.3, 0.3, 1.0)
            )


            var overlay_surplus = CenterContainer.new()
            overlay_surplus.set_anchors_preset(Control.PRESET_FULL_RECT)
            overlay_surplus.mouse_filter = Control.MOUSE_FILTER_IGNORE
            wrapper.add_child(overlay_surplus)

            var hbox = HBoxContainer.new()
            hbox.alignment = BoxContainer.ALIGNMENT_CENTER
            hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
            hbox.add_theme_constant_override("separation", 4)
            overlay_surplus.add_child(hbox)


            var gold_label_surplus = Label.new()
            gold_label_surplus.text = ""
            var base_font_s = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
            var font_s = FontVariation.new()
            font_s.base_font = base_font_s
            font_s.spacing_glyph = 1
            gold_label_surplus.add_theme_font_override("font", font_s)
            gold_label_surplus.add_theme_font_size_override("font_size", 40)
            gold_label_surplus.add_theme_constant_override("outline_size", 10)
            gold_label_surplus.add_theme_color_override("font_outline_color", Color.BLACK)
            gold_label_surplus.add_theme_color_override("font_color", Color.WHITE)
            gold_label_surplus.add_theme_constant_override("margin_top", 20)
            gold_label_surplus.mouse_filter = Control.MOUSE_FILTER_IGNORE
            hbox.add_child(gold_label_surplus)


            var starchip_icon = TextureRect.new()
            var starchip_tex = load("res://assets/starchip.png")
            if starchip_tex:
                starchip_icon.texture = starchip_tex
                starchip_icon.custom_minimum_size = Vector2(60, 60)
                starchip_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                starchip_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                starchip_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
                hbox.add_child(starchip_icon)


            overlay_surplus.modulate.a = 0.0
            var overlay_tween = create_tween().bind_node(overlay_surplus)
            overlay_tween.tween_interval(i * 0.15 + 0.3)
            overlay_tween.tween_property(overlay_surplus, "modulate:a", 1.0, 0.2)


    var close_btn = Button.new()
    close_btn.text = "CLOSE"
    close_btn.custom_minimum_size = Vector2(200, 60)


    var btn_style = StyleBoxFlat.new()
    btn_style.bg_color = Color(0.1, 0.1, 0.1, 1.0)
    btn_style.border_width_bottom = 2
    btn_style.border_width_top = 2
    btn_style.border_width_left = 2
    btn_style.border_width_right = 2
    btn_style.border_color = Color.WHITE
    btn_style.corner_radius_top_left = 5
    btn_style.corner_radius_top_right = 5
    btn_style.corner_radius_bottom_right = 5
    btn_style.corner_radius_bottom_left = 5
    btn_style.content_margin_top = 15
    btn_style.content_margin_bottom = 5


    var btn_hover_style = btn_style.duplicate()
    btn_hover_style.bg_color = Color(0.05, 0.05, 0.05, 1.0)

    close_btn.add_theme_stylebox_override("normal", btn_style)
    close_btn.add_theme_stylebox_override("hover", btn_hover_style)
    close_btn.add_theme_stylebox_override("pressed", btn_hover_style)


    close_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

    close_btn.add_theme_font_override("font", FONT_MATRIX_BOLD)
    close_btn.add_theme_font_size_override("font_size", 30)
    close_btn.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
    close_btn.position.y = -160

    close_btn.anchor_left = 0.5
    close_btn.anchor_top = 0.9
    close_btn.anchor_right = 0.5
    close_btn.anchor_bottom = 0.9
    close_btn.grow_horizontal = Control.GROW_DIRECTION_BOTH
    close_btn.grow_vertical = Control.GROW_DIRECTION_BOTH

    close_btn.pressed.connect( func():
        _play_confirm_sound()
        overlay.queue_free()

        update_gold_display()
    )
    overlay.add_child(close_btn)


func _on_beast_back_button_pressed() -> void :
    _play_confirm_sound()
    beast_panel.visible = false

func _on_buy_beast_warrior_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Beast-Warrior")

func _on_beast_warrior_back_button_pressed() -> void :
    _play_confirm_sound()
    beast_warrior_panel.visible = false

func _on_buy_dinosaur_warrior_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Dinosaur")

func _on_dinosaur_back_button_pressed() -> void :
    _play_confirm_sound()
    dinosaur_panel.visible = false

func _on_buy_dragon_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Dragon")

func _on_dragon_back_button_pressed() -> void :
    _play_confirm_sound()
    dragon_panel.visible = false

func _on_buy_fairy_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Fairy")

func _on_fairy_back_button_pressed() -> void :
    _play_confirm_sound()
    fairy_panel.visible = false

func _on_buy_fiend_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Fiend")

func _on_fiend_back_button_pressed() -> void :
    _play_confirm_sound()
    fiend_panel.visible = false

func _on_buy_fish_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Fish")

func _on_fish_back_button_pressed() -> void :
    _play_confirm_sound()
    fish_panel.visible = false


func _on_buy_insect_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Insect")


func _on_insect_back_button_pressed() -> void :
    _play_confirm_sound()
    insect_panel.visible = false


func _on_buy_machine_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Machine")


func _on_machine_back_button_pressed() -> void :
    _play_confirm_sound()
    machine_panel.visible = false


func _on_buy_plant_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Plant")


func _on_plant_back_button_pressed() -> void :
    _play_confirm_sound()
    plant_panel.visible = false


func _on_buy_pyro_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Pyro")


func _on_pyro_back_button_pressed() -> void :
    _play_confirm_sound()
    pyro_panel.visible = false


func _on_buy_reptile_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Reptile")


func _on_reptile_back_button_pressed() -> void :
    _play_confirm_sound()
    reptile_panel.visible = false


func _on_buy_rock_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Rock")


func _on_rock_back_button_pressed() -> void :
    _play_confirm_sound()
    rock_panel.visible = false


func _on_buy_sea_serpent_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Sea Serpent")


func _on_sea_serpent_back_button_pressed() -> void :
    _play_confirm_sound()
    sea_serpent_panel.visible = false


func _on_buy_spellcaster_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Spellcaster")


func _on_spellcaster_back_button_pressed() -> void :
    _play_confirm_sound()
    spellcaster_panel.visible = false


func _on_buy_thunder_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Thunder")


func _on_thunder_back_button_pressed() -> void :
    _play_confirm_sound()
    thunder_panel.visible = false


func _on_buy_warrior_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Warrior")


func _on_warrior_back_button_pressed() -> void :
    _play_confirm_sound()
    warrior_panel.visible = false


func _on_buy_winged_beast_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Winged-Beast")


func _on_winged_beast_back_button_pressed() -> void :
    _play_confirm_sound()
    winged_beast_panel.visible = false


func _on_buy_zombie_button_pressed() -> void :
    _play_confirm_sound()
    _buy_pack("Zombie")


func _on_zombie_back_button_pressed() -> void :
    _play_confirm_sound()
    zombie_panel.visible = false

func _play_bgm():
    var player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/cardshop.mp3")
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

func _play_coin_sound():

    var sound_path = "res://assets/sounds/sfx/coin.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func _play_packopen_sound():

    var sound_path = "res://assets/sounds/sfx/packopen.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()
