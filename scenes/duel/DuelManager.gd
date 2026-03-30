extends Node2D


const FIELD_SCALE = Vector2(1, 1)
const EXODIA_IDS = [17, 18, 19, 20, 21]
const KURIBOH_ID = 58
var CARD_BACK_TEXTURE = preload("res://assets/cards/card_back.png")
const BTN_TEX_ATTACK = preload("res://assets/summonbtn.png")
const BTN_TEX_DEFENSE = preload("res://assets/setbtn.png")
const BTN_TEX_ACTIVATE = preload("res://assets/activate.png")
const BTN_TEX_SET = preload("res://assets/set.png")
const CARD_DRAW_DURATION = 0.3
const CARD_DRAW_STAGGER = 0.1
const EQUIP_BLACK_PENDANT = 311
const BLACK_PENDANT_DESTRUCTION_DAMAGE = 500
const HARPY_LADY_ID = 62
const GOBLIN_ZOMBIE_ID = 802
const TRAP_MIRROR_FORCE = 723
const DIRECT_ATTACK_MONSTER_IDS = [422, 488, 387, 397, 398, 635, 99998]
const SUMMON_CIRCLE_TEXTURE = preload("res://assets/summoncircle.png")
const RITUAL_CARDS = [673, 676, 677, 671, 670, 674, 699]


enum TurnPhase{DRAW, PLAYER, BATTLE, ENEMY}
enum Turn{PLAYER, ENEMY}
enum GameState{MAIN_PHASE, BATTLE_TARGETING, ENEMY_TURN, EQUIP_TARGETING, STOP_DEFENSE_TARGETING}


var card_visual_scene = preload("res://scenes/CardVisual.tscn")
var cards_pool = CardDatabase.get_all_cards()
var audio_player: AudioStreamPlayer = null
var bgm_player: AudioStreamPlayer = null


var current_turn: Turn = Turn.PLAYER
var current_phase: TurnPhase = TurnPhase.DRAW
var current_game_state = GameState.MAIN_PHASE
var current_field_type: String = "None"
var turn_number: int = 1
var game_over: bool = false
var trap_canceled_the_battle: bool = false


var _obs_player_lp: int = 10000
var _player_lp_key: int = 0
var player_lp: int:
    get:
        return _obs_player_lp ^ _player_lp_key
    set(value):
        _player_lp_key = randi()
        _obs_player_lp = value ^ _player_lp_key

var _obs_enemy_lp: int = 10000
var _enemy_lp_key: int = 0
var enemy_lp: int:
    get:
        return _obs_enemy_lp ^ _enemy_lp_key
    set(value):
        _enemy_lp_key = randi()
        _obs_enemy_lp = value ^ _enemy_lp_key


var player_deck_pile: Array[CardData] = []
var enemy_deck_pile: Array[CardData] = []
var player_hand: Array[CardData] = []
var enemy_hand: Array[CardData] = []
var player_graveyard: Array[CardData] = []
var enemy_graveyard: Array[CardData] = []


var player_slots: Array = []
var enemy_slots: Array = []
var player_spell_slots: Array = []
var enemy_spell_slots: Array = []


var player_has_played: bool = false
var enemy_has_played: bool = false
var is_resolving_battle: bool = false
var pending_turn_end: bool = false
var waboku_active_player: bool = false
var waboku_active_enemy: bool = false
var reverse_trap_active_player: bool = false
var reverse_trap_active_enemy: bool = false
var reverse_trap_field_player: bool = false
var reverse_trap_field_enemy: bool = false
var reinforcements_active_monsters: Array = []
var castle_walls_active_monsters: Array = []
var union_attack_active_monsters: Array = []


var selected_cards: Array = []
var selected_indices: Array[int] = []
var current_hovered_card = null
var last_card_with_buttons = null
var click_was_on_card: bool = false


var player_card: CardData
var enemy_card: CardData
var enemy_position: String = "Attack"
var player_position: String = "Attack"
var enemy_used_cards: Array = []


var _temp_fusion_cards: Array[CardData] = []
var pending_card_to_play: CardData = null
var pending_equip_cards: Array[CardData] = []
var pending_play_position: String = ""
var is_selecting_slot: bool = false
var activating_equip_from_field_slot = null
var _temp_intermediate_fusion_results: Array = []


var attacker_slot_ref = null
var _is_processing_action: bool = false


@export var selected_enemy_deck_key: String = "Simon Muran"
var trap_processing_count: int = 0
var is_processing_trap: bool:
    get:
        return trap_processing_count > 0 or additional_processing_lock > 0
    set(value):
        if value:
            trap_processing_count += 1
        else:
            trap_processing_count = max(0, trap_processing_count - 1)

var additional_processing_lock: int = 0
var enemy_turn_counter: int = 0
var current_enemy_difficulty: String = "Easy"


var surrender_pending: bool = false
var current_player_name: String = "Player"
var enable_lp_floating_text: bool = true


var guardian_advantage = {
    "Sun": "Moon", 
    "Moon": "Star", 
    "Star": "Sun"
}


var duel_score_system = DuelScoreSystem.new()
var enemy_drop_system = EnemyDropSystem.new()
var cards_used_this_duel: int = 0


var victory_animation_tween: Tween = null
var defeat_animation_tween: Tween = null


var black_pendant_equipped_monsters: Array = []
var elegant_egotist_equipped_monsters: Array = []
var metalmorph_equipped_monsters: Array = []


var stop_defense_activation_slot = null
var pending_stop_defense_target_player: bool = false

var card_status_effects = {}


@onready var player_slot = $Battlefield / PlayerSlotsContainer
@onready var enemy_slot = $Battlefield / EnemySlotsContainer
@onready var player_name_label = $CanvasLayer / PlayerNameBox / Label
@onready var enemy_name_label = $CanvasLayer / EnemyNameBox / Label
@onready var player_deck_visual = $Battlefield / PlayerDeckPileVisual
@onready var enemy_deck_visual = $Battlefield / EnemyDeckPileVisual
@onready var player_lp_label = $CanvasLayer / PlayerLPFrame / PlayerLPLabel
@onready var enemy_lp_label = $CanvasLayer / EnemyLPFrame / EnemyLPLabel
@onready var player_gy_visual = $Battlefield / PlayerGraveyard
@onready var enemy_gy_visual = $Battlefield / EnemyGraveyard
@onready var enemy_portrait = $CanvasLayer / EnemyCharFrame / EnemyPortrait
@onready var card_inspector = $CanvasLayer / CardInspector
@onready var surrender_btn = $CanvasLayer / SurrenderButton
@onready var surrender_bubble = $CanvasLayer / SurrenderButton / ConfirmBubble
@onready var graveyard_window = $CanvasLayer / GraveyardWindow
@onready var field_label = $CanvasLayer / FieldFrame / FieldLabel
@onready var forest_bg = $Battlefield / ForestField
@onready var wasteland_bg = $Battlefield / WastelandField
@onready var mountain_bg = $Battlefield / MountainField
@onready var sogen_bg = $Battlefield / SogenField
@onready var umi_bg = $Battlefield / UmiField
@onready var yami_bg = $Battlefield / YamiField
@onready var gaia_power_bg = $Battlefield / GaiaPowerField
@onready var sanctuary_in_the_sky_bg = $Battlefield / SanctuaryInTheSkyField
@onready var jurassic_world_bg = $Battlefield / JurassicWorldField
@onready var intro_animation = $DuelIntroAnimation
@onready var enemy_ai = $EnemyAI
@onready var victory_screen = $VictoryCanvasLayer / VictoryScreen
@onready var victory_continue_btn = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / ContinueButton
@onready var victory_title_label = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / TitleLabel
@onready var victory_rank_label = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / RankLabel
@onready var victory_score_label = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / ScoreLabel


var bgm_players = {
    "normal": null, 
    "winning": null, 
    "losing": null
}
var current_bgm_state = "normal"
@onready var victory_details_label = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / DetailsLabel
@onready var victory_rewards_label = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / RewardsLabel
@onready var defeat_screen = $DefeatCanvasLayer / DefeatScreen
@onready var defeat_continue_btn = $DefeatCanvasLayer / DefeatScreen / VBoxContainer / ContinueButton
@onready var defeat_title_label = $DefeatCanvasLayer / DefeatScreen / VBoxContainer / TitleLabel
@onready var defeat_message_label = $DefeatCanvasLayer / DefeatScreen / VBoxContainer / MessageLabel
@onready var victory_cards_grid = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / CardsMiniaturesGrid
@onready var ritual_summon = $Battlefield / RitualSummon
@onready var player_avatar = $CanvasLayer / PlayerCharFrame / PlayerChar


var mobile_last_tap_time: float = 0
var mobile_tap_threshold: float = 0.3
var mobile_last_tap_position: Vector2 = Vector2.ZERO


var _last_card_draw_time: int = 0
var _last_discard_time: int = 0
var _card_draw_delay_offset: float = 0.0
var _card_discard_delay_offset: float = 0.0


var duel_speed: int = 1
var speed_buttons_container: VBoxContainer = null
var speed_buttons: Array = []


var _last_animate_lp_target_player: int = -1
var _last_animate_lp_target_enemy: int = -1
var _last_logical_player_lp: int = 10000
var _last_logical_enemy_lp: int = 10000


func _ready():

    set_process_input(false)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        var avatar_path = global.get_avatar_texture_path()
        if player_avatar and ResourceLoader.exists(avatar_path):
            player_avatar.texture = load(avatar_path)
        if global.has_method("get_card_back_texture_path"):
            var card_back_path = global.get_card_back_texture_path()
            if ResourceLoader.exists(card_back_path):
                CARD_BACK_TEXTURE = load(card_back_path)

    build_decks_and_setup_match()
    _start_game()
    _trap_signal()
    _play_bgm()


    _apply_duel_speed()
    _create_speed_buttons()

    if enemy_deck_visual:
        enemy_deck_visual.is_enemy_pile = true


    duel_score_system = DuelScoreSystem.new()
    enemy_drop_system = EnemyDropSystem.new()


    add_child(duel_score_system)
    add_child(enemy_drop_system)


    if intro_animation:
        intro_animation.intro_finished.connect(_on_intro_finished)
        intro_animation.play_intro()
    else:
        _initialize_game_after_intro()


    duel_score_system.setup(selected_enemy_deck_key)


    if has_node("/root/CardCollection"):
        var collection = get_node("/root/CardCollection")


    if victory_continue_btn:
        print("Conectando botão Continue...")

        if victory_continue_btn.pressed.is_connected(_on_continue_button_pressed):
            victory_continue_btn.pressed.disconnect(_on_continue_button_pressed)


        victory_continue_btn.pressed.connect(_on_continue_button_pressed)
        print("Botão Continue conectado com sucesso")
    else:
        print("ERRO: victory_continue_btn não encontrado!")

    if defeat_continue_btn:
        if not defeat_continue_btn.pressed.is_connected(_on_defeat_continue_pressed):
            defeat_continue_btn.pressed.connect(_on_defeat_continue_pressed)

func _trap_signal():
    is_processing_trap = true
    EventBus.trap_consumed.connect(_on_trap_consumed)
    EventBus.trap_triggered.connect(_on_trap_triggered)
    is_processing_trap = false

func _on_intro_finished():

    _initialize_game_after_intro()

func _initialize_game_after_intro():

    _initialize_game()
    _setup_ui_connections()
    _setup_slots()


    set_process_input(true)

func _initialize_game():
    $ResultLabel.text = ""
    EffectManager.duel_manager = self
    if has_node("EffectVideoLayer"):
        EffectManager.effect_video_layer = $EffectVideoLayer

    enemy_has_played = false
    turn_number = 1
    current_turn = Turn.PLAYER
    current_phase = TurnPhase.PLAYER


    if enemy_ai:
        enemy_ai.setup(enemy_hand, enemy_slots, player_slots, enemy_spell_slots)
        enemy_ai.set_difficulty(current_enemy_difficulty)

func _setup_ui_connections():
    if surrender_btn:
        surrender_btn.pressed.connect(_on_surrender_pressed)
        surrender_bubble.visible = false

    if graveyard_window:
        graveyard_window.visible = false
        if not graveyard_window.card_hovered.is_connected(_on_card_hover_update):
            graveyard_window.card_hovered.connect(_on_card_hover_update)

    _connect_graveyard_visual(player_gy_visual, _on_player_gy_clicked, 0.0)
    _connect_graveyard_visual(enemy_gy_visual, _on_enemy_gy_clicked, 180.0)


    if player_gy_visual and graveyard_window:
        player_gy_visual.link_graveyard_window(graveyard_window)
    if enemy_gy_visual and graveyard_window:
        enemy_gy_visual.link_graveyard_window(graveyard_window)

func _connect_graveyard_visual(gy_visual, callback, rotation: float):
    if not gy_visual: return


    if gy_visual.clicked.is_connected(callback):
        gy_visual.clicked.disconnect(callback)


    gy_visual.clicked.connect(callback)

    if gy_visual.get("card_rotation") != null:
        gy_visual.card_rotation = rotation

    print("[DuelManager] Cemitério conectado: ", gy_visual.name)

func _setup_slots():
    _setup_slot_container($Battlefield / PlayerSlotsContainer, player_slots, true, _on_player_slot_clicked)
    _setup_slot_container($Battlefield / EnemySlotsContainer, enemy_slots, false, _on_enemy_slot_clicked)
    _setup_slot_container($Battlefield / PlayerSpellSlotsContainer, player_spell_slots, true, null)
    _setup_slot_container($Battlefield / EnemySpellSlotsContainer, enemy_spell_slots, false, null)

func _setup_slot_container(container: Node, slot_array: Array, is_player: bool, click_callback):
    for i in range(container.get_child_count()):
        var slot = container.get_child(i)
        slot.slot_index = i
        slot.is_player_slot = is_player

        if click_callback and not slot.slot_clicked.is_connected(click_callback):
            slot.slot_clicked.connect(click_callback)


        if not is_player:
            slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
            slot.mouse_filter = Control.MOUSE_FILTER_PASS

        slot_array.append(slot)

func _start_game():

    TrapManager.clear_all_traps()
    reverse_trap_active_player = false
    reverse_trap_active_enemy = false
    reverse_trap_field_player = false
    reverse_trap_field_enemy = false

    create_player_hand()
    create_enemy_hand()
    await update_hand_ui_animated(true)
    await update_enemy_hand_ui_animated(true)

    EffectManager.check_hand_effects(true, player_hand)
    EffectManager.check_hand_effects(false, enemy_hand)
    update_lp_ui()
    update_turn_ui()
    update_names_ui()
    hide_battle_buttons()
    set_end_turn_button_active(false)


func update_turn_ui():
    $CanvasLayer / TurnFrame / TurnLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    $CanvasLayer / TurnFrame / TurnLabel.text = "%d\n%s" % [
        turn_number, 
        "Player" if current_phase == TurnPhase.PLAYER else "Enemy"
    ]

func update_lp_ui():

    if player_lp < 0:
        player_lp = 0
    if enemy_lp < 0:
        enemy_lp = 0

    await animate_lp_change(player_lp_label, player_lp)
    await animate_lp_change(enemy_lp_label, enemy_lp)

    _check_bgm_state()




func heal_lp(is_player_healed: bool, amount: int) -> void :
    if amount <= 0:
        return


    var opponent_traps = TrapManager.enemy_traps if is_player_healed else TrapManager.player_traps
    var bad_reaction_trap: TrapData = null

    for trap in opponent_traps:
        if trap.id == 688:
            bad_reaction_trap = trap
            break

    if bad_reaction_trap:

        print("Bad Reaction to Simochi: Ativada! Convertendo +%d LP em -%d LP!" % [amount, amount])


        if is_player_healed:
            player_lp -= amount
        else:
            enemy_lp -= amount


        is_processing_trap = true


        if bad_reaction_trap.owner.is_player_slot:
            reveal_player_card_in_slot(bad_reaction_trap.owner)
        else:
            reveal_enemy_card_in_slot(bad_reaction_trap.owner)


        var card_visual = bad_reaction_trap.owner.spawn_point.get_child(0) if bad_reaction_trap.owner.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await _apply_magic_activation_glow(card_visual)

        await get_tree().create_timer(0.5).timeout


        TrapManager.remove_trap(bad_reaction_trap, null, null)
        _destroy_card(bad_reaction_trap.owner)


        EventBus.trap_consumed.emit(bad_reaction_trap, null, null)

        await get_tree().create_timer(0.2).timeout
        is_processing_trap = false
    else:

        if is_player_healed:
            player_lp += amount
        else:
            enemy_lp += amount

    update_lp_ui()
    check_game_over()

func animate_lp_change(label: Label, new_value: int):

    if new_value < 0:
        new_value = 0


    if label == player_lp_label:
        if new_value == _last_animate_lp_target_player:
            return


        var start_value = _last_logical_player_lp if _last_logical_player_lp >= 0 else 10000
        if new_value == start_value:
            return

        var diff = new_value - start_value
        if enable_lp_floating_text:
            _show_floating_lp_text(label, diff)
            _last_logical_player_lp = new_value
            _last_animate_lp_target_player = new_value

        var current_text_val = label.text.to_int()
        var tween = create_tween()
        tween.set_trans(Tween.TRANS_QUART)
        tween.set_ease(Tween.EASE_OUT)
        tween.tween_method(_update_label_text.bind(label), current_text_val, new_value, 1.5)

        if enable_lp_floating_text:
            var flash_color = Color(1.0, 0.196, 0.196, 1.0) if new_value < start_value else Color(0.196, 1.0, 0.196, 1.0)
            label.modulate = flash_color
            create_tween().tween_property(label, "modulate", Color.WHITE, 1.5)

    elif label == enemy_lp_label:
        if new_value == _last_animate_lp_target_enemy:
            return


        var start_value = _last_logical_enemy_lp if _last_logical_enemy_lp >= 0 else 10000
        if new_value == start_value:
            return

        var diff = new_value - start_value
        if enable_lp_floating_text:
            _show_floating_lp_text(label, diff)
            _last_logical_enemy_lp = new_value
            _last_animate_lp_target_enemy = new_value

        var current_text_val = label.text.to_int()
        var tween = create_tween()
        tween.set_trans(Tween.TRANS_QUART)
        tween.set_ease(Tween.EASE_OUT)
        tween.tween_method(_update_label_text.bind(label), current_text_val, new_value, 1.5)

        if enable_lp_floating_text:
            var flash_color = Color(1.0, 0.196, 0.196, 1.0) if new_value < start_value else Color(0.196, 1.0, 0.196, 1.0)
            label.modulate = flash_color
            create_tween().tween_property(label, "modulate", Color.WHITE, 1.5)

func _show_floating_lp_text(target_label: Label, amount: int):

    var floating_label = Label.new()


    var font = load("res://assets/fonts/BebasNeue-Regular.ttf")
    if font:

        var font_variation = FontVariation.new()
        font_variation.set_base_font(font)
        font_variation.set_spacing(TextServer.SPACING_GLYPH, 7)
        floating_label.add_theme_font_override("font", font_variation)

    floating_label.add_theme_font_size_override("font_size", 110)


    floating_label.add_theme_constant_override("outline_size", 7)
    floating_label.add_theme_color_override("font_outline_color", Color.WHITE)


    var text_color = Color.WHITE

    if amount > 0:
        floating_label.text = "+%d" % amount
        text_color = Color(0.196, 1.0, 0.196, 1.0)
        _play_gainlp_sound()
    else:
        floating_label.text = "%d" % amount
        text_color = Color(1.0, 0.196, 0.196, 1.0)
        _play_damage_sound()

    floating_label.add_theme_color_override("font_color", text_color)

    floating_label.z_index = 5


    $CanvasLayer.add_child(floating_label)


    var start_pos = Vector2.ZERO

    if target_label == player_lp_label:

        start_pos = Vector2(1200, 780)
    elif target_label == enemy_lp_label:

        start_pos = Vector2(1200, 300)
    else:

        start_pos = target_label.global_position + Vector2(0, 50)

    floating_label.position = start_pos - (floating_label.size / 2)
    floating_label.position -= Vector2(50, 25)


    var tween = create_tween()


    floating_label.modulate.a = 0.0
    floating_label.scale = Vector2(0.5, 0.5)
    floating_label.pivot_offset = floating_label.size / 2


    tween.set_parallel(true)
    tween.tween_property(floating_label, "modulate:a", 1.0, 0.1)
    tween.tween_property(floating_label, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


    tween.chain().tween_interval(0.3)
    tween.chain().tween_property(floating_label, "modulate:a", 0.0, 0.2)


    tween.chain().tween_callback(floating_label.queue_free)

func _update_label_text(current_interpolated_value: int, label: Label):
    label.text = str(current_interpolated_value)

func update_names_ui():

    if has_node("/root/Global"):
        current_player_name = get_node("/root/Global").player_name

    if player_name_label.has_method("set_text_auto"):
        player_name_label.set_text_auto(current_player_name)
    else:
        player_name_label.text = current_player_name

func update_deck_ui():
    $CanvasLayer / PlayerDeckLabel.text = "%d" % player_deck_pile.size()
    $CanvasLayer / EnemyDeckLabel.text = "%d" % enemy_deck_pile.size()


func build_decks_and_setup_match():
    _build_player_deck()
    _build_enemy_deck()
    _setup_visuals()

func _build_player_deck():
    player_deck_pile.clear()


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if global.player_deck and global.player_deck.size() > 0:
            print("Usando deck do Global: ", global.player_deck.size(), " cartas")
            for id in global.player_deck:
                var card_obj = CardDatabase.get_card(id)
                if card_obj:
                    player_deck_pile.append(card_obj.get_copy() if card_obj.has_method("get_copy") else card_obj)
            player_deck_pile.shuffle()
            return


    print("Usando deck do PlayerDeck (fallback)")
    for id in PlayerDeck.get_deck():
        var card_obj = CardDatabase.get_card(id)
        if card_obj:
            player_deck_pile.append(card_obj.get_copy() if card_obj.has_method("get_copy") else card_obj)
    player_deck_pile.shuffle()

func _build_enemy_deck():
    enemy_deck_pile.clear()
    enemy_turn_counter = 0
    current_enemy_difficulty = "Easy"


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if global.next_enemy_deck_key != "":
            selected_enemy_deck_key = global.next_enemy_deck_key
            global.next_enemy_deck_key = ""
            print("Enemy selected from Global: ", selected_enemy_deck_key)


    if not selected_enemy_deck_key or selected_enemy_deck_key == "":
        selected_enemy_deck_key = enemy_name_label.text if enemy_name_label.text != "Enemy Name" else "Simon Muran"

    var match_data = EnemyDeckDatabase.get_match_profile(selected_enemy_deck_key)

    if not match_data or not match_data.has("deck"):
        push_error("Deck do inimigo não encontrado: " + str(selected_enemy_deck_key))
        _create_fallback_deck()
        return


    if match_data.has("difficulty"):
        current_enemy_difficulty = match_data["difficulty"]


    for card in match_data["deck"]:
        if card:
            enemy_deck_pile.append(card.get_copy() if card.has_method("get_copy") else card)

    enemy_deck_pile.shuffle()
    print("Dificuldade IA: ", current_enemy_difficulty)

func _create_fallback_deck():
    for i in range(40):
        var fallback = CardDatabase.get_card(1)
        if fallback and fallback.has_method("get_copy"):
            enemy_deck_pile.append(fallback.get_copy())

func _setup_visuals():
    var match_data = EnemyDeckDatabase.get_match_profile(selected_enemy_deck_key)
    var enemy_name = match_data.get("name", "Unknown") if match_data else "Unknown"

    if enemy_name_label.has_method("set_text_auto"):
        enemy_name_label.set_text_auto(enemy_name)
    else:
        enemy_name_label.text = enemy_name

    load_enemy_portrait(selected_enemy_deck_key)
    player_deck_visual.setup_deck(player_deck_pile.size())
    enemy_deck_visual.setup_deck(enemy_deck_pile.size())


    if enemy_ai:
        enemy_ai.setup(enemy_hand, enemy_slots, player_slots, enemy_spell_slots)
        enemy_ai.set_difficulty(current_enemy_difficulty)

func load_enemy_portrait(enemy_key: String):
    if not enemy_portrait: return

    var path = "res://assets/portraits/%s.png" % enemy_key
    if ResourceLoader.exists(path):
        enemy_portrait.texture = load(path)

func discard_random_card_from_opponent_deck(opponent_is_player: bool, source_name: String = "Efeito ativado"):
    print("%s - Descarta carta aleatória do deck do oponente" % source_name)

    if opponent_is_player:

        var player_deck_size = player_deck_pile.size()

        if player_deck_size > 0:

            var random_index = randi() % player_deck_size
            var card_to_discard = player_deck_pile[random_index]

            print("Descartando do deck do jogador: ", card_to_discard.name)


            player_deck_pile.remove_at(random_index)


            send_to_graveyard(card_to_discard, true, true)


            update_deck_ui()
        else:
            print("Deck do jogador vazio, não há cartas para descartar")
    else:

        var enemy_deck_size = enemy_deck_pile.size()

        if enemy_deck_size > 0:

            var random_index = randi() % enemy_deck_size
            var card_to_discard = enemy_deck_pile[random_index]

            print("Descartando do deck da IA: ", card_to_discard.name)


            enemy_deck_pile.remove_at(random_index)


            send_to_graveyard(card_to_discard, false, true)


            update_deck_ui()
        else:
            print("Deck da IA vazio, não há cartas para descartar")

    print("Masked Sorcerer: Efeito concluído!")


func create_player_hand():
    player_hand.clear()
    for i in range(5):

        var new_card = draw_card_from_deck(true, false)
        if new_card:
            player_hand.append(new_card)

func create_enemy_hand():
    enemy_hand.clear()
    for i in range(5):

        var new_card = draw_card_from_deck(false, false)
        if new_card:
            enemy_hand.append(new_card)

func draw_card_from_deck(is_player: bool, play_sound: bool = true) -> CardData:
    var deck = player_deck_pile if is_player else enemy_deck_pile
    var visual = player_deck_visual if is_player else enemy_deck_visual

    if deck.size() <= 0:
        handle_deck_out(is_player)
        return null

    if play_sound:
        _play_carddraw_sound()
    var card = deck.pop_back()
    visual.remove_top_card()
    update_deck_ui()
    return card

func handle_deck_out(is_player: bool):
    if is_player:
        game_over_loss("You ran out of cards!")
    else:
        game_over_win("Enemy ran out of cards!")

func refill_player_hand():
    if game_over: return


    var cards_to_refill = []
    for i in range(player_hand.size()):
        if player_hand[i] == null:
            cards_to_refill.append(i)

    if cards_to_refill.is_empty():
        return


    for i in cards_to_refill:

        var new_card = draw_card_from_deck(true, false)
        if new_card:
            player_hand[i] = new_card
        else:
            break


    if not cards_to_refill.is_empty():

        await update_hand_ui_with_animation(cards_to_refill)

    if game_over:
        return

    _is_processing_action = true
    EffectManager.check_hand_effects(true, player_hand)
    _is_processing_action = false

func refill_enemy_hand():
    if game_over: return


    var cards_to_refill = []
    for i in range(enemy_hand.size()):
        if enemy_hand[i] == null:
            cards_to_refill.append(i)

    if cards_to_refill.is_empty():
        return


    for i in cards_to_refill:

        var new_card = draw_card_from_deck(false, false)
        if new_card:
            enemy_hand[i] = new_card
        else:
            break


    if not cards_to_refill.is_empty():
        await update_enemy_hand_ui_with_animation(cards_to_refill)

    if game_over:
        return

    _is_processing_action = true
    EffectManager.check_hand_effects(false, enemy_hand)
    _is_processing_action = false

func update_enemy_hand_ui_with_animation(card_indices_to_animate: Array):

    update_enemy_hand_ui()


    await get_tree().process_frame


    if not is_instance_valid(self) or not is_inside_tree():
        return


    var cards_to_animate = []

    for index in card_indices_to_animate:
        var wrappers = $EnemyArea / EnemyHand.get_children()
        if index < wrappers.size():
            var wrapper = wrappers[index]
            if wrapper and is_instance_valid(wrapper) and wrapper.get_child_count() > 0:
                var card_back = wrapper.get_child(0)
                if card_back and is_instance_valid(card_back):

                    var original_position = card_back.position
                    cards_to_animate.append({
                        "card_back": card_back, 
                        "original_position": original_position, 
                        "index": index
                    })


    for i in range(cards_to_animate.size()):
        var card_data = cards_to_animate[i]
        var card_back = card_data["card_back"]


        if card_back and is_instance_valid(card_back) and card_back.is_inside_tree():

            await _animate_single_enemy_card(card_back, card_data["original_position"], i * 0.1)

func _animate_single_enemy_card(card_back: Node, original_position: Vector2, delay: float):

    if not card_back or not is_instance_valid(card_back) or not card_back.is_inside_tree():
        return


    var original_modulate = card_back.modulate


    card_back.position.x = original_position.x - 300
    card_back.modulate.a = 0.0


    if delay > 0:
        await get_tree().create_timer(delay).timeout

    _play_carddraw_sound(0.0, true)


    if not is_instance_valid(card_back) or not card_back.is_inside_tree():
        return


    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)

    tween.tween_property(card_back, "position", original_position, 0.3)
    tween.tween_property(card_back, "modulate:a", 1.0, 0.2)

    await tween.finished

func update_hand_ui_with_animation(card_indices_to_animate: Array):

    _clear_hand_container($PlayerArea / Hand)

    var original_size = Vector2(364, 530)
    var target_size = Vector2(181, 263)
    var scale_factor = target_size / original_size


    var new_cards_to_animate = []


    for i in range(player_hand.size()):
        if player_hand[i]:
            var wrapper = Control.new()
            wrapper.custom_minimum_size = target_size
            $PlayerArea / Hand.add_child(wrapper)

            var card_instance = card_visual_scene.instantiate()
            wrapper.add_child(card_instance)
            card_instance.scale = scale_factor
            card_instance.mouse_filter = Control.MOUSE_FILTER_STOP
            card_instance.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

            card_instance.set_card_data(player_hand[i], i, false)
            card_instance.hovered.connect(_on_card_hover_update)
            card_instance.unhovered.connect(_on_card_hover_exit)

            if not card_instance.card_selected.is_connected(_on_card_visual_clicked):
                card_instance.card_selected.connect(_on_card_visual_clicked)

            card_instance.update_selection_visual(get_selection_order(i))


            if i in card_indices_to_animate:

                card_instance.modulate.a = 0.0
                new_cards_to_animate.append({
                    "instance": card_instance, 
                    "wrapper": wrapper, 
                    "index": i
                })
            else:

                card_instance.modulate.a = 1.0


    await get_tree().process_frame


    if not is_instance_valid(self) or not is_inside_tree():
        return


    for i in range(new_cards_to_animate.size()):
        var card_data = new_cards_to_animate[i]
        var card_instance = card_data["instance"]
        var wrapper = card_data["wrapper"]

        if card_instance and is_instance_valid(card_instance) and card_instance.is_inside_tree():
            await _animate_single_card(card_instance, wrapper, i * 0.1)

func _animate_single_card(card_instance: Node, wrapper: Node, delay: float):

    if not card_instance or not is_instance_valid(card_instance) or not card_instance.is_inside_tree():
        return


    var final_position = Vector2.ZERO


    var start_offset = 300
    card_instance.position.x = start_offset
    card_instance.modulate.a = 0.0


    if delay > 0:
        await get_tree().create_timer(delay).timeout

    _play_carddraw_sound(0.0, true)


    if not is_instance_valid(card_instance) or not card_instance.is_inside_tree():
        return



    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_BACK)
    tween.set_ease(Tween.EASE_OUT)


    tween.tween_property(card_instance, "position:x", final_position.x, 0.4)


    tween.tween_property(card_instance, "modulate:a", 1.0, 0.3)





    await tween.finished

func _refill_hand(hand: Array, is_player: bool):
    for i in range(hand.size()):
        if hand[i] == null:
            var new_card = draw_card_from_deck(is_player)
            if new_card:
                hand[i] = new_card

func _count_non_null_cards(hand: Array) -> int:
    var count = 0
    for card in hand:
        if card != null:
            count += 1
    return count

func discard_random_opponent_card(opponent_is_player: bool):
    print("White Magical Hat: Efeito ativado - Descarta carta aleatória da mão do oponente")

    if opponent_is_player:

        var player_hand_size = _count_non_null_cards(player_hand)

        if player_hand_size > 0:

            var valid_indices = []

            for i in range(player_hand.size()):
                if player_hand[i] != null:
                    valid_indices.append(i)

            if valid_indices.size() > 0:
                var random_index = valid_indices[randi() % valid_indices.size()]
                var card_to_discard = player_hand[random_index]

                print("Descartando carta do jogador: ", card_to_discard.name)


                player_hand[random_index] = null


                send_to_graveyard(card_to_discard, true, true)


                update_hand_ui()
            else:
                print("Jogador não tem cartas na mão para descartar")
    else:

        var enemy_hand_size = _count_non_null_cards(enemy_hand)

        if enemy_hand_size > 0:

            var valid_indices = []

            for i in range(enemy_hand.size()):
                if enemy_hand[i] != null:
                    valid_indices.append(i)

            if valid_indices.size() > 0:
                var random_index = valid_indices[randi() % valid_indices.size()]
                var card_to_discard = enemy_hand[random_index]

                print("Descartando carta da IA: ", card_to_discard.name)


                enemy_hand[random_index] = null


                send_to_graveyard(card_to_discard, false, true)


                update_enemy_hand_ui()
            else:
                print("IA não tem cartas na mão para descartar")

    print("Efeito do White Magical Hat concluído")


func update_hand_ui():
    _clear_hand_container($PlayerArea / Hand)

    var original_size = Vector2(364, 530)
    var target_size = Vector2(181, 263)
    var scale_factor = target_size / original_size

    for i in range(player_hand.size()):
        if player_hand[i]:
            _create_hand_card(player_hand[i], i, $PlayerArea / Hand, scale_factor, target_size)

func update_hand_ui_animated(is_initial_draw: bool = false):

    if not is_initial_draw:
        update_hand_ui()
        return


    _clear_hand_container($PlayerArea / Hand)

    var original_size = Vector2(364, 530)
    var target_size = Vector2(181, 263)
    var scale_factor = target_size / original_size


    var cards_to_animate = []

    for i in range(player_hand.size()):
        if player_hand[i]:
            var card_instance = _create_hand_card_invisible(player_hand[i], i, $PlayerArea / Hand, scale_factor, target_size)
            if card_instance:
                cards_to_animate.append(card_instance)


    await get_tree().process_frame

    if not is_instance_valid(self) or not is_inside_tree():
        return



    for i in range(cards_to_animate.size()):
        var card = cards_to_animate[i]
        if card and is_instance_valid(card) and card.is_inside_tree():


            await _animate_card_draw(card, 0.0, true)

func _create_hand_card_invisible(card_data: CardData, index: int, container: Node, scale: Vector2, size: Vector2) -> Node:
    var wrapper = Control.new()
    wrapper.custom_minimum_size = size
    container.add_child(wrapper)

    var card_instance = card_visual_scene.instantiate()
    wrapper.add_child(card_instance)
    card_instance.scale = scale
    card_instance.mouse_filter = Control.MOUSE_FILTER_STOP
    card_instance.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

    card_instance.set_card_data(card_data, index, false)
    card_instance.hovered.connect(_on_card_hover_update)
    card_instance.unhovered.connect(_on_card_hover_exit)

    if not card_instance.card_selected.is_connected(_on_card_visual_clicked):
        card_instance.card_selected.connect(_on_card_visual_clicked)

    card_instance.update_selection_visual(get_selection_order(index))



    card_instance.modulate.a = 0.0
    card_instance.visible = true

    return card_instance

func _animate_card_draw(card: Node, delay: float, is_player: bool):

    if not is_instance_valid(card) or not card.is_inside_tree():
        return


    var final_position = card.position


    var viewport_width = get_viewport().get_visible_rect().size.x
    card.position.x = viewport_width

    await get_tree().create_timer(delay).timeout


    if not is_instance_valid(card) or not card.is_inside_tree():
        return



    if is_player:
        var sound_tween = create_tween()
        sound_tween.tween_interval(0.05)
        sound_tween.tween_callback( func(): _play_carddraw_sound(0.0, true))

    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.set_ease(Tween.EASE_OUT)



    var distance = abs(card.position.x - final_position.x)
    var speed = 3000.0
    var dynamic_duration = clamp(distance / speed, 0.15, 0.3)


    tween.tween_property(card, "position", final_position, dynamic_duration)


    tween.tween_property(card, "modulate:a", 1.0, dynamic_duration * 0.8)


    await tween.finished

func _clear_hand_container(container: Node):
    for child in container.get_children():
        child.queue_free()

func _create_hand_card(card_data: CardData, index: int, container: Node, scale: Vector2, size: Vector2):
    var wrapper = Control.new()
    wrapper.custom_minimum_size = size
    container.add_child(wrapper)

    var card_instance = card_visual_scene.instantiate()
    wrapper.add_child(card_instance)
    card_instance.scale = scale
    card_instance.mouse_filter = Control.MOUSE_FILTER_STOP
    card_instance.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

    card_instance.set_card_data(card_data, index, false)
    card_instance.hovered.connect(_on_card_hover_update)
    card_instance.unhovered.connect(_on_card_hover_exit)

    if not card_instance.card_selected.is_connected(_on_card_visual_clicked):
        card_instance.card_selected.connect(_on_card_visual_clicked)

    card_instance.update_selection_visual(get_selection_order(index))

func update_enemy_hand_ui():
    if not has_node("EnemyArea/EnemyHand"): return

    _clear_hand_container($EnemyArea / EnemyHand)

    var scale_factor = Vector2(181, 263) / Vector2(364, 530)

    for i in range(enemy_hand.size()):
        if enemy_hand[i]:
            _create_enemy_card_back_with_index($EnemyArea / EnemyHand, scale_factor, i)

func _create_enemy_card_back_with_index(container: Node, scale: Vector2, index: int):
    var wrapper = Control.new()
    wrapper.custom_minimum_size = Vector2(181, 263)
    wrapper.name = "EnemyCard_" + str(index)
    container.add_child(wrapper)

    var card_back = TextureRect.new()
    card_back.texture = CARD_BACK_TEXTURE
    card_back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    card_back.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    card_back.size = Vector2(364, 530)
    card_back.scale = scale
    card_back.rotation_degrees = 180
    wrapper.add_child(card_back)

    return card_back

func update_enemy_hand_ui_animated(is_initial_draw: bool = false):
    if not has_node("EnemyArea/EnemyHand"):
        return


    if not is_initial_draw:
        update_enemy_hand_ui()
        return

    _clear_hand_container($EnemyArea / EnemyHand)

    var scale_factor = Vector2(181, 263) / Vector2(364, 530)
    var cards_to_animate = []

    for card in enemy_hand:
        if card:
            var card_back = _create_enemy_card_back_invisible($EnemyArea / EnemyHand, scale_factor)
            if card_back:
                cards_to_animate.append(card_back)


    await get_tree().process_frame


    if not is_instance_valid(self) or not is_inside_tree():
        return


    for i in range(cards_to_animate.size()):
        var card = cards_to_animate[i]
        if card and is_instance_valid(card) and card.is_inside_tree():
            _animate_card_draw_enemy(card, i * CARD_DRAW_STAGGER)

func _create_enemy_card_back(container: Node, scale: Vector2):
    var wrapper = Control.new()
    wrapper.custom_minimum_size = Vector2(181, 263)
    container.add_child(wrapper)

    var card_back = TextureRect.new()
    card_back.texture = CARD_BACK_TEXTURE
    card_back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    card_back.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    card_back.size = Vector2(364, 530)
    card_back.scale = scale
    card_back.rotation_degrees = 180
    wrapper.add_child(card_back)

    return card_back

func _create_enemy_card_back_invisible(container: Node, scale: Vector2) -> Node:
    var wrapper = Control.new()
    wrapper.custom_minimum_size = Vector2(181, 263)
    container.add_child(wrapper)

    var card_back = TextureRect.new()
    card_back.texture = CARD_BACK_TEXTURE
    card_back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    card_back.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    card_back.size = Vector2(364, 530)
    card_back.scale = scale
    card_back.rotation_degrees = 180
    wrapper.add_child(card_back)



    card_back.modulate.a = 0.0

    return card_back

func _animate_card_draw_enemy(card: Node, delay: float):

    if not is_instance_valid(card) or not card.is_inside_tree():
        return


    var final_position = card.position


    card.position.x = -500

    await get_tree().create_timer(delay).timeout


    if not is_instance_valid(card) or not card.is_inside_tree():
        return

    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.set_ease(Tween.EASE_OUT)


    tween.tween_property(card, "position", final_position, CARD_DRAW_DURATION)


    tween.tween_property(card, "modulate:a", 1.0, CARD_DRAW_DURATION * 0.5)


func select_card(index: int):
    if game_over or player_has_played or current_phase != TurnPhase.PLAYER:
        return


    for entry in selected_cards:
        if entry.index == index:
            selected_cards.erase(entry)
            update_hand_ui()


            if current_game_state == GameState.EQUIP_TARGETING:
                _cancel_equip_targeting()
            elif current_game_state == GameState.STOP_DEFENSE_TARGETING:
                _cancel_stop_defense_targeting()

            return


    if selected_cards.size() >= 5:
        return

    selected_cards.append({"index": index, "card": player_hand[index]})

    if selected_cards.size() > 0:
        show_battle_buttons()
    else:
        hide_battle_buttons()

    update_hand_ui()

func get_selection_order(hand_index: int) -> int:
    for k in range(selected_cards.size()):
        if selected_cards[k].index == hand_index:
            return k + 1
    return 0

func is_card_selected(index: int) -> bool:
    for entry in selected_cards:
        if entry.index == index:
            return true
    return false

func _on_card_visual_clicked(visual_card):
    if _is_processing_action or is_processing_trap: return


    hide_all_card_buttons()


    select_card(visual_card.hand_index)


func show_battle_buttons():
    if selected_cards.size() == 0:
        hide_battle_buttons()
        return

    var card = selected_cards[0].card
    var is_monster = _is_monster(card)

    var btn_1 = $CanvasLayer / AtkButton
    var btn_2 = $CanvasLayer / DefButton




    btn_1.visible = true
    btn_2.visible = true
    btn_1.disabled = false


    if is_monster:
        btn_1.texture_normal = BTN_TEX_ATTACK
        btn_2.texture_normal = BTN_TEX_DEFENSE


    elif card.category == CardData.CardCategory.MAGIC:
        btn_1.texture_normal = BTN_TEX_ACTIVATE
        btn_2.texture_normal = BTN_TEX_SET

    elif card.category == CardData.CardCategory.TRAP:
        btn_1.texture_normal = BTN_TEX_ACTIVATE
        btn_2.texture_normal = BTN_TEX_SET

    btn_1.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    btn_2.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func hide_battle_buttons():
    var atk_btn = $CanvasLayer / AtkButton
    var def_btn = $CanvasLayer / DefButton




    atk_btn.visible = false
    def_btn.visible = false



    atk_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    def_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND




func _on_atk_button_pressed():
    player_position = "Attack"
    _play_confirm_sound()
    play_selected_cards()

func _on_def_button_pressed():
    player_position = "Defense"
    _play_confirm_sound()
    play_selected_cards()


func spawn_card_on_field(card_data: CardData, slot_node: Node, is_defense: bool, is_player_owner: bool, is_fusion: bool = false, force_face_up: bool = false):
    var target_marker = slot_node.spawn_point


    for child in target_marker.get_children():
        child.queue_free()

    var card_instance = card_visual_scene.instantiate()
    target_marker.add_child(card_instance)


    var original_size = Vector2(364, 530)
    card_instance.size = original_size
    card_instance.pivot_offset = original_size / 2


    var final_scale = FIELD_SCALE



    var start_scale = FIELD_SCALE * 1.5
    var start_pos_offset = Vector2(0, 2000) if is_player_owner else Vector2(0, -2000)

    var should_animate_from_hand = (turn_number >= 1)

    if should_animate_from_hand:
        card_instance.scale = start_scale
        card_instance.position = ( - original_size / 2) + start_pos_offset

    else:
        card_instance.scale = final_scale
        card_instance.position = - original_size / 2



    var should_be_face_down = false
    var target_rotation = 0.0

    if is_player_owner:

        if _is_monster(card_data):

            target_rotation = 90 if is_defense else 0
            should_be_face_down = is_defense and not force_face_up
        else:

            target_rotation = 0
            should_be_face_down = is_defense and not force_face_up
    else:

        if _is_monster(card_data):

            target_rotation = -90 if is_defense else 180
            should_be_face_down = is_defense and not force_face_up
        else:

            target_rotation = 180
            should_be_face_down = (is_defense or card_data.category == CardData.CardCategory.TRAP) and not force_face_up

    card_instance.rotation_degrees = target_rotation
    card_instance.set_owner_is_player(is_player_owner)
    card_instance.mouse_filter = Control.MOUSE_FILTER_STOP


    _connect_card_signals(card_instance, slot_node, is_player_owner)

    card_instance.set_card_data(card_data, -1, is_fusion)
    card_instance.set_face_down(should_be_face_down)


    if should_animate_from_hand:
        var tween = create_tween()
        tween.set_parallel(true)
        tween.set_trans(Tween.TRANS_QUART)
        tween.set_ease(Tween.EASE_OUT)


        var final_pos = - original_size / 2

        tween.tween_property(card_instance, "position", final_pos, 0.4)
        tween.tween_property(card_instance, "scale", final_scale, 0.4)


    await get_tree().create_timer(0.4).timeout
    _play_spawncard_sound()


    if _is_monster(card_data):
        _apply_field_bonus_to_card(card_data, is_player_owner)


    slot_node.stored_card_data = card_data
    slot_node.is_occupied = true
    if "stored_card_visual" in slot_node:
        slot_node.stored_card_visual = card_instance
    if card_data.category == CardData.CardCategory.TRAP:
        card_instance.is_face_down = true


    EffectManager.update_battleguards_bonus(is_player_owner)


    if not should_be_face_down:

        if _is_monster(card_data):
            if should_animate_from_hand:
                await get_tree().create_timer(0.4).timeout

            play_summon_animation(card_instance)

        var field_bonus = EffectManager.get_field_bonus(card_data, current_field_type)
        if field_bonus.atk != 0 or field_bonus.def != 0:
            card_instance.animate_stats_bonus(card_data.atk, card_data.def, -1, -1, 0.5)

    _try_add_trap(card_data, slot_node)


    if _is_monster(card_data) and not should_be_face_down:



        if TrapManager.has_method("check_summon_negation") and await TrapManager.check_summon_negation(card_data, is_player_owner):
            print("DuelManager: Invocação do monstro ", card_data.name, " foi NEGADA!")


            await get_tree().create_timer(1.0).timeout
            _destroy_card(slot_node)
            return card_instance


        is_processing_trap = true

        if TrapManager.has_method("_on_monster_summoned"):
            await TrapManager._on_monster_summoned(slot_node, card_data, is_player_owner)
        is_processing_trap = false


    if is_defense and not force_face_up:
        var slot_owner_is_player = false


        if "is_player_slot" in slot_node:
            slot_owner_is_player = slot_node.is_player_slot
        else:

            if slot_node in player_slots:
                slot_owner_is_player = true
            elif slot_node in enemy_slots:
                slot_owner_is_player = false






        if EffectManager.swords_of_revealing_light_active:

            var swords_owner_is_player = EffectManager.swords_of_revealing_light_owner_is_player


            var swords_target_is_player = not swords_owner_is_player


            if slot_owner_is_player == swords_target_is_player:
                print("Swords ativa: Slot do ", "Jogador" if slot_owner_is_player else "Inimigo", 
                    " não pode face-down (Swords ativada por ", 
                    "Jogador" if swords_owner_is_player else "Inimigo", ")")
                force_face_up = true



    if card_data and _is_monster(card_data):

        var is_player_card = slot_node.is_player_slot if "is_player_slot" in slot_node else false


        if card_data in elegant_egotist_equipped_monsters:
            print("Harpy Lady com Elegant Egotist entrou em campo! Criando cópias...")
            elegant_egotist_equipped_monsters.erase(card_data)
            await _create_harpy_lady_copies(card_data, is_player_card)

        await get_tree().create_timer(0.5).timeout


        if not slot_node.is_occupied or slot_node.stored_card_data != card_data:
            print("DuelManager: Monstro ", card_data.name, " não está mais no campo (provavelmente destruído por Trap). Efeito cancelado.")
            _is_processing_action = false
            return card_instance


        _is_processing_action = true
        await EffectManager.apply_monster_effect_on_summon(card_data, is_player_card, slot_node)
        _is_processing_action = false

    return card_instance


func _try_add_trap(card_data: CardData, slot_node: Node) -> void :
    if card_data.category != CardData.CardCategory.TRAP:
        return

    var trap = TrapDatabase.create(card_data.id)
    if not trap:
        push_error("Falha ao criar Trap: ID inválido ", card_data.id)
        return

    trap.owner = slot_node

    TrapManager.add_trap(trap)


func can_place_card_face_down(slot_owner_is_player: bool) -> bool:

    if EffectManager.swords_of_revealing_light_active:
        var is_target = (slot_owner_is_player == not EffectManager.swords_of_revealing_light_owner_is_player)
        if is_target:
            print("Swords of Revealing Light impede cartas face-down")
            return false

    return true

func _calculate_card_rotation(is_player: bool, is_defense: bool) -> float:
    if is_player:
        return 90 if is_defense else 0
    else:
        return -90 if is_defense else 180

func _connect_card_signals(card_instance, slot_node, is_player: bool):
    card_instance.duel_manager = self
    if not card_instance.hovered.is_connected(_on_card_hover_update):
        card_instance.hovered.connect(_on_card_hover_update)
    if not card_instance.unhovered.is_connected(_on_card_hover_exit):
        card_instance.unhovered.connect(_on_card_hover_exit)

    if is_player:
        if not card_instance.attack_requested.is_connected(_on_card_attack_requested):
            card_instance.attack_requested.connect(_on_card_attack_requested.bind(slot_node))
        if not card_instance.change_position_requested.is_connected(_on_card_position_change_requested):
            card_instance.change_position_requested.connect(_on_card_position_change_requested.bind(slot_node))
        if not card_instance.card_selected.is_connected(_on_player_field_card_clicked):
            card_instance.card_selected.connect(_on_player_field_card_clicked.bind(slot_node))
        if not card_instance.activate_requested.is_connected(_on_card_activate_requested):
            card_instance.activate_requested.connect(_on_card_activate_requested.bind(slot_node))
    else:
        if not card_instance.card_selected.is_connected(_on_enemy_card_visual_clicked):
            card_instance.card_selected.connect(_on_enemy_card_visual_clicked.bind(slot_node))


func _on_card_hover_update(card_visual):
    if card_visual == null:
        if card_inspector.has_method("clear_info"):
            card_inspector.clear_info()
        return

    current_hovered_card = card_visual
    var should_hide = ( not card_visual.is_player_card) and card_visual.is_face_down

    if should_hide:
        if card_inspector.has_method("clear_info"):
            card_inspector.clear_info()
    else:
        if card_inspector.has_method("set_card_data"):
            card_inspector.set_card_data(card_visual.my_card_data)
        elif card_inspector.has_method("update_inspector"):
            card_inspector.update_inspector(card_visual, false)

func _on_card_hover_exit(card_visual):
    if current_hovered_card != card_visual:
        return
    current_hovered_card = null
    card_inspector.update_inspector(null, true)


func _on_player_field_card_clicked(card_visual, slot_node):
    if _is_processing_action or is_processing_trap: return

    click_was_on_card = true



    if is_selecting_slot or current_game_state == GameState.EQUIP_TARGETING:
        _on_player_slot_clicked(slot_node)

func hide_all_card_buttons():
    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual and card_visual.has_method("hide_action_buttons"):
                card_visual.hide_action_buttons()
            if card_visual.has_method("reset_selection_visual"):
                    card_visual.reset_selection_visual()

    for slot in player_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("hide_action_buttons"):
                card_visual.hide_action_buttons()
            if card_visual.has_method("reset_selection_visual"):
                    card_visual.reset_selection_visual()


    for slot in player_spell_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("hide_action_buttons"):
                card_visual.hide_action_buttons()
            if card_visual.has_method("reset_selection_visual"):
                    card_visual.reset_selection_visual()

    last_card_with_buttons = null

func _on_enemy_card_visual_clicked(card_visual, slot_node):
    if _is_processing_action or is_processing_trap: return

    print("_on_enemy_card_visual_clicked - Estado: ", current_game_state)


    if current_game_state == GameState.STOP_DEFENSE_TARGETING:
        print("Stop Defense targeting: carta inimiga clicada")

        if not pending_stop_defense_target_player:
            print("Processando Stop Defense em carta inimiga")
            _handle_stop_defense_target_selection(slot_node)
        else:
            print("Stop Defense alvo é jogador, não inimigo")
        return


    if current_game_state == GameState.BATTLE_TARGETING:
        print("Battle targeting: selecionando alvo para ataque")
        _on_enemy_slot_clicked(slot_node)
        return

    print("Clique em carta inimiga sem modo ativo")

func _on_card_position_change_requested(card_visual, slot_node):
    if _is_processing_action or is_processing_trap: return
    if not slot_node.is_player_slot or current_turn != Turn.PLAYER: return
    if current_phase != TurnPhase.PLAYER or not player_has_played: return
    if slot_node.has_attacked_this_turn: return


    _play_confirm_sound()
    var target_rotation = 0 if card_visual.rotation_degrees == 90 else 90
    _play_cardrotation_sound()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(card_visual, "rotation_degrees", target_rotation, 0.2)

func _on_card_attack_requested(card_visual, slot_node):
    if _is_processing_action or is_processing_trap: return
    if not slot_node.is_player_slot or current_turn != Turn.PLAYER: return
    if current_phase != TurnPhase.PLAYER or not player_has_played: return
    if (turn_number == 1 and current_turn == Turn.PLAYER) or slot_node.has_attacked_this_turn: return

    _play_confirm_sound()

    if current_game_state == GameState.BATTLE_TARGETING:
        if attacker_slot_ref == slot_node:
            cancel_attack_targeting()
            return
        else:
            cancel_attack_targeting()


    var attacker_card = slot_node.stored_card_data
    if not attacker_card:
        return


    if attacker_card.id in DIRECT_ATTACK_MONSTER_IDS:
        print("Jinzo #7: Ataque direto automático!")
        _is_processing_action = true


        if current_game_state == GameState.BATTLE_TARGETING:
            cancel_attack_targeting()


        await execute_battle(slot_node, null)

        _is_processing_action = false
        return


    var enemies_count = _count_occupied_slots(enemy_slots)
    if enemies_count == 0:
        _is_processing_action = true
        await execute_battle(slot_node, enemy_slots[0])
        cancel_attack_targeting()
        _is_processing_action = false
        return


    attacker_slot_ref = slot_node
    current_game_state = GameState.BATTLE_TARGETING


    if card_visual.has_method("apply_attack_glow"):
        card_visual.apply_attack_glow()
    else:

        card_visual.modulate = Color(1.5, 1.5, 1.5)

    _highlight_enemy_targets(slot_node.stored_card_data)

func _count_occupied_slots(slots: Array) -> int:
    var count = 0
    for s in slots:
        if s.is_occupied: count += 1
    return count

func _highlight_enemy_targets(attacker_card: CardData):
    for e_slot in enemy_slots:
        e_slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

        if e_slot.is_occupied:
            var defender_card = e_slot.stored_card_data
            var target_visual = e_slot.spawn_point.get_child(0)

            if target_visual:
                target_visual.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


            var player_advantage = get_guardian_bonus(attacker_card, defender_card) > 0
            var enemy_advantage = get_guardian_bonus(defender_card, attacker_card) > 0

            var target_color = Color.WHITE
            if player_advantage:
                target_color = Color(1.2, 1.2, 0)
            elif enemy_advantage:
                target_color = Color(1, 0.4, 0.4)

            e_slot.modulate = target_color
            if target_visual:
                target_visual.modulate = target_color


    for spell_slot in enemy_spell_slots:
        spell_slot.mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_enemy_slot_clicked(enemy_slot_instance):
    if _is_processing_action or is_processing_trap: return

    print("_on_enemy_slot_clicked - Estado atual: ", current_game_state)


    if current_game_state == GameState.STOP_DEFENSE_TARGETING:
        print("Stop Defense targeting ativo")
        print("pending_stop_defense_target_player: ", pending_stop_defense_target_player)
        print("enemy_slot_instance.is_player_slot: ", enemy_slot_instance.is_player_slot)

        _play_confirm_sound()

        if not pending_stop_defense_target_player and not enemy_slot_instance.is_player_slot:
            print("Slot inimigo selecionado para Stop Defense")
            _handle_stop_defense_target_selection(enemy_slot_instance)
        else:
            print("Slot inválido para Stop Defense")
        return


    if current_game_state != GameState.BATTLE_TARGETING or attacker_slot_ref == null:
        print("Cancelando ataque - não está em modo de targeting")
        cancel_attack_targeting()
        return

    if _is_processing_action: return
    _is_processing_action = true

    print("Selecionando alvo para batalha")
    var current_attacker = attacker_slot_ref
    current_game_state = GameState.MAIN_PHASE

    if enemy_slot_instance.is_occupied or _is_enemy_field_empty():
        _play_confirm_sound()
        await execute_battle(current_attacker, enemy_slot_instance)

    cancel_attack_targeting()
    _is_processing_action = false

func _handle_stop_defense_target_selection(target_slot):
    "\n    Processa a seleção de um alvo para Stop Defense\n    "


    print("Stop Defense: Alvo selecionado - ", target_slot.stored_card_data.name)

    if not target_slot.is_occupied or target_slot.spawn_point.get_child_count() == 0:
        print("Erro: Slot vazio selecionado")
        _cancel_stop_defense_targeting()
        return

    var visual = target_slot.spawn_point.get_child(0)
    var card_data = target_slot.stored_card_data


    var is_in_defense = _is_card_in_defense_for_stop_defense(target_slot, visual, pending_stop_defense_target_player)

    if not is_in_defense:
        print("Erro: Carta não está em modo de defesa")
        _cancel_stop_defense_targeting()
        return


    if visual.has_method("set_face_down"):
        visual.set_face_down(false)


    if pending_stop_defense_target_player:

        visual.rotation_degrees = 0
        print("Stop Defense: ", card_data.name, " virado para ataque (jogador)")
    else:

        visual.rotation_degrees = 180
        print("Stop Defense: ", card_data.name, " virado para ataque (inimigo)")


    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(visual, "modulate", Color(1, 1, 1, 1), 0.3)

    await tween.finished


    if stop_defense_activation_slot:
        _destroy_card(stop_defense_activation_slot)
        stop_defense_activation_slot = null


    _cancel_stop_defense_targeting()


    player_has_played = true
    unlock_cards_after_play()
    set_end_turn_button_active(true)

func _cancel_stop_defense_targeting():
    "\n    Cancela o modo de seleção de alvo para Stop Defense\n    "


    print("Cancelando seleção de alvo para Stop Defense")

    current_game_state = GameState.MAIN_PHASE
    pending_stop_defense_target_player = false


    for slot in player_slots + enemy_slots:
        slot.modulate = Color.WHITE
        slot.mouse_default_cursor_shape = Control.CURSOR_ARROW

        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            visual.modulate = Color.WHITE
            visual.mouse_default_cursor_shape = Control.CURSOR_ARROW


    if stop_defense_activation_slot:

        print("Stop Defense cancelado - carta permanece no campo")
        stop_defense_activation_slot = null


    reset_card_selection()


    if not player_has_played:
        print("Seleção de Stop Defense cancelada - Pode selecionar nova carta")
    else:
        print("Seleção de Stop Defense cancelada")


func _is_enemy_field_empty() -> bool:
    return _count_occupied_slots(enemy_slots) == 0


func execute_battle(attacker_slot, defender_slot):
    var is_player_attacker = attacker_slot.is_player_slot if "is_player_slot" in attacker_slot else false


    if not _can_monster_attack_complete(is_player_attacker, attacker_slot):
        return

    trap_canceled_the_battle = false

    is_resolving_battle = true

    var attacker_card = attacker_slot.stored_card_data
    if attacker_card == null:
        is_resolving_battle = false
        return

    var defender_card: CardData = null
    if defender_slot and defender_slot.is_occupied:
        defender_card = defender_slot.stored_card_data


    var att_visual = null
    if attacker_slot.spawn_point.get_child_count() > 0:
        att_visual = attacker_slot.spawn_point.get_child(0)

    if att_visual == null:
        print("Batalha cancelada: visual do atacante não existe mais (destruído por trap?)")
        is_resolving_battle = false
        return

    if attacker_slot.is_player_slot:
        var was_face_down = _has_card_back(att_visual)
        if att_visual.rotation_degrees != 0:
            att_visual.rotation_degrees = 0
        reveal_player_card_in_slot(attacker_slot)


        if was_face_down and attacker_card:
            print("Jogador revelou para atacar, emitindo monster_summoned!")
            var was_locked = trap_processing_count > 0
            is_processing_trap = true
            EventBus.monster_summoned.emit(attacker_slot, attacker_card, true)
            is_processing_trap = false


            if not was_locked:
                while is_processing_trap:
                    await get_tree().process_frame


    if att_visual:
        await _animate_attack_movement(att_visual, is_player_attacker)

    var was_locked_attack = trap_processing_count > 0
    is_processing_trap = true
    EventBus.attack_declared.emit(attacker_slot, defender_slot)
    is_processing_trap = false


    if not was_locked_attack:
        while is_processing_trap:
            await get_tree().process_frame

    if trap_canceled_the_battle:
        _finish_battle_sequence()
        return


    if not is_instance_valid(att_visual):
        print("Batalha abortada: atacante foi removido do campo por trap.")
        _finish_battle_sequence()
        return

    if EffectManager.has_method("apply_monster_effect_on_attack"):
        await EffectManager.apply_monster_effect_on_attack(
            attacker_card, 
            is_player_attacker, 
            attacker_slot
        )

    var should_be_exhausted = true

    if EffectManager.can_monster_have_multiple_attacks(attacker_card):
        EffectManager.register_monster_attack(attacker_slot, attacker_card)

        if EffectManager.has_monster_reached_attack_limit(attacker_slot, attacker_card):
            should_be_exhausted = true
        else:
            should_be_exhausted = false


    if should_be_exhausted:
        attacker_slot.has_attacked_this_turn = true
        if is_instance_valid(att_visual) and att_visual.has_method("set_exhausted"):
            att_visual.set_exhausted(true)
    else:

        attacker_slot.has_attacked_this_turn = false
        if is_instance_valid(att_visual) and att_visual.has_method("set_exhausted"):
            att_visual.set_exhausted(false)


    if is_instance_valid(att_visual) and not att_visual.is_queued_for_deletion():
        if att_visual.has_method("remove_attack_glow"):
            att_visual.remove_attack_glow()
        else:
            att_visual.modulate = Color.WHITE


    var force_direct_attack = _check_direct_attack_effect(attacker_slot, defender_slot)

    if force_direct_attack:
        print("Efeito de monstro forçando ataque direto!")


        await _execute_direct_attack(attacker_card, is_player_attacker, attacker_slot)
        _finish_battle_sequence()
        return


    if defender_card == null:
        await _execute_direct_attack(attacker_card, is_player_attacker, attacker_slot)
        _finish_battle_sequence()
        return


    if defender_slot.is_player_slot:
        reveal_player_card_in_slot(defender_slot)
    else:
        reveal_enemy_card_in_slot(defender_slot)

    await get_tree().create_timer(0.5).timeout


    if EffectManager.has_method("apply_monster_effect_on_attacked"):
        await EffectManager.apply_monster_effect_on_attacked(
            defender_card, 
            defender_slot.is_player_slot, 
            defender_slot, 
            attacker_card, 
            attacker_slot
        )


    var atk_bonus = get_guardian_bonus(attacker_card, defender_card)
    var def_bonus = get_guardian_bonus(defender_card, attacker_card)

    if atk_bonus > 0 or def_bonus > 0:
        await _animate_guardian_bonus(attacker_slot, defender_slot, attacker_card, defender_card)


    if not attacker_slot.is_occupied or not defender_slot.is_occupied:
        print("Batalha abortada: Monstros removidos antes do dano.")

        if att_visual:
            att_visual.scale = Vector2(1, 1)
        _finish_battle_sequence()
        return


    var temp_atk_bonus = 0
    if EffectManager.has_method("get_temporary_attack_bonus"):
        temp_atk_bonus = EffectManager.get_temporary_attack_bonus(attacker_card, defender_card)
        if temp_atk_bonus != 0:
            attacker_card.atk += temp_atk_bonus
            print("Batalha: Aplicando bônus temporário de %+d ATK durante cálculo." % temp_atk_bonus)
            if att_visual and att_visual.has_method("animate_stats_bonus"):
                att_visual.animate_stats_bonus(attacker_card.atk, attacker_card.def)
                await get_tree().create_timer(0.5).timeout


    await _resolve_battle_damage(attacker_slot, defender_slot, attacker_card, defender_card)


    if temp_atk_bonus != 0:
        attacker_card.atk -= temp_atk_bonus
        print("Batalha: Revertendo bônus temporário de %+d ATK." % temp_atk_bonus)
        if is_instance_valid(att_visual) and not att_visual.is_queued_for_deletion() and att_visual.has_method("animate_stats_bonus"):
            att_visual.animate_stats_bonus(attacker_card.atk, attacker_card.def)

    update_lp_ui()
    check_game_over()
    await get_tree().create_timer(0.5).timeout


    if is_instance_valid(att_visual) and not att_visual.is_queued_for_deletion():
        if att_visual.has_method("remove_attack_glow"):
            att_visual.remove_attack_glow()
        else:
            att_visual.modulate = Color.WHITE


    _reset_battle_animations(attacker_slot, attacker_card)
    _reset_battle_animations(defender_slot, defender_card)

    _finish_battle_sequence()

func _can_monster_attack_complete(is_player_owner: bool, slot) -> bool:

    if not slot or not slot.is_occupied or not slot.stored_card_data:
        return false

    var card_data = slot.stored_card_data


    if not EffectManager.can_monster_attack(is_player_owner, slot):
        return false


    if slot.has_attacked_this_turn:

        if card_data.id == 675 and EffectManager.has_method("has_twin_burst_reached_limit"):
            if not EffectManager.has_twin_burst_reached_limit(slot, card_data):
                print("Blue-Eyes Twin Burst Dragon pode atacar novamente!")
                return true
            else:
                print("Blue-Eyes Twin Burst Dragon já atacou 2 vezes!")
                return false
        print("Este monstro já atacou neste turno!")
        return false

    return true

func _on_trap_consumed(_trap: TrapData, _attacker_slot: Node, _defender_slot: Node) -> void :
    is_processing_trap = true


    if _trap.cancels_battle:
        trap_canceled_the_battle = true




    await get_tree().create_timer(0.5).timeout


    _destroy_card(_trap.owner)






    await get_tree().create_timer(0.2).timeout
    is_processing_trap = false

func _on_trap_triggered(_trap: TrapData):
    print("Trap disparada visualmente (Immediate Revelation): ", _trap.name)
    var slot = _trap.owner
    if not slot: return


    if slot.is_player_slot:
        reveal_player_card_in_slot(slot)
    else:
        reveal_enemy_card_in_slot(slot)


    var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    if visual:
        _apply_magic_activation_glow(visual)

func _animate_attack_movement(card_visual, is_player_attacker: bool):
    var original_scale = card_visual.scale
    var original_position = card_visual.position

    _play_attack_sound()


    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)


    tween.tween_property(card_visual, "scale", original_scale * 1.2, 0.2)


    var y_offset = 15 if is_player_attacker else -15
    tween.tween_property(card_visual, "position", original_position.y + y_offset, 0.2)


    await tween.finished


    var tween_back = create_tween()
    tween_back.set_parallel(true)
    tween_back.set_trans(Tween.TRANS_QUAD)
    tween_back.set_ease(Tween.EASE_IN)

    tween_back.tween_property(card_visual, "scale", original_scale, 0.2)
    tween_back.tween_property(card_visual, "position", original_position.y, 0.2)


    await tween_back.finished

func _execute_direct_attack(attacker: CardData, is_player_attacker: bool, attacker_slot = null):
    if attacker_slot == null:
        attacker_slot = _find_slot_by_card(attacker, is_player_attacker)

    if attacker_slot and not EffectManager.can_monster_attack(is_player_attacker, attacker_slot):
        print("Ataque direto bloqueado por Swords of Revealing Light!")
        return

    var dmg = get_effective_atk(attacker, null)
    await get_tree().create_timer(0.5).timeout


    if attacker.id == 367:
        print("Jirai Gumo fazendo ataque direto! Perde metade do ATK")


        var half_atk = floor(attacker.atk / 2.0)
        attacker.atk = half_atk


        if attacker_slot and attacker_slot.spawn_point.get_child_count() > 0:
            var att_visual = attacker_slot.spawn_point.get_child(0)
            if att_visual.has_method("animate_stats_bonus"):
                await att_visual.animate_stats_bonus(attacker.atk, attacker.def)

        await get_tree().create_timer(0.2).timeout

        print("Jirai Gumo: Novo ATK = ", attacker.atk)


        dmg = get_effective_atk(attacker, null)



    var att_visual = null
    if attacker_slot and attacker_slot.spawn_point.get_child_count() > 0:
        att_visual = attacker_slot.spawn_point.get_child(0)


    if att_visual == null:
        print("Ataque direto cancelado: monstro atacante não existe mais")
        return

    await _play_battle_cutscene(att_visual, null, "DIRECT", attacker, null)



    var target_is_player = not is_player_attacker
    if EffectManager.should_prevent_battle_damage(target_is_player):
        print("Kuriboh previne ", dmg, " de dano de ataque direto!")
        dmg = 0


    var direct_target_is_player = not is_player_attacker
    if (direct_target_is_player and waboku_active_player) or ( not direct_target_is_player and waboku_active_enemy):
        print("Waboku: dano de ataque direto bloqueado!")
        dmg = 0

    if is_player_attacker:
        enemy_lp -= dmg
        if EffectManager.robbin_goblin_active_player and dmg > 0:
            print("Robbin' Goblin (Player) ativou: Inimigo descarta 1 carta!")
            discard_random_card_from_hand(false)
    else:
        player_lp -= dmg
        if EffectManager.robbin_goblin_active_enemy and dmg > 0:
            print("Robbin' Goblin (Enemy) ativou: Jogador descarta 1 carta!")
            discard_random_card_from_hand(true)

    if attacker.id == 99998:
        print("Trinity of Divine Chaos atacou diretamente! Aplicando dano de recuo (", dmg, ").")
        if is_player_attacker:
            player_lp -= dmg
        else:
            enemy_lp -= dmg


    if attacker.id == 114 and dmg > 0:
        print("White Magical Hat causou dano direto! Ativando efeito...")
        var opponent_is_player = not is_player_attacker
        discard_random_opponent_card(opponent_is_player)


    if attacker.id == 220 and dmg > 0:
        print("Masked Sorcerer causou dano direto! Ativando efeito...")
        var opponent_is_player = not is_player_attacker
        discard_random_card_from_opponent_deck(opponent_is_player)


    if attacker.id == GOBLIN_ZOMBIE_ID and dmg > 0:
        print("Goblin Zombie causou dano direto! Oponente descarta 1 carta aleatÃ³ria da mÃ£o.")
        var opponent_is_player = not is_player_attacker
        discard_random_card_from_opponent_deck(opponent_is_player, "Goblin Zombie")

    update_lp_ui()
    check_game_over()

func discard_random_card_from_hand(is_player_hand: bool):
    var target_hand = player_hand if is_player_hand else enemy_hand
    var valid_indices = []

    for i in range(target_hand.size()):
        if target_hand[i] != null:
            valid_indices.append(i)

    if valid_indices.is_empty():
        return

    var discard_idx = valid_indices[randi() % valid_indices.size()]
    var discarded_card = target_hand[discard_idx]
    target_hand[discard_idx] = null

    print("DuelManager: Descartada ", discarded_card.name, " da mão do ", "Jogador" if is_player_hand else "Inimigo")
    send_to_graveyard(discarded_card, is_player_hand, true)

    if is_player_hand:
        update_hand_ui()
    else:
        update_enemy_hand_ui()

func _check_direct_attack_effect(attacker_slot, defender_slot) -> bool:

    if not attacker_slot or not attacker_slot.stored_card_data:
        return false

    var attacker_card = attacker_slot.stored_card_data


    if attacker_card.id in DIRECT_ATTACK_MONSTER_IDS:
        return true



    return false

func _find_slot_by_card(card_data: CardData, is_player_card: bool):
    var slots = player_slots if is_player_card else enemy_slots

    for slot in slots:
        if slot.is_occupied and slot.stored_card_data == card_data:
            return slot

    return null

func _animate_guardian_bonus(att_slot, def_slot, att_card: CardData, def_card: CardData):
    var att_total_atk = get_effective_atk(att_card, def_card)
    var att_total_def = get_effective_def(att_card, def_card)
    var def_total_atk = get_effective_atk(def_card, att_card)
    var def_total_def = get_effective_def(def_card, att_card)


    if att_card in metalmorph_equipped_monsters:
        var metalmorph_bonus = int(def_card.atk / 2.0)
        att_total_atk += metalmorph_bonus

    if att_slot.spawn_point.get_child_count() > 0:
        att_slot.spawn_point.get_child(0).animate_stats_bonus(att_total_atk, att_total_def)

    if def_slot.spawn_point.get_child_count() > 0:
        def_slot.spawn_point.get_child(0).animate_stats_bonus(def_total_atk, def_total_def)

    await get_tree().create_timer(1.0).timeout

func _resolve_battle_damage(att_slot, def_slot, att_card: CardData, def_card: CardData):

    if not att_slot or not att_slot.is_occupied or not att_card:
        print("Batalha cancelada: Atacante não existe mais.")
        return


    if def_card != null:
        if def_slot and ( not def_slot.is_occupied or not def_card):
             print("Batalha cancelada: Defensor não existe mais.")
             return


        if def_slot.spawn_point.get_child_count() == 0:
            print("Batalha cancelada: Visual do defensor não encontrado.")
            return

    var final_attacker_power = get_effective_atk(att_card, def_card)

    var att_db = CardDatabase.get_card(att_card.id)
    var def_db = CardDatabase.get_card(def_card.id)
    print("=== DEBUG BATTLE RESOLVE ===")
    print("  Atacante: %s (ID:%d) | ATK campo: %d | ATK DB: %d | ATK efetivo: %d" % [att_card.name, att_card.id, att_card.atk, att_db.atk if att_db else -1, final_attacker_power])
    print("  Defensor: %s (ID:%d) | ATK campo: %d | ATK DB: %d | DEF campo: %d | DEF DB: %d" % [def_card.name, def_card.id, def_card.atk, def_db.atk if def_db else -1, def_card.def, def_db.def if def_db else -1])
    print("  Guardian Stars: ATT=%s vs DEF=%s | Bonus ATK: %d | Bonus DEF: %d" % [att_card.guardian_star, def_card.guardian_star, get_guardian_bonus(att_card, def_card), get_guardian_bonus(def_card, att_card)])

    var def_visual = def_slot.spawn_point.get_child(0)


    var is_defender_defense = _is_card_in_defense(def_slot, def_visual)
    print("  Defensor em defesa? %s (rotation: %f)" % [str(is_defender_defense), def_visual.rotation_degrees])

    if not is_defender_defense:
        print("  -> Resolvendo ATK vs ATK")
        await _resolve_atk_vs_atk(att_slot, def_slot, att_card, def_card, final_attacker_power)
    else:
        print("  -> Resolvendo ATK vs DEF")
        await _resolve_atk_vs_def(att_slot, def_slot, att_card, def_card, final_attacker_power)

func _is_card_in_defense(slot, visual) -> bool:
    if slot.is_player_slot:
        return visual.rotation_degrees != 0
    else:
        return visual.rotation_degrees != 180

func _resolve_atk_vs_atk(att_slot, def_slot, att_card: CardData, def_card: CardData, att_power: int):
    var def_power = get_effective_atk(def_card, att_card)
    print("=== DEBUG ATK vs ATK ===")
    print("  att_power (efetivo): %d | def_power (efetivo): %d" % [att_power, def_power])
    print("  att_card.atk bruto: %d | def_card.atk bruto: %d" % [att_card.atk, def_card.atk])


    var defender_is_zone_eater = (def_card.id == 393)


    var attacker_is_swordsman = (att_card.id == 399)


    if att_card.id == 367:
        print("Jirai Gumo atacando monstro! Ganha +100 ATK")


        att_card.atk += 100


        if att_slot.spawn_point.get_child_count() > 0:
            var att_visual = att_slot.spawn_point.get_child(0)
            if att_visual.has_method("animate_stats_bonus"):
                await att_visual.animate_stats_bonus(att_card.atk, att_card.def)

        await get_tree().create_timer(0.2).timeout

        print("Jirai Gumo: Novo ATK = ", att_card.atk)


        att_power = get_effective_atk(att_card, def_card)


    if def_card.id == 288 and att_card.attribute.to_lower() == "light":
        print("Dark Artist sendo atacada por monstro LIGHT! Perde -100 DEF")
        def_card.def += -100


        if def_slot.spawn_point.get_child_count() > 0:
            var def_visual = def_slot.spawn_point.get_child(0)
            if def_visual.has_method("animate_stats_bonus"):
                def_visual.animate_stats_bonus(def_card.atk, def_card.def)

        print("Dark Artist: Nova DEF = ", def_card.def)
        def_power = get_effective_atk(def_card, att_card)


    if att_card.id == 288 and def_card.attribute.to_lower() == "light":
        print("Dark Artist atacando monstro LIGHT! Ganha +100 ATK")
        att_card.atk += 100


        if att_slot.spawn_point.get_child_count() > 0:
            var att_visual = att_slot.spawn_point.get_child(0)
            if att_visual.has_method("animate_stats_bonus"):
                att_visual.animate_stats_bonus(att_card.atk, att_card.atk)

        print("Dark Artist: Novo ATK = ", att_card.atk)
        att_power = get_effective_atk(att_card, def_card)


    var has_metalmorph = false
    var metalmorph_atk_bonus = 0
    if att_card in metalmorph_equipped_monsters:
        has_metalmorph = true
        metalmorph_atk_bonus = int(def_card.atk / 2.0)
        print("Metalmorph ativado! Atacante ganha +", metalmorph_atk_bonus, " ATK.")

        att_card.atk += metalmorph_atk_bonus

        var guardian_bonus = get_guardian_bonus(att_card, def_card)
        if guardian_bonus == 0:
            if att_slot.spawn_point.get_child_count() > 0:
                var att_visual = att_slot.spawn_point.get_child(0)
                if att_visual.has_method("animate_stats_bonus"):
                    await att_visual.animate_stats_bonus(att_card.atk, att_card.def)
            await get_tree().create_timer(0.2).timeout
        att_power = get_effective_atk(att_card, def_card)


    var att_visual = att_slot.spawn_point.get_child(0)
    var def_visual = def_slot.spawn_point.get_child(0)
    var result_str = ""

    if att_power > def_power:
        result_str = "ATTACKER_WINS"
    elif att_power == def_power:
        result_str = "DRAW"
    else:
        result_str = "DEFENDER_WINS"

    await _play_battle_cutscene(att_visual, def_visual, result_str, att_card, def_card)


    if att_power > def_power:
        var damage = att_power - def_power


        var target_is_player = not att_slot.is_player_slot
        if EffectManager.should_prevent_battle_damage(target_is_player):
            print("Kuriboh previne ", damage, " de dano!")
            damage = 0




        var def_is_protected_by_waboku = (
            ( not att_slot.is_player_slot and waboku_active_player) or 
            (att_slot.is_player_slot and waboku_active_enemy)
        )
        if def_is_protected_by_waboku:
            print("Waboku: monstro defensor protegido da destruição!")
            damage = 0
        elif def_card.id == 99998:
            print("Trinity of Divine Chaos (DEFENSOR) não é destruído em batalha!")
        else:
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true


        if att_card.id == 262 and not def_is_protected_by_waboku:
            print("The Little Swordsman of Aile destruiu um monstro! Aplicando +200 ATK...")
            att_card.atk += 200


            if att_slot.spawn_point.get_child_count() > 0:
                var visual = att_slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(att_card.atk, att_card.def)

            print("The Little Swordsman of Aile: Novo ATK = ", att_card.atk)

        if not def_is_protected_by_waboku:
            if att_slot.is_player_slot:
                enemy_lp -= damage
                if EffectManager.robbin_goblin_active_player and damage > 0:
                    print("Robbin' Goblin (Player) ativou: Inimigo descarta 1 carta!")
                    discard_random_card_from_hand(false)

                if att_card.id == 99998:
                    print("Trinity of Divine Chaos atacou! Sofre dano de recuo: ", damage)
                    player_lp -= damage
            else:
                player_lp -= damage
                if EffectManager.robbin_goblin_active_enemy and damage > 0:
                    print("Robbin' Goblin (Enemy) ativou: Jogador descarta 1 carta!")
                    discard_random_card_from_hand(true)

                if att_card.id == 99998:
                    print("Trinity of Divine Chaos atacou! Sofre dano de recuo: ", damage)
                    enemy_lp -= damage


        if defender_is_zone_eater and att_slot.is_occupied and not def_is_protected_by_waboku:
            print("Zone Eater: Destruindo monstro que o atacou!")
            enable_lp_floating_text = false
            await _destroy_card(att_slot)
            enable_lp_floating_text = true


        if att_card.id == 114 and damage > 0:
            print("White Magical Hat causou dano em batalha! Ativando efeito...")
            var opponent_is_player = not att_slot.is_player_slot
            discard_random_opponent_card(opponent_is_player)


        if att_card.id == 220 and damage > 0:
            print("Masked Sorcerer causou dano em batalha direta! Ativando efeito...")
            var opponent_is_player = not att_slot.is_player_slot
            discard_random_card_from_opponent_deck(opponent_is_player, "Masked Sorcerer")


        if att_card.id == GOBLIN_ZOMBIE_ID and damage > 0:
            print("Goblin Zombie causou dano em batalha! Oponente descarta 1 carta aleatÃ³ria da mÃ£o.")
            var opponent_is_player = not att_slot.is_player_slot
            discard_random_card_from_opponent_deck(opponent_is_player, "Goblin Zombie")


        if att_card.id == 523 and damage > 0:
            print("The Bistro Butcher causou dano em batalha direta! Ativando efeito...")
            var opponent_is_player = not att_slot.is_player_slot
            discard_random_card_from_opponent_deck(opponent_is_player, "The Bistro Butcher")


        if att_card.id == 256:
            if def_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(def_slot)
                enable_lp_floating_text = true
            if att_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(att_slot)
                enable_lp_floating_text = true

    elif att_power < def_power:
        var damage = def_power - att_power


        var target_is_player = att_slot.is_player_slot
        if EffectManager.should_prevent_battle_damage(target_is_player):
            print("Kuriboh previne ", damage, " de dano!")
            damage = 0


        var att_is_protected_by_waboku = (
            (att_slot.is_player_slot and waboku_active_player) or 
            ( not att_slot.is_player_slot and waboku_active_enemy)
        )
        if att_is_protected_by_waboku:
            print("Waboku: monstro atacante protegido da destruição e sem dano de LP!")
            damage = 0
        elif att_card.id == 99998:
            print("Trinity of Divine Chaos (ATACANTE) não é destruído e previne o dano em batalha perdido.")
            damage = 0
        else:
            enable_lp_floating_text = false
            await _destroy_card(att_slot)
            enable_lp_floating_text = true


        if def_card.id == 99998 and damage > 0:
            print("Trinity of Divine Chaos causou dano retroativo como defensor! Recuo aplicado.")
            if att_slot.is_player_slot:
                enemy_lp -= damage
            else:
                player_lp -= damage


        if attacker_is_swordsman and def_slot.is_occupied:
            print("Swordsman from a Distant Land: Destruindo defensor mesmo após ser destruído!")
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true


        if att_card.id == 256:
            if def_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(def_slot)
                enable_lp_floating_text = true
            if att_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(att_slot)
                enable_lp_floating_text = true

    else:

        enable_lp_floating_text = false
        var att_waboku = (att_slot.is_player_slot and waboku_active_player) or ( not att_slot.is_player_slot and waboku_active_enemy)
        var def_waboku = ( not att_slot.is_player_slot and waboku_active_player) or (att_slot.is_player_slot and waboku_active_enemy)
        if not att_waboku:
            if att_card.id != 99998:
                await _destroy_card(att_slot)
        else:
            print("Waboku: monstro atacante protegido no empate!")
        if not def_waboku:
            if def_card.id != 99998:
                await _destroy_card(def_slot)
        else:
            print("Waboku: monstro defensor protegido no empate!")
        enable_lp_floating_text = true


    if has_metalmorph:
        att_card.atk -= metalmorph_atk_bonus
        print("Metalmorph: Buff revertido. Novo ATK = ", att_card.atk)
        if att_slot.spawn_point.get_child_count() > 0:
            var m_att_visual_rev = att_slot.spawn_point.get_child(0)
            if m_att_visual_rev.has_method("animate_stats_bonus"):
                m_att_visual_rev.animate_stats_bonus(att_card.atk, att_card.def)


    if def_card.id == 541:
        await _apply_hane_hane_effect(att_slot, att_card)


    if def_card.id == 668 and att_slot.is_occupied:
        print("Wall of Illusion: Devolvendo monstro atacante (%s) para o deck!" % att_card.name)
        await _apply_hane_hane_effect(att_slot, att_card)


    if att_card.id == 410 and def_card.attribute.to_lower() == "dark":
        if def_slot.is_occupied:
            await _destroy_card(def_slot)


    if att_card.id == 256:
        if def_slot.is_occupied:
            await _destroy_card(def_slot)
        if att_slot.is_occupied:
            await _destroy_card(att_slot)

    if attacker_is_swordsman and def_slot.is_occupied:
        print("Swordsman from a Distant Land: Destruindo defensor mesmo após ser destruído!")
        enable_lp_floating_text = false
        await _destroy_card(def_slot)
        enable_lp_floating_text = true


    if def_card.id == 766 and att_slot.is_occupied:
        print("Sphere Kuriboh: Colocando atacante '%s' em modo de defesa!" % att_card.name)
        if att_slot.spawn_point.get_child_count() > 0:
            var att_vis = att_slot.spawn_point.get_child(0)
            if att_slot.is_player_slot:
                att_vis.rotation_degrees = 90
            else:
                att_vis.rotation_degrees = -90

func _resolve_atk_vs_def(att_slot, def_slot, att_card: CardData, def_card: CardData, att_power: int):
    var def_power = get_effective_def(def_card, att_card)
    print("=== DEBUG ATK vs DEF ===")
    print("  att_power (efetivo): %d | def_power (efetivo DEF): %d" % [att_power, def_power])
    print("  att_card.atk bruto: %d | def_card.def bruto: %d" % [att_card.atk, def_card.def])


    var defender_is_zone_eater = (def_card.id == 393)


    var attacker_is_swordsman = (att_card.id == 399)


    if att_card.id == 367:
        print("Jirai Gumo atacando monstro! Ganha +100 ATK")


        att_card.atk += 100


        if att_slot.spawn_point.get_child_count() > 0:
            var att_visual = att_slot.spawn_point.get_child(0)
            if att_visual.has_method("animate_stats_bonus"):
                await att_visual.animate_stats_bonus(att_card.atk, att_card.def)

        await get_tree().create_timer(0.2).timeout

        print("Jirai Gumo: Novo ATK = ", att_card.atk)


        att_power = get_effective_atk(att_card, def_card)


    if def_card.id == 288 and att_card.attribute.to_lower() == "light":
        print("Dark Artist sendo atacada por monstro LIGHT! Perde -100 DEF")
        def_card.def += -100


        if def_slot.spawn_point.get_child_count() > 0:
            var def_visual = def_slot.spawn_point.get_child(0)
            if def_visual.has_method("animate_stats_bonus"):
                def_visual.animate_stats_bonus(def_card.atk, def_card.def)

        print("Dark Artist: Nova DEF = ", def_card.def)
        def_power = get_effective_atk(def_card, att_card)


    if att_card.id == 288 and def_card.attribute.to_lower() == "light":
        print("Dark Artist atacando monstro LIGHT! Ganha +100 ATK")
        att_card.atk += 100


        if att_slot.spawn_point.get_child_count() > 0:
            var att_visual = att_slot.spawn_point.get_child(0)
            if att_visual.has_method("animate_stats_bonus"):
                att_visual.animate_stats_bonus(att_card.atk, att_card.atk)

        print("Dark Artist: Novo ATK = ", att_card.atk)
        att_power = get_effective_atk(att_card, def_card)


    var has_metalmorph = false
    var metalmorph_atk_bonus = 0
    if att_card in metalmorph_equipped_monsters:
        has_metalmorph = true
        metalmorph_atk_bonus = int(def_card.atk / 2.0)
        print("Metalmorph ativado! Atacante ganha +", metalmorph_atk_bonus, " ATK.")

        att_card.atk += metalmorph_atk_bonus

        var guardian_bonus = get_guardian_bonus(att_card, def_card)
        if guardian_bonus == 0:
            if att_slot.spawn_point.get_child_count() > 0:
                var m_att_visual = att_slot.spawn_point.get_child(0)
                if m_att_visual.has_method("animate_stats_bonus"):
                    await m_att_visual.animate_stats_bonus(att_card.atk, att_card.def)
            await get_tree().create_timer(0.2).timeout
        att_power = get_effective_atk(att_card, def_card)


    var att_visual_cutscene = att_slot.spawn_point.get_child(0)
    var def_visual_cutscene = def_slot.spawn_point.get_child(0)
    var result_str = ""

    if att_power > def_power:
        result_str = "ATTACKER_WINS"
    elif att_power == def_power:
        result_str = "DRAW"
    else:
        result_str = "DEFENDER_WINS"

    await _play_battle_cutscene(att_visual_cutscene, def_visual_cutscene, result_str, att_card, def_card)


    if att_power > def_power:

        var def_waboku_atk_def = (
            ( not att_slot.is_player_slot and waboku_active_player) or 
            (att_slot.is_player_slot and waboku_active_enemy)
        )
        if def_waboku_atk_def:
            print("Waboku: monstro defensor (DEF) protegido da destruição!")
        else:

            if att_card.id == 262:
                print("The Little Swordsman of Aile destruiu um monstro! Aplicando +200 ATK...")
                att_card.atk += 200


                if att_slot.spawn_point.get_child_count() > 0:
                    var visual = att_slot.spawn_point.get_child(0)
                    if visual.has_method("animate_stats_bonus"):
                        visual.animate_stats_bonus(att_card.atk, att_card.def)

                print("The Little Swordsman of Aile: Novo ATK = ", att_card.atk)

            enable_lp_floating_text = false
            if def_card.id != 99998:
                _destroy_card(def_slot)
            enable_lp_floating_text = true


            if defender_is_zone_eater:
                print("Zone Eater: Monstro atacante será destruído mesmo após destruir o Zone Eater!")
                enable_lp_floating_text = false
                await _destroy_card(att_slot)
                enable_lp_floating_text = true

    elif att_power == def_power:
        if attacker_is_swordsman and def_slot.is_occupied:
            print("Swordsman from a Distant Land: Destruindo defensor mesmo após ser destruído!")
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true


        if att_card.id == 256:
            if def_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(def_slot)
                enable_lp_floating_text = true
            if att_slot.is_occupied:
                enable_lp_floating_text = false
                await _destroy_card(att_slot)
                enable_lp_floating_text = true

        pass

    else:
        var damage = def_power - att_power


        var target_is_player = att_slot.is_player_slot
        if EffectManager.should_prevent_battle_damage(target_is_player):
            print("Kuriboh previne ", damage, " de dano de contra-ataque (DEF)!")
            damage = 0


        var att_waboku_atk_def = (
            (att_slot.is_player_slot and waboku_active_player) or 
            ( not att_slot.is_player_slot and waboku_active_enemy)
        )
        if att_waboku_atk_def:
            print("Waboku: dano de LP bloqueado (ATK vs DEF)!")
            damage = 0

        if att_card.id == 99998:
            damage = 0

        if att_slot.is_player_slot:
            player_lp -= damage



            if EffectManager.robbin_goblin_active_enemy and damage > 0:
                print("Robbin' Goblin (Enemy) ativou por defesa: Jogador descarta 1 carta!")
                discard_random_card_from_hand(true)
        else:
            enemy_lp -= damage

            if EffectManager.robbin_goblin_active_player and damage > 0:
                print("Robbin' Goblin (Player) ativou por defesa: Inimigo descarta 1 carta!")
                discard_random_card_from_hand(false)


        if def_card.id == 99998 and damage > 0:
            print("Trinity of Divine Chaos penaliza dono no recuo: ", damage)
            if att_slot.is_player_slot:
               enemy_lp -= damage
            else:
               player_lp -= damage



    if attacker_is_swordsman:
        if def_slot.is_occupied:
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true


    if att_card.id == 410 and def_card.attribute.to_lower() == "dark":
        if def_slot.is_occupied:
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true


    if att_card.id == 256:
        if def_slot.is_occupied:
            enable_lp_floating_text = false
            await _destroy_card(def_slot)
            enable_lp_floating_text = true
        if att_slot.is_occupied:
            enable_lp_floating_text = false
            await _destroy_card(att_slot)
            enable_lp_floating_text = true


    if has_metalmorph:
        att_card.atk -= metalmorph_atk_bonus
        print("Metalmorph: Buff revertido (DEF). Novo ATK = ", att_card.atk)
        if att_slot.spawn_point.get_child_count() > 0:
            var m_att_visual_rev_def = att_slot.spawn_point.get_child(0)
            if m_att_visual_rev_def.has_method("animate_stats_bonus"):
                m_att_visual_rev_def.animate_stats_bonus(att_card.atk, att_card.def)


    if def_card.id == 541:
        await _apply_hane_hane_effect(att_slot, att_card)


    if def_card.id == 668 and att_slot.is_occupied:
        print("Wall of Illusion: Devolvendo monstro atacante (%s) para o deck!" % att_card.name)
        await _apply_hane_hane_effect(att_slot, att_card)


    if def_card.id == 766 and att_slot.is_occupied:
        print("Sphere Kuriboh: Colocando atacante '%s' em modo de defesa!" % att_card.name)
        if att_slot.spawn_point.get_child_count() > 0:
            var att_vis = att_slot.spawn_point.get_child(0)
            if att_slot.is_player_slot:
                att_vis.rotation_degrees = 90
            else:
                att_vis.rotation_degrees = -90


func _apply_hane_hane_effect(att_slot, att_card: CardData):
    if not att_slot or not att_slot.is_occupied:
        return

    print("Hane-Hane acionado! Devolvendo monstro atacante (%s) para o deck..." % att_card.name)
    var is_player_owner = att_slot.is_player_slot
    var owner_deck = player_deck_pile if is_player_owner else enemy_deck_pile


    var att_visual = att_slot.spawn_point.get_child(0) if att_slot.spawn_point.get_child_count() > 0 else null
    if att_visual:
        att_visual.queue_free()

    att_slot.is_occupied = false
    att_slot.stored_card_data = null


    owner_deck.append(att_card.get_original_atk_def())
    owner_deck.shuffle()
    update_deck_ui()

func _reset_battle_animations(slot, card: CardData):
    if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
        var visual = slot.spawn_point.get_child(0)
        var reset_atk = get_effective_atk(card, null)
        var reset_def = get_effective_def(card, null)
        visual.animate_stats_bonus(reset_atk, reset_def)

func _finish_battle_sequence():
    is_resolving_battle = false
    trap_canceled_the_battle = false

    if game_over:
        pending_turn_end = false
        return

    if pending_turn_end:
        pending_turn_end = false
        _execute_end_turn_logic()

    if current_game_state == GameState.BATTLE_TARGETING:
        cancel_attack_targeting()

func cancel_attack_targeting():
    current_game_state = GameState.MAIN_PHASE
    attacker_slot_ref = null


    for p_slot in player_slots:
        if p_slot.spawn_point.get_child_count() > 0:
            var visual = p_slot.spawn_point.get_child(0)
            if visual.has_method("remove_attack_glow"):
                visual.remove_attack_glow()
            else:
                visual.modulate = Color.WHITE
            visual.mouse_default_cursor_shape = Control.CURSOR_ARROW

    for e_slot in enemy_slots:
        e_slot.modulate = Color.WHITE
        e_slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
        if e_slot.spawn_point.get_child_count() > 0:
            var visual = e_slot.spawn_point.get_child(0)
            visual.modulate = Color.WHITE
            visual.mouse_default_cursor_shape = Control.CURSOR_ARROW


func send_to_graveyard(card_data: CardData, is_player_owner: bool, ignore_field_check: bool = false):
    if card_data == null: return


    if not ignore_field_check:
        var slots_to_check = player_slots + player_spell_slots if is_player_owner else enemy_slots + enemy_spell_slots
        for slot in slots_to_check:
            if slot.is_occupied and slot.stored_card_data == card_data:
                return

    var card_for_graveyard = card_data.get_original_atk_def()


    if card_data.id == 752:
        var deck = player_deck_pile if is_player_owner else enemy_deck_pile
        var base_card = card_data.get_original_atk_def()
        deck.append(base_card)
        deck.shuffle()
        if is_player_owner:
            update_deck_ui()
        else:
            if has_node("EnemyArea/EnemyDeck"):
                $EnemyArea / EnemyDeck.update_deck(deck)
        print("Sword of Deep-Seated: Retornou ao deck do dono e o deck foi embaralhado!")
        return

    if is_player_owner:
        _play_discard_sound()
        player_graveyard.append(card_for_graveyard)
        if player_gy_visual.has_method("update_graveyard"):
            player_gy_visual.update_graveyard(player_graveyard)
    else:
        _play_discard_sound()
        enemy_graveyard.append(card_for_graveyard)
        if enemy_gy_visual.has_method("update_graveyard"):
            enemy_gy_visual.update_graveyard(enemy_graveyard)

func _on_player_gy_clicked():
    if _is_processing_action or is_processing_trap: return

    print("\n========================================")
    print("[DuelManager] _on_player_gy_clicked CHAMADO")
    print("========================================")


    if graveyard_window:
        var is_open = graveyard_window.is_open()
        var is_visible = graveyard_window.visible
        print("[DuelManager] Janela - is_open:", is_open, " visible:", is_visible)

        if not is_open:
            print("[DuelManager] >>> CHAMANDO show_graveyard <<<")
            graveyard_window.show_graveyard("Your Graveyard", player_graveyard)
            print("[DuelManager] >>> show_graveyard RETORNOU <<<")
        else:
            print("[DuelManager] !!! BLOQUEADO - Janela já está aberta !!!")
    else:
        print("[DuelManager] ERRO: graveyard_window é null!")
    print("========================================\n")

func _on_enemy_gy_clicked():
    if _is_processing_action or is_processing_trap: return

    print("\n========================================")
    print("[DuelManager] _on_enemy_gy_clicked CHAMADO")
    print("========================================")


    if graveyard_window:
        var is_open = graveyard_window.is_open()
        var is_visible = graveyard_window.visible
        print("[DuelManager] Janela - is_open:", is_open, " visible:", is_visible)

        if not is_open:
            print("[DuelManager] >>> CHAMANDO show_graveyard <<<")
            graveyard_window.show_graveyard("Enemy Graveyard", enemy_graveyard)
            print("[DuelManager] >>> show_graveyard RETORNOU <<<")
        else:
            print("[DuelManager] !!! BLOQUEADO - Janela já está aberta !!!")
    else:
        print("[DuelManager] ERRO: graveyard_window é null!")
    print("========================================\n")

func _destroy_card(slot_node, destroyed_by_battle: bool = true):
    if not slot_node or not slot_node.is_occupied:
        return

    var card_to_discard = slot_node.stored_card_data
    var card_data = slot_node.stored_card_data


    if card_data and _is_monster(card_data):
        await EffectManager._effect_fire(slot_node)




    slot_node.is_occupied = false

    if card_to_discard:
        var is_player = slot_node.is_player_slot
        await send_to_graveyard(card_to_discard, is_player, true)
        var was_locked_destroyed = trap_processing_count > 0
        is_processing_trap = true
        EventBus.monster_destroyed.emit(slot_node, card_to_discard, is_player)
        is_processing_trap = false


        if not was_locked_destroyed:
            while is_processing_trap:
                await get_tree().process_frame


        if card_data and _is_monster(card_data):
            _is_processing_action = true
            await EffectManager.apply_monster_effect_on_destruction(card_data, is_player, destroyed_by_battle, slot_node)
            _is_processing_action = false


    if card_to_discard and card_to_discard in black_pendant_equipped_monsters:
        print("Monstro com Black Pendant destruído: ", card_to_discard.name)

        if slot_node.is_player_slot:

            enemy_lp -= BLACK_PENDANT_DESTRUCTION_DAMAGE
            print("Black Pendant: ", BLACK_PENDANT_DESTRUCTION_DAMAGE, " de dano ao inimigo!")
        else:

            player_lp -= BLACK_PENDANT_DESTRUCTION_DAMAGE
            print("Black Pendant: ", BLACK_PENDANT_DESTRUCTION_DAMAGE, " de dano ao jogador!")

        update_lp_ui()
        check_game_over()


        black_pendant_equipped_monsters.erase(card_to_discard)



    _remove_traps_from_slot(slot_node)

    slot_node.stored_card_data = null
    slot_node.has_attacked_this_turn = false
    slot_node.modulate = Color.WHITE

    for child in slot_node.spawn_point.get_children():
        child.queue_free()

func _remove_traps_from_slot(slot_node) -> void :
    "Remove todas as traps registradas no TrapManager que pertencem a este slot"
    var traps_to_remove: Array[TrapData] = []


    for trap in TrapManager.player_traps:
        if trap.owner == slot_node:
            traps_to_remove.append(trap)


    for trap in TrapManager.enemy_traps:
        if trap.owner == slot_node:
            traps_to_remove.append(trap)


    for trap in traps_to_remove:
        print("Removendo trap fantasma: %s (ID:%d) do slot destruído" % [trap.name, trap.id])
        TrapManager.player_traps.erase(trap)
        TrapManager.enemy_traps.erase(trap)


func _on_end_turn_button_pressed():
    if current_turn != Turn.PLAYER or $CanvasLayer / EndTurnButton.disabled or _is_processing_action or is_processing_trap:
        return

    if is_resolving_battle:
        pending_turn_end = true
        $CanvasLayer / EndTurnButton.disabled = true
        return

    _play_confirm_sound()
    _execute_end_turn_logic()

func _execute_end_turn_logic():
    if current_game_state == GameState.BATTLE_TARGETING:
        cancel_attack_targeting()

    set_end_turn_button_active(false)
    current_turn = Turn.ENEMY
    set_all_cards_exhausted(true)
    end_player_turn()

func end_player_turn():
    if current_phase != TurnPhase.PLAYER:
        return

    if EffectManager:
        EffectManager.update_swords_on_enemy_turn()


    if waboku_active_player:
        waboku_active_player = false
        print("Waboku: Proteção do jogador expirou.")


    if EffectManager.robbin_goblin_active_player or EffectManager.robbin_goblin_active_enemy:
        EffectManager.robbin_goblin_active_player = false
        EffectManager.robbin_goblin_active_enemy = false
        print("Robbin' Goblin: Efeitos expiraram no fim do turno.")


    if reverse_trap_active_player:
        reverse_trap_active_player = false
        print("Reverse Trap: Efeito do jogador expirou.")


    if reinforcements_active_monsters.size() > 0:
        for buff in reinforcements_active_monsters:
            if buff.card:
                buff.card.atk -= buff.amount
                print("Reinforcements: Removendo bônus de %d ATK de %s." % [buff.amount, buff.card.name])

                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        reinforcements_active_monsters.clear()


    if castle_walls_active_monsters.size() > 0:
        for buff in castle_walls_active_monsters:
            if buff.card:
                buff.card.def -= buff.amount
                print("Castle Walls: Removendo bônus de %d DEF de %s." % [buff.amount, buff.card.name])

                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        castle_walls_active_monsters.clear()


    if union_attack_active_monsters.size() > 0:
        for buff in union_attack_active_monsters:
            if buff.card:
                buff.card.atk -= buff.amount
                print("Union Attack: Removendo bônus de %d ATK de %s." % [buff.amount, buff.card.name])
                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        union_attack_active_monsters.clear()

    current_phase = TurnPhase.ENEMY
    update_turn_ui()
    start_enemy_turn()

func start_enemy_turn():
    current_turn = Turn.ENEMY
    current_phase = TurnPhase.ENEMY
    enemy_has_played = false

    refill_enemy_hand()
    update_turn_ui()
    update_end_turn_button()


    if EffectManager.has_method("reset_multi_attack_counts"):
        EffectManager.reset_multi_attack_counts()


    if enemy_ai:
        enemy_turn_counter += 1
        enemy_ai.play_turn()
    else:

        print("ERRO: EnemyAI não encontrada, usando sistema antigo")


func end_enemy_turn():
    if game_over:
        return

    if current_phase == TurnPhase.PLAYER:
        return

    if EffectManager:
        EffectManager.update_swords_on_player_turn()

    advance_turn()

func advance_turn():
    current_turn = Turn.PLAYER
    current_phase = TurnPhase.PLAYER
    turn_number += 1


    if EffectManager.has_method("reset_multi_attack_counts"):
        EffectManager.reset_multi_attack_counts()


    if waboku_active_enemy:
        waboku_active_enemy = false
        print("Waboku: Proteção do inimigo expirou.")


    if EffectManager.robbin_goblin_active_player or EffectManager.robbin_goblin_active_enemy:
        EffectManager.robbin_goblin_active_player = false
        EffectManager.robbin_goblin_active_enemy = false
        print("Robbin' Goblin: Efeitos expiraram no fim do turno.")


    if reverse_trap_active_enemy:
        reverse_trap_active_enemy = false
        print("Reverse Trap: Efeito do inimigo expirou.")


    if reinforcements_active_monsters.size() > 0:
        for buff in reinforcements_active_monsters:
            if buff.card:
                buff.card.atk -= buff.amount
                print("Reinforcements: Removendo bônus de %d ATK de %s." % [buff.amount, buff.card.name])

                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        reinforcements_active_monsters.clear()


    if castle_walls_active_monsters.size() > 0:
        for buff in castle_walls_active_monsters:
            if buff.card:
                buff.card.def -= buff.amount
                print("Castle Walls: Removendo bônus de %d DEF de %s." % [buff.amount, buff.card.name])

                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        castle_walls_active_monsters.clear()


    if union_attack_active_monsters.size() > 0:
        for buff in union_attack_active_monsters:
            if buff.card:
                buff.card.atk -= buff.amount
                print("Union Attack: Removendo bônus de %d ATK de %s." % [buff.amount, buff.card.name])
                for slot in player_slots + enemy_slots:
                    if slot.is_occupied and slot.stored_card_data == buff.card:
                        if slot.spawn_point.get_child_count() > 0:
                            slot.spawn_point.get_child(0).update_stats_display()
                        break
        union_attack_active_monsters.clear()


    for slot in player_slots:
        slot.reset_turn_state()
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("set_exhausted"):

                visual.set_exhausted(true)

    for slot in enemy_slots:
        slot.reset_turn_state()
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("set_exhausted"):
                visual.set_exhausted(false)

    for slot in player_spell_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("set_exhausted"):
                visual.set_exhausted(true)

    player_has_played = false
    enemy_has_played = false
    selected_cards.clear()
    pending_card_to_play = null

    refill_player_hand()
    update_turn_ui()
    unlock_player_hand()
    set_end_turn_button_active(false)

func set_end_turn_button_active(is_active: bool):
    var btn = $CanvasLayer / EndTurnButton
    btn.disabled = not is_active
    btn.modulate = Color(1, 1, 1, 1) if is_active else Color(0.5, 0.5, 0.5, 1)
    btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if is_active else Control.CURSOR_ARROW

func update_end_turn_button():
    $CanvasLayer / EndTurnButton.disabled = (current_phase != TurnPhase.PLAYER or not player_has_played)

func lock_player_hand():
    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual is TextureButton:
                card_visual.disabled = true

    remove_used_player_cards()
    selected_cards.clear()
    update_hand_ui()
    set_end_turn_button_active(true)

func unlock_player_hand():
    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual is TextureButton:
                card_visual.disabled = false


func play_selected_cards():
    if game_over or player_has_played or current_phase != TurnPhase.PLAYER or selected_cards.is_empty():
        return

    hide_battle_buttons()
    _temp_intermediate_fusion_results.clear()

    var cards_to_play: Array[CardData] = []
    for entry in selected_cards:
        cards_to_play.append(entry.card)


    if cards_to_play.size() > 1:
        var all_equips = true
        for card in cards_to_play:
            if card.type != "Equip":
                all_equips = false
                break

        if all_equips and player_position == "Attack":
            pending_equip_cards.clear()
            for card in cards_to_play:
                pending_equip_cards.append(card)
            pending_card_to_play = pending_equip_cards[0]
            _enter_equip_targeting_mode()
            return


    var pre_final_card: CardData
    if cards_to_play.size() > 1:
        var current = cards_to_play[0]
        for i in range(1, cards_to_play.size()):
            var next = cards_to_play[i]
            var fused = FusionDatabase.try_fusion([current, next])

            if fused != null:
                current = fused.get_copy()
            else:
                if _is_monster(current) and next.type == "Equip" and _is_valid_equip_target(current, next.id):
                    var equipped = current.get_copy()
                    _apply_equip_bonus(equipped, next.id, true, true)
                    current = equipped
                elif current.type == "Equip" and _is_monster(next) and _is_valid_equip_target(next, current.id):
                    var equipped = next.get_copy()
                    _apply_equip_bonus(equipped, current.id, true, true)
                    current = equipped
                else:
                    current = next
        pre_final_card = current
    else:
        pre_final_card = cards_to_play[0]


    if not _is_monster(pre_final_card):

        var is_fusion_success = (cards_to_play.size() > 1 and pre_final_card.id != cards_to_play[0].id)
        await _execute_spell_trap_play(pre_final_card, is_fusion_success)
        return



    pending_play_position = player_position
    enter_slot_selection_mode()

func _has_valid_equip_target_on_field(is_player: bool, equip_id: int) -> bool:
    "Verifica se há pelo menos um monstro válido para equipamento no campo"
    var slots = player_slots if is_player else enemy_slots

    for slot in slots:
        if slot.is_occupied:
            var monster = slot.stored_card_data
            if monster and _is_valid_equip_target(monster, equip_id):
                return true

    return false

func _execute_spell_trap_play(final_card: CardData, is_fusion_success: bool):
    var slot = _get_free_spell_slot(true, true)
    if slot == null:
        show_battle_buttons()
        return

    var is_activate = (player_position == "Attack")


    if final_card.category == CardData.CardCategory.TRAP and is_activate:
        is_activate = false


    if final_card.type == "Equip" and is_activate:

        if final_card.id in [321, 324, 323, 311, 304]:

            if not _has_monster_on_field(true):

                is_activate = false
                player_position = "Defense"
            elif is_activate:
                pending_card_to_play = final_card
                _enter_equip_targeting_mode()
                return
        else:

            if not _has_valid_equip_target_on_field(true, final_card.id):
                is_activate = false
                player_position = "Defense"
            elif is_activate:
                pending_card_to_play = final_card
                _enter_equip_targeting_mode()
                return


    for i in range(selected_cards.size()):
        var entry = selected_cards[i]
        if entry.card == final_card: continue
        if is_fusion_success or i < selected_cards.size() - 1:
            send_to_graveyard(entry.card, true)


    for card in _temp_intermediate_fusion_results:
        send_to_graveyard(card, true, true)
    _temp_intermediate_fusion_results.clear()

    for entry in selected_cards:
        player_hand[entry.index] = null

    selected_cards.clear()
    update_hand_ui()

    var visual = await spawn_card_on_field(final_card, slot, not is_activate, true, is_fusion_success)
    visual.rotation_degrees = 0
    player_has_played = true


    if is_activate and final_card.id in RITUAL_CARDS:
        await get_tree().create_timer(0.5).timeout
        play_ritual_animation()

    if not is_activate and final_card.category == CardData.CardCategory.TRAP:
        print("[TrapSet] Trap corretamente setada face-down: ", final_card.name)


    track_card_used()
    unlock_cards_after_play()


    if is_activate:
        await get_tree().create_timer(0.5).timeout
        await _resolve_magic_effect(slot)

    set_end_turn_button_active(true)

func _has_monster_on_field(is_player: bool) -> bool:
    var slots = player_slots if is_player else enemy_slots
    return _count_occupied_slots(slots) > 0


func track_card_used():
    cards_used_this_duel += 1
    print("Cartas usadas: ", cards_used_this_duel)

func calculate_total_cards_played_by_player() -> int:
    "\n    Calcula o total de cartas jogadas pelo jogador na partida.\n    Inclui:\n    1. Cartas no cemitério do jogador\n    2. Cartas no campo do jogador (monstros, spells, traps)\n    3. Cartas removidas por efeitos (se houver tracking adicional)\n    "






    var total_cards = 0


    total_cards += player_graveyard.size()



    for slot in player_slots:
        if slot.is_occupied and slot.stored_card_data != null:
            total_cards += 1


    for slot in player_spell_slots:
        if slot.is_occupied and slot.stored_card_data != null:
            total_cards += 1

    print("Total de cartas jogadas pelo jogador: ", total_cards)
    print("  - Cemitério: ", player_graveyard.size())
    print("  - Campo (monstros): ", _count_occupied_slots(player_slots))
    print("  - Campo (spells/traps): ", _count_occupied_slots(player_spell_slots))

    return total_cards


func enter_slot_selection_mode():
    is_selecting_slot = true
    hide_battle_buttons()

    for slot in player_slots:
        slot.set_selectable(true)

        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual:
                visual.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _apply_slot_selection_effect(slot, enable: bool):
    "Aplica ou remove efeito visual de seleção no slot"
    if enable:

        if not slot.has_node("SelectionOutline"):
            var outline = Control.new()
            outline.name = "SelectionOutline"
            outline.mouse_filter = Control.MOUSE_FILTER_IGNORE


            var color_rect = ColorRect.new()
            color_rect.color = Color(0.0, 1.0, 0.0, 0.392)
            color_rect.size = slot.size + Vector2(5, 5)
            color_rect.position = Vector2(0, 0)
            color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


            outline.add_child(color_rect)


            slot.add_child(outline)


            var tween = create_tween()
            tween.set_loops()
            tween.set_trans(Tween.TRANS_SINE)
            tween.tween_property(color_rect, "modulate:a", 0.1, 0.5)
            tween.tween_property(color_rect, "modulate:a", 0.3, 0.5)




        slot.get_node("SelectionOutline").visible = true

    else:

        if slot.has_node("SelectionOutline"):
            var outline = slot.get_node("SelectionOutline")
            outline.visible = false


            if outline.get_child_count() > 0:
                var color_rect = outline.get_child(0)
                if color_rect.has_method("stop"):
                    color_rect.stop()

func exit_slot_selection_mode():
    is_selecting_slot = false
    pending_card_to_play = null
    pending_play_position = ""

    for slot in player_slots:
        slot.set_selectable(false)
        slot.modulate = Color.WHITE

        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual:
                visual.mouse_default_cursor_shape = Control.CURSOR_ARROW


    selected_cards.clear()
    hide_battle_buttons()


    update_hand_ui()


    if not player_has_played:
        print("Modo de seleção de slot cancelado - Pode selecionar nova carta")
    else:
        print("Modo de seleção de slot cancelado - Já jogou esta turno")

func reset_card_selection():
    "Redefine completamente a seleção de cartas"
    selected_cards.clear()
    selected_indices.clear()


    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual.has_method("reset_selection_visual"):
                card_visual.reset_selection_visual()
            if card_visual.has_method("hide_action_buttons"):
                card_visual.hide_action_buttons()


    hide_battle_buttons()


    update_hand_ui()

func _on_player_slot_clicked(slot_instance):
    if _is_processing_action or is_processing_trap: return

    print("_on_player_slot_clicked - Estado atual: ", current_game_state)


    if current_game_state == GameState.STOP_DEFENSE_TARGETING:
        print("Stop Defense targeting ativo")
        print("pending_stop_defense_target_player: ", pending_stop_defense_target_player)
        print("slot_instance.is_player_slot: ", slot_instance.is_player_slot)


        if pending_stop_defense_target_player and slot_instance.is_player_slot:
            print("Slot do jogador selecionado para Stop Defense")
            _handle_stop_defense_target_selection(slot_instance)
        else:
            print("Slot inválido para Stop Defense")
        return


    if is_selecting_slot:
        print("Modo de seleção de slot para invocação")
        await _handle_monster_summon(slot_instance)
        return


    if current_game_state == GameState.EQUIP_TARGETING:
        print("Modo de seleção para equipamento")
        _handle_equip_activation(slot_instance)
        return

    print("Clique em slot do jogador sem modo especial ativo")

func _handle_monster_summon(slot_instance):
    if _is_processing_action:
        return


    if slot_instance in player_spell_slots:
        print("TENTATIVA INVÁLIDA: Tentando jogar monstro em um slot de spell/trap!")
        return

    _is_processing_action = true

    _apply_slot_selection_effect(slot_instance, false)


    _temp_intermediate_fusion_results.clear()

    var cards_to_play: Array[CardData] = []
    for entry in selected_cards:
        cards_to_play.append(entry.card)

    if cards_to_play.is_empty():
        exit_slot_selection_mode()
        _is_processing_action = false
        return


    if cards_to_play.size() > 1:
        var all_equips = true
        for card in cards_to_play:
            if card.type != "Equip":
                all_equips = false
                break

        if all_equips and pending_play_position == "Attack":
            pending_equip_cards.clear()
            for card in cards_to_play:
                pending_equip_cards.append(card)
            pending_card_to_play = pending_equip_cards[0]
            exit_slot_selection_mode()
            _is_processing_action = false
            _enter_equip_targeting_mode()
            return


    _temp_fusion_cards = cards_to_play.duplicate()


    var pre_final_card: CardData
    if cards_to_play.size() > 1:
        var current = cards_to_play[0]
        for i in range(1, cards_to_play.size()):
            var next = cards_to_play[i]
            var fused = FusionDatabase.try_fusion([current, next])

            if fused != null:
                current = fused.get_copy()
            else:
                if _is_monster(current) and next.type == "Equip" and _is_valid_equip_target(current, next.id):
                    var equipped = current.get_copy()
                    _apply_equip_bonus(equipped, next.id, true, true)
                    current = equipped
                elif current.type == "Equip" and _is_monster(next) and _is_valid_equip_target(next, current.id):
                    var equipped = next.get_copy()
                    _apply_equip_bonus(equipped, current.id, true, true)
                    current = equipped
                else:
                    current = next
        pre_final_card = current
    else:
        pre_final_card = cards_to_play[0]


    if not _is_monster(pre_final_card):
        exit_slot_selection_mode()
        _is_processing_action = false
        var is_fusion_success = (cards_to_play.size() > 1 and pre_final_card.id != cards_to_play[0].id)
        await _execute_spell_trap_play(pre_final_card, is_fusion_success)
        return




    if slot_instance.is_occupied:
        var field_card = slot_instance.stored_card_data
        _temp_fusion_cards.insert(0, field_card)
        send_to_graveyard(field_card, true, true)

    var is_defense = (pending_play_position == "Defense")
    var force_reveal = (_temp_fusion_cards.size() > 1)


    var final_card: CardData
    if _temp_fusion_cards.size() > 1:

        final_card = await chain_fusion(_temp_fusion_cards)
    else:

        final_card = _temp_fusion_cards[0]


    var input_monster_ids = []
    for card in _temp_fusion_cards:
        if _is_monster(card):
            input_monster_ids.append(card.id)

    var show_fusion_frame = false

    if _temp_fusion_cards.size() > 1:
        if not (final_card.id in input_monster_ids):
            show_fusion_frame = true
        else:

            var original_db_card = CardDatabase.get_card(final_card.id)
            if final_card.atk != original_db_card.atk or final_card.def != original_db_card.def:
                pass

    var is_monster = final_card.category <= 8
    print("[FusionFix] Result: ", final_card.name, " | Monster: ", is_monster, " | ForceReveal: ", force_reveal)


    var hand_entries = selected_cards.duplicate()


    for entry in hand_entries:
        player_hand[entry.index] = null

    selected_cards.clear()
    update_hand_ui()




    var is_fusion = (_temp_fusion_cards.size() > 1)

    for i in range(hand_entries.size()):
        var card = hand_entries[i].card


        if not is_fusion and card == pending_card_to_play: continue
        if card.id == final_card.id: continue


        if is_fusion or i < hand_entries.size() - 1:
            send_to_graveyard(card, true)


    for card in _temp_intermediate_fusion_results:
        send_to_graveyard(card, true, true)
    _temp_intermediate_fusion_results.clear()


    await spawn_card_on_field(final_card, slot_instance, is_defense, true, show_fusion_frame, force_reveal)
    player_has_played = true



    track_card_used()
    _temp_fusion_cards.clear()
    exit_slot_selection_mode()
    unlock_cards_after_play()
    set_end_turn_button_active(true)
    _is_processing_action = false

func _handle_equip_activation(slot_instance):
    if _is_processing_action or is_processing_trap: return

    if not slot_instance.is_occupied or pending_card_to_play == null:
        _cancel_equip_targeting()
        return

    _is_processing_action = true

    var target_monster = slot_instance.stored_card_data

    if _is_valid_equip_target(target_monster, pending_card_to_play.id):

        var equips_to_apply: Array[CardData] = []
        if pending_equip_cards.size() > 0:
            equips_to_apply = pending_equip_cards.duplicate()
        else:
            equips_to_apply = [pending_card_to_play]


        if activating_equip_from_field_slot:
            var spell_slot = activating_equip_from_field_slot
            var visual_spell = spell_slot.spawn_point.get_child(0) if spell_slot.spawn_point.get_child_count() > 0 else null


            if visual_spell and visual_spell.has_method("set_face_down"):
                visual_spell.set_face_down(false)
            if visual_spell:
                visual_spell.rotation_degrees = 0


            await get_tree().create_timer(0.5).timeout
            if visual_spell:
                await _apply_magic_activation_glow(visual_spell)


            _apply_equip_bonus(target_monster, pending_card_to_play.id, true)


            if spell_slot and spell_slot.is_occupied:
                _destroy_card(spell_slot)


        else:

            for entry in selected_cards:
                 player_hand[entry.index] = null
            selected_cards.clear()
            update_hand_ui()


            for equip_card in equips_to_apply:

                var spell_slot = _get_free_spell_slot(true, true)

                if spell_slot:

                    var visual_spell = await spawn_card_on_field(equip_card, spell_slot, false, true)
                    visual_spell.rotation_degrees = 0


                    await get_tree().create_timer(0.5).timeout
                    await _resolve_magic_effect(spell_slot)


                    if _is_valid_equip_target(target_monster, equip_card.id):
                        _apply_equip_bonus(target_monster, equip_card.id, true)


                    if spell_slot.is_occupied:
                        _destroy_card(spell_slot)
                else:

                    if _is_valid_equip_target(target_monster, equip_card.id):
                        _apply_equip_bonus(target_monster, equip_card.id, true)
                    send_to_graveyard(equip_card, true)


        if activating_equip_from_field_slot:
            activating_equip_from_field_slot = null

        pending_equip_cards.clear()
        player_has_played = true
        unlock_cards_after_play()
        set_end_turn_button_active(true)
        _cancel_equip_targeting()

        _is_processing_action = false


func set_all_cards_exhausted(exhausted: bool):
    "Define estado exhausted para todas as cartas do jogador"


    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):
                card_visual.set_exhausted(exhausted)


    for slot in player_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):
                card_visual.set_exhausted(exhausted)


    for slot in player_spell_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):
                card_visual.set_exhausted(exhausted)

func unlock_cards_after_play():
    "Libera cartas após o jogador jogar uma carta"

    for wrapper in $PlayerArea / Hand.get_children():
        if wrapper.get_child_count() > 0:
            var card_visual = wrapper.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):
                card_visual.set_exhausted(false)

    for slot in player_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):

                if "has_attacked_this_turn" in slot and slot.has_attacked_this_turn:
                    pass
                else:
                    card_visual.set_exhausted(false)

    for slot in player_spell_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual and card_visual.has_method("set_exhausted"):
                card_visual.set_exhausted(false)


func _enter_equip_targeting_mode():
    current_game_state = GameState.EQUIP_TARGETING
    hide_battle_buttons()


    var has_valid_target = false

    for slot in player_slots:
        if slot.is_occupied:
            var monster = slot.stored_card_data
            var is_valid = _is_valid_equip_target(monster, pending_card_to_play.id)

            slot.modulate = Color(0, 1, 0) if is_valid else Color(0.3, 0.3, 0.3)
            slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if is_valid else Control.CURSOR_ARROW

            if is_valid:
                has_valid_target = true


    if not has_valid_target:
        print("Não há monstros válidos para equipar")
        _cancel_equip_targeting()

func _cancel_equip_targeting():
    current_game_state = GameState.MAIN_PHASE
    pending_card_to_play = null
    pending_equip_cards.clear()
    activating_equip_from_field_slot = null


    for slot in player_slots:
        slot.modulate = Color.WHITE
        slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            visual.mouse_default_cursor_shape = Control.CURSOR_ARROW


    reset_card_selection()


    if not player_has_played:
        print("Modo de seleção de equip cancelado - Pode selecionar nova carta")
    else:
        print("Modo de seleção de equip cancelado")

func _is_valid_equip_target(monster: CardData, equip_id: int) -> bool:
    return EffectManager.is_valid_equip_target(monster, equip_id)



func _check_and_activate_reverse_trap(is_player_buffing: bool, is_field_trigger: bool = false) -> void :

    var opponent_traps = TrapManager.enemy_traps if is_player_buffing else TrapManager.player_traps
    var reverse_trap: TrapData = null

    for trap in opponent_traps:
        if trap.id == 689:
            reverse_trap = trap
            break

    if reverse_trap:
        print("Reverse Trap: Ativada! Invertendo todos os buffs/debuffs!")


        if is_player_buffing:
            reverse_trap_active_player = true
            if is_field_trigger:
                reverse_trap_field_player = true
        else:
            reverse_trap_active_enemy = true
            if is_field_trigger:
                reverse_trap_field_enemy = true


        is_processing_trap = true


        if reverse_trap.owner.is_player_slot:
            reveal_player_card_in_slot(reverse_trap.owner)
        else:
            reveal_enemy_card_in_slot(reverse_trap.owner)


        var card_visual = reverse_trap.owner.spawn_point.get_child(0) if reverse_trap.owner.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await _apply_magic_activation_glow(card_visual)

        await get_tree().create_timer(0.5).timeout


        TrapManager.remove_trap(reverse_trap, null, null)
        _destroy_card(reverse_trap.owner)


        EventBus.trap_consumed.emit(reverse_trap, null, null)

        await get_tree().create_timer(0.2).timeout
        is_processing_trap = false

func _apply_equip_bonus(monster: CardData, equip_id: int, _is_player_applying: bool = true, is_preview: bool = false):
    var bonus = EffectManager.get_equip_bonus(equip_id)

    if equip_id == 318:
        print("Elegant Egotist equipada em Harpy Lady (Aguardando invocação...)!")
        if not monster in elegant_egotist_equipped_monsters:
            elegant_egotist_equipped_monsters.append(monster)
        return

    if bonus.atk != 0 or bonus.def != 0:



        if not is_preview:
            if not reverse_trap_active_player and not reverse_trap_active_enemy:
                _check_and_activate_reverse_trap(_is_player_applying)


        var reverse_active = reverse_trap_active_player if _is_player_applying else reverse_trap_active_enemy

        if reverse_active:
            print("Reverse Trap: Invertendo bônus de equipamento (%d ATK, %d DEF)!" % [bonus.atk, bonus.def])
            bonus.atk = - bonus.atk
            bonus.def = - bonus.def


        var atk_before = monster.atk
        var def_before = monster.def


        monster.atk += bonus.atk
        if monster.atk < 0: monster.atk = 0

        monster.def += bonus.def
        if monster.def < 0: monster.def = 0


        if equip_id == 311:
            if not monster in black_pendant_equipped_monsters:
                black_pendant_equipped_monsters.append(monster)
                print("Black Pendant equipado em: ", monster.name)


        if equip_id == EffectManager.EQUIP_METALMORPH or equip_id == EffectManager.EQUIP_RARE_METALMORPH:
            if not monster in metalmorph_equipped_monsters:
                metalmorph_equipped_monsters.append(monster)
                print("Metalmorph equipado em: ", monster.name)

        _update_visual_after_equip_and_field(monster, atk_before, def_before)

func _create_harpy_lady_copies(original_monster: CardData, is_player_controller: bool):
    if original_monster.id != HARPY_LADY_ID:
        return


    var slots_to_check = player_slots if is_player_controller else enemy_slots
    var owner_is_player = is_player_controller


    var empty_slots = []
    for slot in slots_to_check:
        if not slot.is_occupied:
            empty_slots.append(slot)


    var copies_to_create = min(2, empty_slots.size())

    if copies_to_create == 0:
        print("Elegant Egotist equipada, mas não há slots vazios para criar cópias")
        return

    for i in range(copies_to_create):
        var slot = empty_slots[i]
        var harpy_lady_card = CardDatabase.get_card(HARPY_LADY_ID)
        if harpy_lady_card:
            var copy = harpy_lady_card.get_copy() if harpy_lady_card.has_method("get_copy") else harpy_lady_card


            await spawn_card_on_field(copy, slot, false, owner_is_player, false)
            print("Cópia ", i + 1, " de Harpy Lady criada no campo do ", "Jogador" if owner_is_player else "Inimigo")


    await get_tree().create_timer(0.5).timeout
    print("Elegant Egotist: ", copies_to_create, " cópias de Harpy Lady criadas!")

func _update_visual_after_equip_and_field(monster: CardData, original_atk: int = -1, original_def: int = -1):
    for slot in player_slots + enemy_slots:
        if slot.is_occupied and slot.stored_card_data == monster:
            var visual = slot.spawn_point.get_child(0)


            if original_atk != -1 and original_def != -1:

                visual.animate_stats_bonus(monster.atk, monster.def, original_atk, original_def)
            else:


                visual.animate_stats_bonus(monster.atk, monster.def)


func _on_card_activate_requested(_visual_sender, slot_node):
    if _is_processing_action or is_processing_trap: return
    var card = slot_node.stored_card_data
    if card == null: return

    if slot_node.spawn_point.get_child_count() > 0:
        var visual_card = slot_node.spawn_point.get_child(0)
        if "action_buttons" in visual_card:
            visual_card.action_buttons.visible = false

    if card.type == "Equip":

        if not _has_valid_equip_target_on_field(true, card.id):

            print("Não há monstros válidos para equipar esta carta")
            return

        _play_confirm_sound()
        activating_equip_from_field_slot = slot_node
        pending_card_to_play = card
        reveal_player_card_in_slot(slot_node)
        _enter_equip_targeting_mode()
        return


    if card.id == 320:
        _play_confirm_sound()
        stop_defense_activation_slot = slot_node
        reveal_player_card_in_slot(slot_node)
        start_stop_defense_targeting(false)
        return


    if card.category != CardData.CardCategory.TRAP:
        _play_confirm_sound()
        reveal_player_card_in_slot(slot_node)
        await get_tree().create_timer(0.5).timeout
        await _resolve_magic_effect(slot_node)


func start_stop_defense_targeting(target_is_player: bool):
    "\n    Inicia o modo de seleção de alvo para Stop Defense\n    target_is_player: true = alvo é jogador, false = alvo é inimigo\n    "



    print("DuelManager: Iniciando seleção de alvo para Stop Defense")
    print("Alvo: ", "Jogador" if target_is_player else "Inimigo")

    pending_stop_defense_target_player = target_is_player
    current_game_state = GameState.STOP_DEFENSE_TARGETING


    hide_battle_buttons()


    _highlight_defense_monsters_for_stop_defense(target_is_player)

func _highlight_defense_monsters_for_stop_defense(target_is_player: bool):


    var target_slots = player_slots if target_is_player else enemy_slots

    print("Destacando monstros em defesa...")
    print("Total de slots: ", target_slots.size())

    for slot in target_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            var card_data = slot.stored_card_data


            var is_in_defense = _is_card_in_defense_for_stop_defense(slot, visual, target_is_player)

            print("Slot ", slot.slot_index, " - ", card_data.name)
            print("  Em defesa: ", is_in_defense)
            print("  Rotação: ", visual.rotation_degrees)

            if is_in_defense:



                visual.modulate = Color(0, 1, 0)
                visual.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
                print("  -> DESTACADO em verde")
            else:



                visual.modulate = Color(0.3, 0.3, 0.3)
                visual.mouse_default_cursor_shape = Control.CURSOR_ARROW
                print("  -> ESCURECIDO (não em defesa)")
        else:


            slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
            print("Slot ", slot.slot_index, " - Vazio")

func _is_card_in_defense_for_stop_defense(slot, visual, target_is_player: bool) -> bool:
    "\n    Verifica se uma carta está em modo de defesa\n    Considera tanto virado para baixo quanto rotação de defesa\n    "



    if not visual: return false


    var is_face_down = false
    if visual.has_method("is_face_down"):
        is_face_down = visual.is_face_down()


    var rotation_in_defense = false

    if target_is_player:

        rotation_in_defense = (visual.rotation_degrees == 90)
    else:

        rotation_in_defense = (visual.rotation_degrees == -90)


    return is_face_down or rotation_in_defense

func _resolve_magic_effect(slot_node):
    var card = slot_node.stored_card_data
    if card == null: return

    var is_player_spell = slot_node.is_player_slot
    var card_visual = slot_node.spawn_point.get_child(0) if slot_node.spawn_point.get_child_count() > 0 else null

    if _is_processing_action:
        return

    _is_processing_action = true




    if TrapManager.has_method("check_magic_negation") and await TrapManager.check_magic_negation(card, is_player_spell):
        print("DuelManager: Ativação da mágica ", card.name, " foi NEGADA!")


        if card_visual and card_visual.has_method("set_face_down"):
            card_visual.set_face_down(false)

        await get_tree().create_timer(1.0).timeout
        _destroy_card(slot_node)
        _is_processing_action = false
        return



    if card_visual:
        await _apply_magic_activation_glow(card_visual)


    await EffectManager.resolve_effect(card, is_player_spell)

    if slot_node.is_occupied and card_visual:
        await get_tree().create_timer(0.5).timeout
        _destroy_card(slot_node)

    _is_processing_action = false

func _apply_magic_activation_glow(card_visual):
    "Aplica um efeito de brilho branco na carta mágica quando ativada"
    if not card_visual or not is_instance_valid(card_visual):
        return

    print("Aplicando brilho de ativação na carta mágica")


    var original_modulate = card_visual.modulate
    var original_scale = card_visual.scale

    _play_activate_sound()


    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)


    tween.tween_property(card_visual, "modulate", Color(3, 3, 3, 1), 0.2)


    tween.tween_property(card_visual, "scale", original_scale * 1.2, 0.2)

    await tween.finished


    tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_IN)


    tween.tween_property(card_visual, "modulate", original_modulate, 0.3)


    tween.tween_property(card_visual, "scale", original_scale, 0.3)

    await tween.finished

func execute_dark_hole_effect(spell_slot = null):
    print("Executando efeito Dark Hole...")


    _show_dark_hole_animation()


    _destroy_all_cards_on_field()


    if spell_slot and spell_slot.is_occupied:
        await get_tree().create_timer(0.5).timeout
        _destroy_card(spell_slot)

func _show_dark_hole_animation():
    "Mostra a animação do buraco negro"
    print("Mostrando animação Dark Hole...")


    var dark_hole_node = $Battlefield / DarkHole
    if not dark_hole_node:
        print("ERRO: Nó DarkHole não encontrado!")
        return


    dark_hole_node.visible = true
    dark_hole_node.modulate = Color(1, 1, 1, 0)

    _play_darkhole_sound()


    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)



    var original_rotation = dark_hole_node.rotation_degrees
    tween.tween_property(dark_hole_node, "rotation_degrees", original_rotation + 360, 2.0)


    tween.tween_property(dark_hole_node, "modulate:a", 0.9, 0.5)


    var original_scale = dark_hole_node.scale


    await tween.finished


    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_IN)
    tween.tween_property(dark_hole_node, "modulate:a", 0.0, 0.5)

    await tween.finished


    dark_hole_node.scale = original_scale
    dark_hole_node.rotation_degrees = original_rotation
    dark_hole_node.visible = false

    print("Animação Dark Hole concluída.")

func _destroy_all_cards_on_field():
    "Destroi TODAS as cartas do campo (monstros e spells/traps)"
    print("Destruindo todas as cartas do campo...")


    var all_slots = player_slots + enemy_slots


    var destroyed_count = 0


    for slot in all_slots:
        if slot.is_occupied:
            destroyed_count += 1


            if slot.spawn_point.get_child_count() > 0:
                var card_visual = slot.spawn_point.get_child(0)


                var tween = create_tween()
                tween.set_parallel(true)
                tween.tween_property(card_visual, "modulate", Color(0.3, 0.3, 0.3, 0.7), 0.3)
                tween.tween_property(card_visual, "rotation_degrees", card_visual.rotation_degrees + 720, 0.3)
                tween.tween_property(card_visual, "scale", card_visual.scale * 0.0, 0.3)

                await tween.finished


            _destroy_card(slot)


            await get_tree().create_timer(0.1).timeout

    print("Dark Hole: ", destroyed_count, " cartas destruídas.")

func _get_free_spell_slot(is_player: bool, force_replace: bool = false) -> Node:
    var slots = player_spell_slots if is_player else enemy_spell_slots
    for slot in slots:
        if not slot.is_occupied:
            return slot

    if force_replace and slots.size() > 0:

        var target_slot = slots[0]
        print("Todos os slots de spell ocupados! Substituindo a carta do slot 1.")








        _destroy_card(target_slot)
        return target_slot

    return null


func set_field_type(new_field_name: String):

    if reverse_trap_field_player:
        reverse_trap_field_player = false
        print("Reverse Trap: Inversão de campo do jogador expirou (novo Field).")
    if reverse_trap_field_enemy:
        reverse_trap_field_enemy = false
        print("Reverse Trap: Inversão de campo do inimigo expirou (novo Field).")

    if reverse_trap_active_player:
        reverse_trap_active_player = false
    if reverse_trap_active_enemy:
        reverse_trap_active_enemy = false

    current_field_type = new_field_name

    if field_label:
        field_label.text = new_field_name

    if forest_bg:
        forest_bg.visible = false
    if wasteland_bg:
        wasteland_bg.visible = false
    if mountain_bg:
        mountain_bg.visible = false
    if sogen_bg:
        sogen_bg.visible = false
    if umi_bg:
        umi_bg.visible = false
    if yami_bg:
        yami_bg.visible = false
    if gaia_power_bg:
        gaia_power_bg.visible = false
    if sanctuary_in_the_sky_bg:
        sanctuary_in_the_sky_bg.visible = false
    if jurassic_world_bg:
        jurassic_world_bg.visible = false

    var active_bg = null
    match new_field_name:
        "Forest":
            if forest_bg:
                active_bg = forest_bg
        "Wasteland":
            if wasteland_bg:
                active_bg = wasteland_bg
        "Mountain":
            if mountain_bg:
                active_bg = mountain_bg
        "Sogen":
            if sogen_bg:
                active_bg = sogen_bg
        "Umi":
            if umi_bg:
                active_bg = umi_bg
        "Yami":
            if yami_bg:
                active_bg = yami_bg
        "Gaia Power":
            if gaia_power_bg:
                active_bg = gaia_power_bg
        "Sanctuary in the Sky":
            if sanctuary_in_the_sky_bg:
                active_bg = sanctuary_in_the_sky_bg
        "Jurassic World":
            if jurassic_world_bg:
                active_bg = jurassic_world_bg

    _play_setfield_sound()

    if active_bg:
        active_bg.visible = true
        active_bg.modulate = Color(5, 5, 5)
        var tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_OUT)
        tween.tween_property(active_bg, "modulate", Color.WHITE, 3)

    _refresh_all_monsters_stats()

func _refresh_all_monsters_stats():
    for slot in player_slots + enemy_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card = slot.stored_card_data


            if typeof(card.field_bonus_applied) == TYPE_DICTIONARY and (card.field_bonus_applied.atk != 0 or card.field_bonus_applied.def != 0):
                card.atk -= card.field_bonus_applied.atk
                card.def -= card.field_bonus_applied.def
                card.field_bonus_applied = {"atk": 0, "def": 0}


            _apply_field_bonus_to_card(card, slot.is_player_slot)
            slot.spawn_point.get_child(0).update_stats_display()

func _apply_field_bonus_to_card(monster: CardData, is_player_monster: bool = true):
    if typeof(monster.field_bonus_applied) == TYPE_DICTIONARY and (monster.field_bonus_applied.atk != 0 or monster.field_bonus_applied.def != 0): return

    var bonus = EffectManager.get_field_bonus(monster, current_field_type)
    if bonus.atk != 0 or bonus.def != 0:

        if not reverse_trap_field_player and not reverse_trap_field_enemy:
            if not reverse_trap_active_player and not reverse_trap_active_enemy:
                _check_and_activate_reverse_trap(is_player_monster, true)


        var reverse_active = (
            (reverse_trap_field_player or reverse_trap_active_player) if is_player_monster
            else (reverse_trap_field_enemy or reverse_trap_active_enemy)
        )

        var applied_atk_bonus = bonus.atk
        var applied_def_bonus = bonus.def

        if reverse_active:
            print("Reverse Trap: Invertendo bônus de campo!")
            applied_atk_bonus = - applied_atk_bonus
            applied_def_bonus = - applied_def_bonus

        monster.atk += applied_atk_bonus
        monster.def += applied_def_bonus
        monster.field_bonus_applied = {"atk": applied_atk_bonus, "def": applied_def_bonus}

        _update_visual_after_equip_and_field(monster)


func get_effective_atk(card: CardData, opponent: CardData) -> int:
    if card == null: return 0
    var _key = randi()
    var base_val = max(0, card.atk)
    var final_val = max(0, base_val + get_guardian_bonus(card, opponent))
    var _atk = final_val ^ _key
    return _atk ^ _key

func get_effective_def(card: CardData, opponent: CardData) -> int:
    if card == null: return 0
    var _key = randi()
    var base_val = max(0, card.def)
    var final_val = max(0, base_val + get_guardian_bonus(card, opponent))
    var _def = final_val ^ _key
    return _def ^ _key

func get_guardian_bonus(card: CardData, opponent: CardData) -> int:
    if card == null or opponent == null:
        return 0

    var bonus = 0
    if guardian_advantage.has(card.guardian_star):
        if guardian_advantage[card.guardian_star] == opponent.guardian_star:
            bonus = 500

    var _key = randi()
    var _obs_bonus = bonus ^ _key
    return _obs_bonus ^ _key


func chain_fusion(cards: Array) -> CardData:
    var current_card: CardData = cards[0]

    for i in range(1, cards.size()):
        var next_card: CardData = cards[i]
        var fused: CardData = FusionDatabase.try_fusion([current_card, next_card])

        if fused != null:

            await _play_fusion_cutscene(current_card, next_card, fused, true)


            if not (current_card in cards):
                _temp_intermediate_fusion_results.append(current_card)

            current_card = fused.get_copy()
        else:

            var monster = null
            var equip_id = -1
            var is_valid_equip = false

            if _is_monster(current_card) and next_card.type == "Equip":
                monster = current_card if current_card.is_copy else current_card.get_copy()
                equip_id = next_card.id
            elif current_card.type == "Equip" and _is_monster(next_card):
                monster = next_card.get_copy()
                equip_id = current_card.id

            if monster != null and _is_valid_equip_target(monster, equip_id):

                var result_monster = monster.get_copy()
                _apply_equip_bonus(result_monster, equip_id, true)

                await _play_fusion_cutscene(current_card, next_card, result_monster, true)

                current_card = result_monster
                is_valid_equip = true

            if not is_valid_equip:

                await _play_fusion_cutscene(current_card, next_card, next_card, false)
                current_card = next_card

    return current_card

func _is_monster(card: CardData) -> bool:
    return card.category in [
        CardData.CardCategory.NORMAL_MONSTER, 
        CardData.CardCategory.EFFECT_MONSTER, 
        CardData.CardCategory.FUSION_MONSTER, 
        CardData.CardCategory.RITUAL_MONSTER, 
        CardData.CardCategory.SYNCHRO_MONSTER, 
        CardData.CardCategory.XYZ_MONSTER, 
        CardData.CardCategory.PENDULUM_MONSTER, 
        CardData.CardCategory.LINK_MONSTER
    ]


func reveal_player_card_in_slot(slot):
    if slot.spawn_point.get_child_count() > 0:
        var visual = slot.spawn_point.get_child(0)
        if visual.has_method("set_face_down"):
            visual.set_face_down(false)

func reveal_enemy_card_in_slot(slot):
    if slot.spawn_point.get_child_count() > 0:
        var visual = slot.spawn_point.get_child(0)
        if visual.has_method("set_face_down"):
            visual.set_face_down(false)

func _has_card_back(visual_node) -> bool:
    if "is_face_down" in visual_node:
        return visual_node.is_face_down
    return false


func has_active_kuriboh(is_player: bool) -> bool:
    var slots = player_slots if is_player else enemy_slots

    for slot in slots:
        if slot.is_occupied:
            var card_data = slot.stored_card_data
            if card_data and card_data.id == KURIBOH_ID:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down"):
                    return not visual.is_face_down
                else:

                    return true

    return false


func check_game_over():
    if player_lp <= 0:
        player_lp = 0
        $ResultLabel.text += "\n\nGAME OVER"
        game_over_loss("You Lose")
    elif enemy_lp <= 0:
        enemy_lp = 0
        $ResultLabel.visible = false
        $ResultLabel.text += "\n\nYOU WIN!"
        game_over_win("Enemy LP reached 0")

func end_game():
    if game_over: return
    game_over = true


    Engine.time_scale = 1.0

    EffectManager.reset_swords_of_revealing_light()

    hide_battle_buttons()
    if has_node("CanvasLayer/EndTurnButton"):
        $CanvasLayer / EndTurnButton.disabled = true

    $ResultLabel.visible = true
    $ResultLabel.move_to_front()

func game_over_win(reason: String):
    if game_over: return
    game_over = true

    $ResultLabel.visible = false
    $ResultLabel.text = "VICTORY\n" + reason
    $ResultLabel.modulate = Color(0, 1, 0)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if selected_enemy_deck_key != "":
            global.register_enemy_win(selected_enemy_deck_key)


    var result = _process_victory_rewards()

    end_game()


    show_victory_screen(result["score_data"], result["drop_result"])

func game_over_loss(reason: String):
    if game_over: return
    game_over = true

    $ResultLabel.visible = false
    $ResultLabel.text = "DEFEAT\n" + reason
    $ResultLabel.modulate = Color(1, 0, 0)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if selected_enemy_deck_key != "":
            global.register_enemy_loss(selected_enemy_deck_key)

    if player_lp > 0:
        player_lp = 0
        update_lp_ui()

    end_game()


    show_defeat_screen(reason)

func show_defeat_screen(reason: String = ""):

    if victory_screen and victory_screen.visible:
        victory_screen.visible = false
    print("Mostrando tela de derrota")


    defeat_title_label.text = "DEFEAT"

    var message = "No Rewards"
    if reason != "":
        message = reason + "\n\n" + message

    defeat_message_label.text = message


    if defeat_screen:
        defeat_screen.mouse_filter = Control.MOUSE_FILTER_STOP


    if defeat_continue_btn:
        defeat_continue_btn.disabled = false
        defeat_continue_btn.mouse_filter = Control.MOUSE_FILTER_STOP
        defeat_continue_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


        if not defeat_continue_btn.pressed.is_connected(_on_defeat_continue_pressed):
            defeat_continue_btn.pressed.connect(_on_defeat_continue_pressed)


    _hide_defeat_contents()

    _play_youlose_bgm()


    defeat_screen.visible = true
    defeat_screen.move_to_front()


    _animate_defeat_contents_fade_in()

    print("Tela de derrota mostrada")

func _hide_defeat_contents():
    "Torna todos os conteúdos da tela de derrota invisíveis"
    if defeat_title_label:
        defeat_title_label.modulate = Color(1, 1, 1, 0)
    if defeat_message_label:
        defeat_message_label.modulate = Color(1, 1, 1, 0)
    if defeat_continue_btn:
        defeat_continue_btn.modulate = Color(1, 1, 1, 0)

func _animate_defeat_contents_fade_in():
    "Anima fade-in dos conteúdos da tela de derrota"

    if defeat_animation_tween and defeat_animation_tween.is_valid():
        defeat_animation_tween.kill()


    defeat_animation_tween = create_tween()
    defeat_animation_tween.set_trans(Tween.TRANS_QUAD)
    defeat_animation_tween.set_ease(Tween.EASE_OUT)


    if defeat_title_label:

        defeat_animation_tween.tween_property(defeat_title_label, "modulate:a", 1.0, 0.6)


    if defeat_message_label:
        defeat_animation_tween.tween_property(defeat_message_label, "modulate:a", 1.0, 0.5).set_delay(0.2)


    if defeat_continue_btn:
        defeat_animation_tween.tween_property(defeat_continue_btn, "modulate:a", 1.0, 0.5).set_delay(0.3)

func _process_victory_rewards(score_data: Dictionary = {}, drop_result: EnemyDropSystem.DropResult = null) -> Dictionary:

    var real_cards_used = calculate_total_cards_played_by_player()


    cards_used_this_duel = real_cards_used


    duel_score_system.total_turns = turn_number
    duel_score_system.cards_used = cards_used_this_duel
    duel_score_system.final_lp = player_lp


    if score_data.is_empty():
        score_data = duel_score_system.calculate_score()


    if drop_result == null:
        var rank = score_data["rank"]
        drop_result = enemy_drop_system.calculate_drops(selected_enemy_deck_key, rank)


    enemy_drop_system.apply_drops_to_collection(drop_result)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.wins += 1
        global.save_player_data()


    return {"score_data": score_data, "drop_result": drop_result}

func show_victory_screen(score_data: Dictionary, drop_result: EnemyDropSystem.DropResult = null):

    if defeat_screen and defeat_screen.visible:
        defeat_screen.visible = false


    victory_title_label.text = "VICTORY!"
    victory_rank_label.text = "Rank: " + score_data["rank"]
    victory_score_label.text = "Points: " + str(score_data["total_score"]) + " PTS"
    victory_details_label.text = _format_score_details(score_data["breakdown"])

    if drop_result:

            var drop_system = EnemyDropSystem.new()
            var text = drop_system.get_drop_display_text(drop_result)
            victory_rewards_label.text = text
            print("Texto definido:", text)
    else:
            victory_rewards_label.text = "No rewards"


    if victory_screen:
        victory_screen.mouse_filter = Control.MOUSE_FILTER_STOP


        victory_continue_btn.disabled = false
        victory_continue_btn.mouse_filter = Control.MOUSE_FILTER_STOP
        victory_continue_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


    _hide_victory_contents()

    _play_youwin_bgm()


    victory_screen.visible = true
    victory_screen.move_to_front()


    if drop_result and drop_result.card_ids.size() > 0:
        var cards_grid = $VictoryCanvasLayer / VictoryScreen / VBoxContainer / CardsMiniaturesGrid


        for child in cards_grid.get_children():
            child.queue_free()


        cards_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
        cards_grid.size_flags_vertical = Control.SIZE_SHRINK_CENTER


        cards_grid.columns = min(drop_result.card_ids.size(), 5)


        for card_id in drop_result.card_ids:
            var card_data = CardDatabase.get_card(card_id)

            if card_data:

                var wrapper = Control.new()
                wrapper.custom_minimum_size = Vector2(120, 200)
                wrapper.size = Vector2(120, 200)
                cards_grid.add_child(wrapper)


                var card_visual = card_visual_scene.instantiate()
                wrapper.add_child(card_visual)


                card_visual.scale = Vector2(0.35, 0.35)


                card_visual.set_card_data(card_data, -1)


                card_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
                card_visual.disabled = true


                if card_visual.has_method("set_clickable"):
                    card_visual.set_clickable(false)


                card_visual.queue_redraw()


                if card_id in drop_result.surplus_card_ids:

                    card_visual.modulate = Color(0.3, 0.3, 0.3, 1.0)


                    var overlay = CenterContainer.new()
                    overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
                    overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
                    wrapper.add_child(overlay)

                    var hbox = HBoxContainer.new()
                    hbox.alignment = BoxContainer.ALIGNMENT_CENTER
                    hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
                    hbox.add_theme_constant_override("separation", 4)
                    overlay.add_child(hbox)


                    var gold_label = Label.new()
                    gold_label.text = ""
                    var base_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
                    var font = FontVariation.new()
                    font.base_font = base_font
                    font.spacing_glyph = 1
                    gold_label.add_theme_font_override("font", font)
                    gold_label.add_theme_font_size_override("font_size", 40)
                    gold_label.add_theme_constant_override("outline_size", 10)
                    gold_label.add_theme_color_override("font_outline_color", Color.BLACK)
                    gold_label.add_theme_color_override("font_color", Color.WHITE)
                    gold_label.add_theme_constant_override("margin_top", 20)
                    gold_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
                    hbox.add_child(gold_label)


                    var starchip_icon = TextureRect.new()
                    var starchip_tex = load("res://assets/starchip.png")
                    if starchip_tex:
                        starchip_icon.texture = starchip_tex
                        starchip_icon.custom_minimum_size = Vector2(60, 60)
                        starchip_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                        starchip_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                        starchip_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
                        hbox.add_child(starchip_icon)


    _animate_victory_contents_fade_in()

    print("Tela de vitória mostrada - clique no botão Continue para continuar")

func _hide_victory_contents():
    "Torna todos os conteúdos da tela de vitória invisíveis"
    if victory_title_label:
        victory_title_label.modulate = Color(1, 1, 1, 0)
    if victory_rank_label:
        victory_rank_label.modulate = Color(1, 1, 1, 0)
    if victory_score_label:
        victory_score_label.modulate = Color(1, 1, 1, 0)
    if victory_details_label:
        victory_details_label.modulate = Color(1, 1, 1, 0)
    if victory_rewards_label:
        victory_rewards_label.modulate = Color(1, 1, 1, 0)
    if victory_continue_btn:
        victory_continue_btn.modulate = Color(1, 1, 1, 0)
    if victory_cards_grid:
        victory_cards_grid.modulate = Color(1, 1, 1, 0)

func _animate_victory_contents_fade_in():
    "Anima fade-in dos conteúdos da tela de vitória"

    if victory_animation_tween and victory_animation_tween.is_valid():
        victory_animation_tween.kill()


    victory_animation_tween = create_tween()
    victory_animation_tween.set_trans(Tween.TRANS_CUBIC)
    victory_animation_tween.set_ease(Tween.EASE_OUT)


    if victory_title_label:
        victory_animation_tween.tween_property(victory_title_label, "modulate:a", 1.0, 0.5)


    if victory_rank_label:
        victory_animation_tween.tween_property(victory_rank_label, "modulate:a", 1.0, 0.4).set_delay(0.1)
    if victory_score_label:
        victory_animation_tween.tween_property(victory_score_label, "modulate:a", 1.0, 0.4).set_delay(0.1)
    if victory_details_label:
        victory_animation_tween.tween_property(victory_details_label, "modulate:a", 1.0, 0.4).set_delay(0.2)
    if victory_rewards_label:
        victory_animation_tween.tween_property(victory_rewards_label, "modulate:a", 1.0, 0.4).set_delay(0.2)
    if victory_cards_grid and victory_cards_grid.get_child_count() > 0:
        victory_animation_tween.tween_property(victory_cards_grid, "modulate:a", 1.0, 0.4).set_delay(0.25)
    if victory_continue_btn:
        victory_animation_tween.tween_property(victory_continue_btn, "modulate:a", 1.0, 0.5).set_delay(0.3)

func _format_score_details(breakdown: Dictionary) -> String:
    var text = ""
    text += "Turns: " + str(breakdown["turns"]["value"]) + " -> " + str(breakdown["turns"]["score"]) + " pts\n"
    text += "Cards Used: " + str(breakdown["cards_used"]["value"]) + " -> " + str(breakdown["cards_used"]["score"]) + " pts\n"
    text += "Final LP: " + str(breakdown["final_lp"]["value"]) + " -> " + str(breakdown["final_lp"]["score"]) + " pts"
    return text

func _on_continue_button_pressed():
    print("=== _on_continue_button_pressed CHAMADO ===")


    Engine.time_scale = 1.0

    _play_confirm_sound()


    if victory_animation_tween and victory_animation_tween.is_valid():
        victory_animation_tween.kill()


    victory_screen.visible = false


    _reset_victory_contents_opacity()


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if global.is_campaign_duel:
            print("Vitória na campanha! Avançando passo...")
            if global.campaign_return_step >= 0:
                global.campaign_step = global.campaign_return_step
            else:
                global.campaign_step += 1
            global.campaign_return_step = -1
            global.is_campaign_duel = false



            if has_node("/root/SceneManage"):
                var scene_manager = get_node("/root/SceneManage")
                scene_manager.change_scene("res://scenes/Campaign.tscn", false)
            else:
                get_tree().change_scene_to_file("res://scenes/Campaign.tscn")
            return

    print("Indo para o menu principal...")


    if has_node("/root/SceneManage"):
        var scene_manager = get_node("/root/SceneManage")
        scene_manager.go_back()
    else:

        get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_defeat_continue_pressed():
    print("=== CONTINUAR DA TELA DE DERROTA ===")


    Engine.time_scale = 1.0

    _play_confirm_sound()

    if defeat_animation_tween and defeat_animation_tween.is_valid():
        defeat_animation_tween.kill()


    defeat_screen.visible = false


    _reset_defeat_contents_opacity()


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if global.is_campaign_duel:
            print("Derrota na campanha! Redirecionando para Game Over...")
            global.is_campaign_duel = false
            global.campaign_return_step = -1



            if has_node("/root/SceneManage"):
                var scene_manager = get_node("/root/SceneManage")
                scene_manager.change_scene("res://scenes/GameOver.tscn", false)
            else:
                get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
            return


    if has_node("/root/SceneManage"):
        var scene_manager = get_node("/root/SceneManage")
        scene_manager.go_back()
    else:

        get_tree().change_scene_to_file("res://main_menu.tscn")


func _reset_victory_contents_opacity():
    "Reseta opacidade dos conteúdos da vitória"
    if victory_title_label:
        victory_title_label.modulate = Color(1, 1, 1, 1)
    if victory_rank_label:
        victory_rank_label.modulate = Color(1, 1, 1, 1)
    if victory_score_label:
        victory_score_label.modulate = Color(1, 1, 1, 1)
    if victory_details_label:
        victory_details_label.modulate = Color(1, 1, 1, 1)
    if victory_rewards_label:
        victory_rewards_label.modulate = Color(1, 1, 1, 1)
    if victory_cards_grid:
        victory_cards_grid.modulate = Color(1, 1, 1, 1)
    if victory_continue_btn:
        victory_continue_btn.modulate = Color(1, 1, 1, 1)

func _reset_defeat_contents_opacity():
    "Reseta opacidade dos conteúdos da derrota"
    if defeat_title_label:
        defeat_title_label.modulate = Color(1, 1, 1, 1)
    if defeat_message_label:
        defeat_message_label.modulate = Color(1, 1, 1, 1)
    if defeat_continue_btn:
        defeat_continue_btn.modulate = Color(1, 1, 1, 1)


func _on_surrender_pressed():
    if game_over: return

    _play_confirm_sound()
    if not surrender_pending:
        surrender_pending = true
        surrender_bubble.visible = true

        var mouse_pos = surrender_btn.get_local_mouse_position()
        var bubble_x = mouse_pos.x - (surrender_bubble.size.x / 2)
        var bubble_y = mouse_pos.y - surrender_bubble.size.y - 10
        surrender_bubble.position = Vector2(bubble_x, bubble_y)
    else:
        player_lp = 0
        update_lp_ui()
        $ResultLabel.text = "YOU SURRENDERED"


        game_over_loss("You Surrendered")


func _input(event):
    if game_over: return

    if event is InputEventMouseButton and event.pressed:

        if event.button_index == MOUSE_BUTTON_RIGHT:

            if player_has_played or _is_processing_action:
                return

            if current_game_state == GameState.BATTLE_TARGETING:
                cancel_attack_targeting()


            elif current_game_state == GameState.EQUIP_TARGETING:
                _cancel_equip_targeting()


            elif is_selecting_slot:
                exit_slot_selection_mode()

            elif current_game_state == GameState.STOP_DEFENSE_TARGETING:
                _cancel_stop_defense_targeting()


            elif current_game_state == GameState.MAIN_PHASE:
                var mouse_pos = get_global_mouse_position()
                var clicked_on_card = false


                for wrapper in $PlayerArea / Hand.get_children():
                    if wrapper.get_child_count() > 0:
                        var card_visual = wrapper.get_child(0)
                        if card_visual.get_global_rect().has_point(mouse_pos):
                            clicked_on_card = true
                            break


                if not clicked_on_card:
                    hide_all_card_buttons()


            update_hand_ui()


            get_viewport().set_input_as_handled()
            return


    elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

        var mouse_pos = get_global_mouse_position()
        var clicked_on_card = false


        for wrapper in $PlayerArea / Hand.get_children():
            if wrapper.get_child_count() > 0:
                var card_visual = wrapper.get_child(0)
                if card_visual.get_global_rect().has_point(mouse_pos):
                    clicked_on_card = true
                    break


        if not clicked_on_card:
            for slot in player_slots:
                if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
                    var card_visual = slot.spawn_point.get_child(0)
                    if card_visual.get_global_rect().has_point(mouse_pos):
                        clicked_on_card = true
                        break


        if not clicked_on_card:
            hide_all_card_buttons()


    if event is InputEventMouseButton and event.pressed and surrender_pending:
        var local_mouse = surrender_btn.get_global_mouse_position()
        if not surrender_btn.get_global_rect().has_point(local_mouse):
            surrender_pending = false
            surrender_bubble.visible = false


    if victory_screen.visible and event is InputEventMouseButton and event.pressed:
        print("Clique na tela de vitória em posição:", event.position)


        if victory_continue_btn:
            var button_rect = victory_continue_btn.get_global_rect()
            if button_rect.has_point(event.position):
                print("CLICOU NO BOTÃO CONTINUE!")
                _on_continue_button_pressed()
            else:
                print("Clicou fora do botão")

    _handle_mobile_input(event)

func _handle_mobile_input(event):

    if OS.has_feature("mobile") or OS.has_feature("web") or OS.has_feature("HTML5"):
        if event is InputEventScreenTouch and event.pressed:

            if game_over:
                get_viewport().set_input_as_handled()
                return


            if player_has_played:
                get_viewport().set_input_as_handled()
                return

func _unhandled_input(event):
    if game_over: return


    if event is InputEventMouseButton and event.pressed:

        if event.button_index == MOUSE_BUTTON_RIGHT:

            if player_has_played or _is_processing_action:
                return

            if current_game_state == GameState.BATTLE_TARGETING:
                cancel_attack_targeting()
                get_tree().get_root().set_input_as_handled()


            elif current_game_state == GameState.EQUIP_TARGETING:
                _cancel_equip_targeting()
                get_tree().get_root().set_input_as_handled()


            elif is_selecting_slot:
                exit_slot_selection_mode()
                get_tree().get_root().set_input_as_handled()

            elif current_game_state == GameState.STOP_DEFENSE_TARGETING:
                _cancel_stop_defense_targeting()
                get_tree().get_root().set_input_as_handled()


        elif event.button_index == MOUSE_BUTTON_LEFT:

            await get_tree().process_frame

            var mouse_pos = get_global_mouse_position()
            var clicked_on_any_card = false
            var clicked_on_slot = false


            for wrapper in $PlayerArea / Hand.get_children():
                if wrapper.get_child_count() > 0:
                    var card = wrapper.get_child(0)
                    if card.get_global_rect().has_point(mouse_pos):
                        clicked_on_any_card = true
                        break


            for slot in player_slots:

                if slot.get_global_rect().has_point(mouse_pos):
                    clicked_on_slot = true

                    if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
                        var card = slot.spawn_point.get_child(0)
                        if card.get_global_rect().has_point(mouse_pos):
                            clicked_on_any_card = true
                    break


            if not clicked_on_any_card and not clicked_on_slot:
                hide_all_card_buttons()




func remove_used_player_cards():
    for entry in selected_cards:
        var idx: int = entry["index"]
        if idx >= 0 and idx < player_hand.size():
            player_hand[idx] = null


func _on_card_button_1_pressed(): select_card(0)
func _on_card_button_2_pressed(): select_card(1)
func _on_card_button_3_pressed(): select_card(2)
func _on_card_button_4_pressed(): select_card(3)
func _on_card_button_5_pressed(): select_card(4)

func destroy_random_opponent_spell(opponent_is_player: bool, ninja_owner_is_player: bool):

    var target_spell_slots = player_spell_slots if opponent_is_player else enemy_spell_slots


    var occupied_slots = []
    for slot in target_spell_slots:
        if slot.is_occupied:
            occupied_slots.append(slot)

    if occupied_slots.size() == 0:
        return


    var random_slot = occupied_slots[randi() % occupied_slots.size()]
    var card_name = random_slot.stored_card_data.name if random_slot.stored_card_data else "Desconhecida"


    await _destroy_card(random_slot)

func play_summon_animation(card_visual: Control) -> void :
    if not card_visual:
        return

    var circle_sprite = Sprite2D.new()
    circle_sprite.texture = SUMMON_CIRCLE_TEXTURE
    card_visual.add_child(circle_sprite)



    circle_sprite.position = card_visual.size / 2

    circle_sprite.z_index = 10
    circle_sprite.scale = Vector2(0.9, 0.9)
    circle_sprite.modulate.a = 0.0


    var tween = create_tween()
    tween.set_parallel(true)
    _play_summon_sound()


    tween.tween_property(circle_sprite, "rotation_degrees", 144.0, 0.5)


    tween.tween_property(circle_sprite, "modulate:a", 1.0, 0.25)
    tween.tween_property(circle_sprite, "modulate:a", 0.0, 0.25).set_delay(0.25)


    tween.tween_property(circle_sprite, "scale", Vector2(1.2, 1.2), 0.5)


    tween.chain().tween_callback(circle_sprite.queue_free)

func play_ritual_animation() -> void :
    "\n    Anima o símbolo de ritual quando uma carta Ritual Magic é ativada.\n    IDs de Ritual Magic: 673, 676, 677, 671, 670, 674, 699\n    "



    if not ritual_summon:
        return


    ritual_summon.visible = true
    ritual_summon.scale = Vector2(0.8, 0.8)
    ritual_summon.modulate.a = 0.0


    var tween = create_tween()
    tween.set_parallel(true)

    _play_ritualsummon_sound()


    tween.tween_property(ritual_summon, "rotation_degrees", 216.0, 2.5)


    tween.tween_property(ritual_summon, "modulate:a", 1.0, 0.5)
    tween.tween_property(ritual_summon, "modulate:a", 0.0, 0.5).set_delay(2.0)


    tween.tween_property(ritual_summon, "scale", Vector2(1.0, 1.0), 1.5)



    tween.chain().tween_callback( func(): ritual_summon.visible = false)


func _play_battle_cutscene(attacker_visual, defender_visual, attack_result: String, att_card: CardData, def_card: CardData) -> void :
    "\n    Toca uma animação cinemática de batalha.\n    attack_result: \"ATTACKER_WINS\", \"DEFENDER_WINS\", \"DRAW\", \"DIRECT\"\n    att_card e def_card são usados para calcular valores efetivos (com Guardian Star)\n    "





    var dark_bg = ColorRect.new()
    dark_bg.color = Color(0.0, 0.0, 0.0, 0.95)
    dark_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    dark_bg.z_index = 20
    $CanvasLayer.add_child(dark_bg)



    var large_attacker = _create_large_card_visual(attacker_visual, null)
    var large_defender = _create_large_card_visual(defender_visual, null) if defender_visual else null


    if large_attacker == null:
        dark_bg.queue_free()
        return


    $CanvasLayer.add_child(large_attacker)
    if large_defender:
        $CanvasLayer.add_child(large_defender)


    if attacker_visual and att_card:
        large_attacker.set_card_data(att_card, 0)
        large_attacker.is_face_down = false
        large_attacker.z_index = 25
        large_attacker.scale = Vector2(1.0, 1.0)
        large_attacker.mouse_filter = Control.MOUSE_FILTER_IGNORE
        large_attacker.pivot_offset = large_attacker.size / 2


        var effective_atk = get_effective_atk(att_card, def_card)
        var effective_def = get_effective_def(att_card, def_card)
        if large_attacker.has_method("update_stats_visual"):
            large_attacker.update_stats_visual(effective_atk, effective_def, att_card.atk, att_card.def)

    if large_defender and defender_visual and def_card:
        large_defender.set_card_data(def_card, 0)
        large_defender.is_face_down = false
        large_defender.z_index = 25
        large_defender.scale = Vector2(1.0, 1.0)
        large_defender.mouse_filter = Control.MOUSE_FILTER_IGNORE
        large_defender.pivot_offset = large_defender.size / 2


        var def_effective_atk = get_effective_atk(def_card, att_card)
        var def_effective_def = get_effective_def(def_card, att_card)
        if large_defender.has_method("update_stats_visual"):
            large_defender.update_stats_visual(def_effective_atk, def_effective_def, def_card.atk, def_card.def)


    var screen_size = get_viewport_rect().size
    var center_y = screen_size.y / 2


    large_attacker.position = Vector2(-300, center_y - (large_attacker.size.y / 2))

    if large_defender:
        large_defender.position = Vector2(screen_size.x + 300, center_y - (large_defender.size.y / 2))


    var tween = create_tween()



    var attacker_target_pos = Vector2(screen_size.x * 0.3 - (large_attacker.size.x / 2), large_attacker.position.y)
    tween.tween_property(large_attacker, "position", attacker_target_pos, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

    if large_defender:
        var defender_target_pos = Vector2(screen_size.x * 0.7 - (large_defender.size.x / 2), large_defender.position.y)
        tween.parallel().tween_property(large_defender, "position", defender_target_pos, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


    tween.tween_interval(0.2)



    if large_defender:
        var impact_pos = Vector2(900, large_attacker.position.y)
        tween.tween_property(large_attacker, "position", impact_pos, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
        tween.tween_callback(_play_attackhit_sound)
    else:

        var direct_pos = Vector2(900, large_attacker.position.y)
        tween.tween_property(large_attacker, "position", direct_pos, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
        tween.tween_callback(_play_attackhit_sound)


    tween.tween_property(large_attacker, "position", attacker_target_pos, 0.2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)


    tween.parallel().tween_callback( func():
        _animate_battle_impact(large_attacker, large_defender, attack_result)
    )


    tween.tween_interval(0.2)


    tween.tween_property(large_attacker, "modulate:a", 0.0, 0.2)
    if large_defender:
        tween.parallel().tween_property(large_defender, "modulate:a", 0.0, 0.2)
    tween.parallel().tween_property(dark_bg, "modulate:a", 0.0, 0.2)


    tween.chain().tween_callback( func():
        large_attacker.queue_free()
        if large_defender: large_defender.queue_free()
        dark_bg.queue_free()
    )

    await tween.finished

func _create_large_card_visual(original_visual, _unused) -> Control:
    if not original_visual:
        return null


    var new_visual = card_visual_scene.instantiate()
    return new_visual


func _play_fusion_cutscene(card_a: CardData, card_b: CardData, result_card: CardData, is_valid: bool) -> void :





    var dark_bg = ColorRect.new()
    dark_bg.color = Color(0.0, 0.0, 0.0, 0.95)
    dark_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    dark_bg.z_index = 20
    $CanvasLayer.add_child(dark_bg)


    var fusion_bg = TextureRect.new()
    var fusion_texture = load("res://assets/fusionsummon.png")
    fusion_bg.texture = fusion_texture
    fusion_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    fusion_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    fusion_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    fusion_bg.z_index = 21
    $CanvasLayer.add_child(fusion_bg)

    _play_fusionsummon_sound()


    var screen_center = get_viewport_rect().size / 2
    fusion_bg.pivot_offset = screen_center


    var rotation_tween = create_tween()
    rotation_tween.set_loops()
    rotation_tween.tween_property(fusion_bg, "rotation_degrees", 360, 8.0).from(0.0)


    var large_card_a = card_visual_scene.instantiate()
    var large_card_b = card_visual_scene.instantiate()
    var large_result = card_visual_scene.instantiate()


    $CanvasLayer.add_child(large_card_a)
    $CanvasLayer.add_child(large_card_b)
    $CanvasLayer.add_child(large_result)


    large_card_a.set_card_data(card_a, 0)
    large_card_a.is_face_down = false
    large_card_a.z_index = 25
    large_card_a.scale = Vector2(1.0, 1.0)
    large_card_a.mouse_filter = Control.MOUSE_FILTER_IGNORE

    large_card_b.set_card_data(card_b, 0)
    large_card_b.is_face_down = false
    large_card_b.z_index = 25
    large_card_b.scale = Vector2(1.0, 1.0)
    large_card_b.mouse_filter = Control.MOUSE_FILTER_IGNORE

    large_result.set_card_data(result_card, 0)
    large_result.is_face_down = false
    large_result.z_index = 26
    large_result.scale = Vector2(0.1, 0.1)
    large_result.modulate.a = 0.0
    large_result.mouse_filter = Control.MOUSE_FILTER_IGNORE
    large_result.pivot_offset = large_result.size / 2


    var screen_size = get_viewport_rect().size
    var center = Vector2(screen_size.x / 2, screen_size.y / 2)


    large_card_a.position = Vector2(-300, center.y - large_card_a.size.y / 2)
    large_card_b.position = Vector2(screen_size.x + 300, center.y - large_card_b.size.y / 2)
    large_result.position = center - large_result.size / 2


    var tween = create_tween()


    var card_a_enter_pos = Vector2(center.x - 200 - large_card_a.size.x / 2, center.y - large_card_a.size.y / 2)
    var card_b_enter_pos = Vector2(center.x + 200 - large_card_b.size.x / 2, center.y - large_card_b.size.y / 2)

    tween.tween_property(large_card_a, "position", card_a_enter_pos, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
    tween.parallel().tween_property(large_card_b, "position", card_b_enter_pos, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

    tween.tween_interval(0.2)

    if is_valid:


        tween.tween_property(large_card_a, "modulate", Color(3.0, 3.0, 3.0, 1.0), 0.15)
        tween.parallel().tween_property(large_card_b, "modulate", Color(3.0, 3.0, 3.0, 1.0), 0.15)
        tween.tween_property(large_card_a, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
        tween.parallel().tween_property(large_card_b, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)


        var center_pos = center - large_card_a.size / 2
        tween.tween_property(large_card_a, "position", center_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
        tween.parallel().tween_property(large_card_b, "position", center_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


        tween.tween_property(large_card_a, "modulate:a", 0.0, 0.3)
        tween.parallel().tween_property(large_card_b, "modulate:a", 0.0, 0.3)
        tween.parallel().tween_property(large_result, "modulate:a", 1.0, 0.3)
        tween.parallel().tween_property(large_result, "scale", Vector2(1.2, 1.2), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
        tween.tween_callback(_play_fusiontrue_sound)
        tween.parallel().tween_property(large_result, "modulate", Color(3.0, 3.0, 3.0, 1.0), 0.3)
        tween.tween_property(large_result, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)


        tween.tween_property(large_result, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

        tween.tween_interval(0.3)

    else:


        var center_pos = center - large_card_a.size / 2
        tween.tween_property(large_card_a, "position", center_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
        tween.parallel().tween_property(large_card_b, "position", center_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

        tween.tween_callback(_play_fusionfalse_sound)


        var push_out_pos = Vector2(-900, center.y - large_card_a.size.y / 2)
        tween.tween_property(large_card_a, "position", push_out_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
        tween.parallel().tween_property(large_card_a, "rotation_degrees", -45, 0.3)

        tween.tween_interval(0.3)


    tween.tween_property(large_card_a, "modulate:a", 0.0, 0.3)
    tween.parallel().tween_property(large_card_b, "modulate:a", 0.0, 0.3)
    tween.parallel().tween_property(large_result, "modulate:a", 0.0, 0.3)
    tween.parallel().tween_property(dark_bg, "modulate:a", 0.0, 0.3)
    tween.parallel().tween_property(fusion_bg, "modulate:a", 0.0, 0.3)


    tween.chain().tween_callback( func():
        rotation_tween.kill()
        large_card_a.queue_free()
        large_card_b.queue_free()
        large_result.queue_free()
        dark_bg.queue_free()
        fusion_bg.queue_free()
    )

    await tween.finished
func _animate_battle_impact(attacker, defender, result: String):

    match result:
        "ATTACKER_WINS":
            if defender:

                var tween = create_tween()
                tween.tween_property(defender, "modulate", Color(1, 0, 0), 0.1)
                tween.chain().tween_property(defender, "scale", defender.scale * 1.2, 0.1)
                tween.chain().tween_property(defender, "scale", defender.scale, 0.1)
                tween.chain().tween_callback( func():
                    if EffectManager.has_method("play_fire_effect_on_node"):
                        EffectManager.play_fire_effect_on_node(defender)
                    else:

                        pass
                )
        "DEFENDER_WINS":

            var tween = create_tween()
            tween.tween_property(attacker, "modulate", Color(1, 0, 0), 0.1)
            tween.chain().tween_property(attacker, "scale", attacker.scale * 1.2, 0.1)
            tween.chain().tween_property(attacker, "scale", attacker.scale, 0.1)
            tween.chain().tween_callback( func():
                if EffectManager.has_method("play_fire_effect_on_node"):
                    EffectManager.play_fire_effect_on_node(attacker)
                else:

                    pass
            )
        "DRAW":

            if defender:
                var tween = create_tween()
                tween.parallel().tween_property(attacker, "modulate", Color(1, 0, 0), 0.1)
                tween.parallel().tween_property(defender, "modulate", Color(1, 0, 0), 0.1)
                tween.chain().tween_callback( func():
                    if EffectManager.has_method("play_fire_effect_on_node"):
                        EffectManager.play_fire_effect_on_node(attacker)
                        EffectManager.play_fire_effect_on_node(defender)
                    else:

                        pass
                )
        "DIRECT":

            pass


func _get_random_audio_file(folder_path: String) -> String:
    var files = []
    var dir = DirAccess.open(folder_path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if not dir.current_is_dir():
                var lower_name = file_name.to_lower()
                if lower_name.ends_with(".mp3") or lower_name.ends_with(".ogg") or lower_name.ends_with(".wav"):
                    files.append(folder_path + file_name)
                elif lower_name.ends_with(".import"):
                    var real_name = file_name.replace(".import", "")
                    var lower_real = real_name.to_lower()
                    if lower_real.ends_with(".mp3") or lower_real.ends_with(".ogg") or lower_real.ends_with(".wav"):
                        var full_path = folder_path + real_name
                        if not files.has(full_path):
                            files.append(full_path)
            file_name = dir.get_next()

    if files.is_empty():
        return ""

    files.shuffle()
    return files[0]

func _play_bgm():

    var paths = {
        "normal": _get_random_audio_file("res://assets/sounds/bgm/duel/"), 
        "winning": _get_random_audio_file("res://assets/sounds/bgm/winning/"), 
        "losing": _get_random_audio_file("res://assets/sounds/bgm/losing/")
    }

    for state in bgm_players.keys():
        if bgm_players[state]:
            bgm_players[state].queue_free()

        var path = paths[state]
        if path != "":
            var player = AudioStreamPlayer.new()
            var stream = load(path)
            if stream:
                stream.loop = true
                player.stream = stream
                player.bus = "Master"
                add_child(player)
                player.play()


                if state != "normal":
                    player.stream_paused = true

            bgm_players[state] = player

    current_bgm_state = "normal"

func _check_bgm_state():
    var new_state = "normal"

    if player_lp - enemy_lp >= 5000:
        new_state = "winning"
    elif enemy_lp - player_lp >= 5000:
        new_state = "losing"

    if new_state != current_bgm_state:

        if bgm_players[current_bgm_state]:
            bgm_players[current_bgm_state].stream_paused = true


        if bgm_players[new_state]:
            bgm_players[new_state].stream_paused = false

        current_bgm_state = new_state

func _play_youwin_bgm():

    for state in bgm_players.keys():
        if bgm_players[state] and bgm_players[state].playing:
            bgm_players[state].stop()

    var player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/youwin.mp3")
    if stream:
        stream.loop = false
        player.stream = stream
        player.bus = "Master"
        add_child(player)
        player.play()

func _play_youlose_bgm():

    for state in bgm_players.keys():
        if bgm_players[state] and bgm_players[state].playing:
            bgm_players[state].stop()

    var player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/youlose.mp3")
    if stream:
        stream.loop = false
        player.stream = stream
        player.bus = "Master"
        add_child(player)
        player.play()

func _play_darkhole_sound():

    var sound_path = "res://assets/sounds/sfx/darkhole.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func _play_confirm_sound():

    var sound_path = "res://assets/sounds/sfx/confirmbutton.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func _play_carddraw_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_card_draw_time < 100:
            _card_draw_delay_offset += delay_increment
        else:
            _card_draw_delay_offset = 0.0
        delay = _card_draw_delay_offset

    _last_card_draw_time = current_time


    var sound_path = "res://assets/sounds/sfx/carddraw.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_discard_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/sendgraveyard.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_spawncard_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/spawncard.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_summon_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/summon.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_cardrotation_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/cardrotation.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_activate_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/activate.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_setfield_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/setfield2.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_ritualsummon_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/ritualsummon.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_fusionsummon_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/fusionsummon.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_fusiontrue_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/fusiontrue.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_fusionfalse_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/fusionfalse.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_attack_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/attack.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_attackhit_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/attackhit.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_damage_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/damage.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_gainlp_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/gainlp.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)


func _on_atk_mobile_button_pressed(card_visual, slot_node) -> void :
    _on_card_attack_requested(card_visual, slot_node)


func _apply_duel_speed():
    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        duel_speed = global.game_speed
    Engine.time_scale = float(duel_speed)
    print("Velocidade do duelo: %dx" % duel_speed)

func _create_speed_buttons():

    if not has_node("CanvasLayer/SpeedButtons"):
        print("ERRO: Container SpeedButtons não encontrado no CanvasLayer!")
        return

    speed_buttons_container = $CanvasLayer / SpeedButtons
    speed_buttons.clear()


    for spd in range(1, 6):
        var btn_name = "Btn%dx" % spd
        if speed_buttons_container.has_node(btn_name):
            var btn = speed_buttons_container.get_node(btn_name)


            if not btn.pressed.is_connected(_on_duel_speed_button_pressed.bind(spd)):
                btn.pressed.connect(_on_duel_speed_button_pressed.bind(spd))

            speed_buttons.append(btn)
        else:
            print("ERRO: Botão ", btn_name, " não encontrado!")

    _update_speed_button_visuals()

func _on_duel_speed_button_pressed(spd: int):
    duel_speed = spd
    Engine.time_scale = float(duel_speed)
    print("Velocidade do duelo alterada para: %dx" % duel_speed)
    _update_speed_button_visuals()

func _update_speed_button_visuals():
    for i in range(speed_buttons.size()):
        speed_buttons[i].button_pressed = ((i + 1) == duel_speed)

func _on_change_pos_mobile_button_pressed(card_visual, slot_node) -> void :
    _on_card_position_change_requested(card_visual, slot_node)

func _on_activate_mobile_button_pressed(_visual_sender, slot_node) -> void :
    _on_card_activate_requested(_visual_sender, slot_node)
