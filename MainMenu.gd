extends Node2D

static var game_just_started = true

@onready var video_player: VideoStreamPlayer = $VideoPlayer
@onready var background: Sprite2D = $Background
@onready var fade_rect: ColorRect = $FadeRect
@onready var ui: CanvasLayer = $UI
@onready var initial_buttons: VBoxContainer = $UI / InitialButtons
@onready var freeplay_buttons: VBoxContainer = $UI / FreePlayButtons
@onready var menu_buttons: VBoxContainer = $UI / MenuButtons
@onready var name_input_container: CenterContainer = $UI / CenterContainer
@onready var name_input: LineEdit = $UI / CenterContainer / VBoxContainer / NameInput
@onready var confirm_button: Button = $UI / CenterContainer / VBoxContainer / ConfirmButton
@onready var error_label: Label = $UI / CenterContainer / VBoxContainer / ErrorLabel
@onready var audio_player: AudioStreamPlayer = null
@onready var credits: Control = $Credits
@onready var credits_text: Control = $Credits / TextGroup


const INTRO_VIDEO = "res://assets/videos/intro.ogv"
const MENU_VIDEO = "res://assets/videos/menu.ogv"
const MENU_BG = "res://assets/menu.png"
var save_file: String = ""


var credits_tween: Tween
var original_credits_text_y: float = 0.0


enum MenuState{INTRO_VIDEO, MENU_VIDEO, MAIN_MENU, NAME_INPUT}
var current_state = MenuState.INTRO_VIDEO
var can_skip = false

var waiting_for_delete_confirmation: bool = false
var delete_save_button: Button = null

func _ready():

    video_player.visible = false
    background.visible = false
    fade_rect.visible = true
    fade_rect.color = Color(0, 0, 0, 1)


    ui.visible = false
    initial_buttons.visible = false
    menu_buttons.visible = false
    name_input_container.visible = false
    freeplay_buttons.visible = false
    credits.visible = false


    if credits_text:
        original_credits_text_y = credits_text.position.y

    _setup_simple_button_effects()

    save_file = Global.get_save_path("player_save.dat")


    if game_just_started:
        print("Primeira inicialização do jogo - tocando vídeos")
        game_just_started = false


        var tween = create_tween()
        tween.tween_property(fade_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
        tween.tween_callback(start_intro)
    else:
        print("Voltando para menu - sem vídeos")
        skip_to_menu_directly()

func skip_to_menu_directly():
    "Vai direto para o menu sem tocar vídeos"
    current_state = MenuState.MAIN_MENU


    _play_menu_bgm()


    background.texture = load(MENU_BG)
    background.visible = true
    background.modulate = Color(1, 1, 1, 0)


    ui.visible = true


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.load_player_data()

        if global.cards_unlocked.size() > 0 or global.player_deck.size() > 0:

            menu_buttons.visible = true
            menu_buttons.modulate = Color(1, 1, 1, 0)
        else:

            initial_buttons.visible = true
            initial_buttons.modulate = Color(1, 1, 1, 0)


    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(background, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
    if menu_buttons.visible:
        tween.tween_property(menu_buttons, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
    if initial_buttons.visible:
        tween.tween_property(initial_buttons, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
    tween.tween_property(fade_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)

func _setup_simple_button_effects():
    var buttons = _get_all_buttons()

    for button in buttons:

        button.focus_mode = Control.FOCUS_NONE


        button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


        button.mouse_entered.connect(_on_button_hover.bind(button))
        button.mouse_exited.connect(_on_button_unhover.bind(button))

func _on_button_hover(button: Button):
    if not button.disabled:

        var tween = create_tween()
        tween.tween_property(button, "modulate", Color(0.393, 0.393, 0.393, 1.0), 0.1)

func _on_button_unhover(button: Button):
    if not button.disabled:
        var tween = create_tween()
        tween.tween_property(button, "modulate", Color.WHITE, 0.1)

func _get_all_buttons() -> Array:
    var buttons = []
    _find_buttons(self, buttons)
    return buttons

func _find_buttons(node: Node, buttons: Array):
    for child in node.get_children():
        if child is Button:
            buttons.append(child)
        _find_buttons(child, buttons)

func start_intro():

    current_state = MenuState.INTRO_VIDEO
    play_video(INTRO_VIDEO)

func play_video(video_path: String):
    if not ResourceLoader.exists(video_path):
        print("Video não encontrado: ", video_path)
        on_video_finished()
        return

    video_player.stream = load(video_path)
    video_player.visible = true
    video_player.play()


    video_player.modulate = Color(0.0, 0.0, 0.0, 1.0)
    var tween = create_tween()
    tween.tween_property(video_player, "modulate", Color(1, 1, 1, 1), 1.0)


    await get_tree().create_timer(0.5).timeout
    can_skip = true


    await video_player.finished
    on_video_finished()

func on_video_finished():
    can_skip = false

    match current_state:
        MenuState.INTRO_VIDEO:

            var tween = create_tween()
            tween.tween_property(video_player, "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
            tween.tween_callback( func():
                video_player.visible = false

                check_save_and_show_menu()
            )











func check_save_and_show_menu():
    print("Verificando save file após vídeos...")


    _play_menu_bgm()


    if has_node("/root/Global"):
        var global = get_node("/root/Global")


        global.load_player_data()


        if FileAccess.file_exists(save_file) and (global.cards_unlocked.size() > 0 or global.player_deck.size() > 0):
            print("Save válido encontrado no Global, mostrando menu principal")
            show_main_menu()
            return

    print("Nenhum save válido, mostrando tela inicial")
    show_initial_buttons()

var bgm_player: AudioStreamPlayer = null

func _play_menu_bgm():

    if bgm_player and bgm_player.playing:
        return

    if bgm_player:
        bgm_player.queue_free()

    bgm_player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/mainmenu.mp3")
    if stream:

        stream.loop = true
        bgm_player.stream = stream
        bgm_player.bus = "Master"
        add_child(bgm_player)
        bgm_player.play()

func show_initial_buttons():
    current_state = MenuState.MAIN_MENU
    ui.visible = true


    background.texture = load(MENU_BG)
    background.visible = true
    background.modulate = Color(1, 1, 1, 0)


    initial_buttons.visible = true
    initial_buttons.modulate = Color(1, 1, 1, 0)


    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(background, "modulate", Color(1, 1, 1, 1), 1.0)
    tween.tween_property(initial_buttons, "modulate", Color(1, 1, 1, 1), 1.0).set_delay(0.5)

func show_main_menu():
    current_state = MenuState.MAIN_MENU
    ui.visible = true


    background.texture = load(MENU_BG)
    background.visible = true
    background.modulate = Color(1, 1, 1, 0)


    menu_buttons.visible = true
    menu_buttons.modulate = Color(1, 1, 1, 0)


    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(background, "modulate", Color(1, 1, 1, 1), 1.0)
    tween.tween_property(menu_buttons, "modulate", Color(1, 1, 1, 1), 1.0).set_delay(0.5)

func show_name_input():
    current_state = MenuState.NAME_INPUT


    initial_buttons.visible = false
    menu_buttons.visible = false


    name_input_container.visible = true
    name_input_container.modulate = Color(1, 1, 1, 0)
    name_input.text = ""
    error_label.visible = false


    var tween = create_tween()
    tween.tween_property(name_input_container, "modulate", Color(1, 1, 1, 1), 0.5)
    tween.tween_callback( func(): name_input.grab_focus())

func save_player_data(player_name: String):
    "Salva dados iniciais do jogador usando o Global.gd"
    if not has_node("/root/Global"):
        print("ERRO: Global.gd não encontrado!")
        return false

    var global = get_node("/root/Global")


    global.player_name = player_name


    var success = global.save_player_data()

    if success:
        print("Save criado para: ", player_name)


        if has_node("/root/CardCollection"):
            var collection = get_node("/root/CardCollection")
            if collection.has_method("initialize_new_player"):
                collection.initialize_new_player()

        return true
    else:
        print("Erro ao criar save file")
        return false


func _on_new_game_button_pressed():
    _play_confirm_sound()
    show_name_input()

func _on_exit_initial_button_pressed():
    _play_confirm_sound()
    get_tree().quit()

func _on_confirm_button_pressed():
    _play_confirm_sound()
    var player_name = name_input.text.strip_edges()

    if player_name.length() < 3:
        error_label.text = "Name needs atleast 3 characters."
        error_label.visible = true
        return

    if player_name.length() > 20:
        error_label.text = "Name too long! 20 characters máx. "
        error_label.visible = true
        return


    if save_player_data(player_name):

        var tween = create_tween()
        tween.tween_property(name_input_container, "modulate", Color(1, 1, 1, 0), 0.5)
        tween.tween_callback( func():
            name_input_container.visible = false

            await get_tree().process_frame
            show_main_menu()
        )
    else:
        error_label.text = "Try again."
        error_label.visible = true

func _on_free_duel_button_pressed():
    _play_confirm_sound()
    menu_buttons.visible = false
    freeplay_buttons.visible = true

func _on_campaign_button_pressed():
    _play_confirm_sound()
    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/Campaign.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/Campaign.tscn")
    )

func _on_build_deck_button_pressed():
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

func _on_shop_button_pressed():
    _play_confirm_sound()

    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/CardShop.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/CardShop.tscn")
    )

func _on_options_button_pressed():
    _play_confirm_sound()
    _create_options_window()


var options_panel: PanelContainer = null
var options_volume_slider: HSlider = null
var options_speed_buttons: Array = []
var options_avatar_buttons: Array = []
var options_cardback_buttons: Array = []
var options_selected_avatar: int = 0
var options_selected_cardback: int = 0
var options_selected_speed: int = 1
var options_volume_value: float = 1.0
var options_windowed_mode: bool = false

func _get_options_font() -> FontVariation:
    var base_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
    var font = FontVariation.new()
    font.base_font = base_font
    font.spacing_glyph = 3
    return font

func _create_options_button_style(bg_color: Color = Color(0.3, 0.3, 0.3), margin_top: float = 10.0) -> StyleBoxFlat:
    var style = StyleBoxFlat.new()
    style.bg_color = bg_color
    style.corner_radius_top_left = 5
    style.corner_radius_top_right = 5
    style.corner_radius_bottom_left = 5
    style.corner_radius_bottom_right = 5
    style.content_margin_top = margin_top
    return style

func _create_options_window():
    if options_panel:
        options_panel.queue_free()


    var global = get_node_or_null("/root/Global")
    if global:
        options_volume_value = global.game_volume
        options_selected_speed = global.game_speed
        options_selected_avatar = global.selected_avatar
        if "selected_card_back" in global:
            options_selected_cardback = global.selected_card_back
        if "windowed_mode" in global:
            options_windowed_mode = global.windowed_mode

    var font = _get_options_font()
    var font_large = _get_options_font()


    options_panel = PanelContainer.new()
    options_panel.custom_minimum_size = Vector2(1000, 1000)
    options_panel.anchors_preset = Control.PRESET_CENTER
    options_panel.position = Vector2(get_viewport().get_visible_rect().size.x / 2 - 500, get_viewport().get_visible_rect().size.y / 2 - 500)

    var panel_style = StyleBoxFlat.new()
    panel_style.bg_color = Color(0, 0, 0, 1)
    panel_style.corner_radius_top_left = 10
    panel_style.corner_radius_top_right = 10
    panel_style.corner_radius_bottom_left = 10
    panel_style.corner_radius_bottom_right = 10
    options_panel.add_theme_stylebox_override("panel", panel_style)

    var main_vbox = VBoxContainer.new()
    main_vbox.add_theme_constant_override("separation", 0)
    main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    options_panel.add_child(main_vbox)


    var scroll_container = ScrollContainer.new()
    scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    main_vbox.add_child(scroll_container)


    var margin = MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 40)
    margin.add_theme_constant_override("margin_right", 40)
    margin.add_theme_constant_override("margin_top", 30)
    margin.add_theme_constant_override("margin_bottom", 30)
    margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll_container.add_child(margin)

    var content_vbox = VBoxContainer.new()
    content_vbox.add_theme_constant_override("separation", 25)
    content_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin.add_child(content_vbox)


    var title = Label.new()
    title.text = "OPTIONS"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_override("font", font)
    title.add_theme_font_size_override("font_size", 70)
    title.add_theme_constant_override("outline_size", 10)
    title.add_theme_color_override("font_outline_color", Color.BLACK)
    content_vbox.add_child(title)


    var volume_label = Label.new()
    volume_label.text = "VOLUME"
    volume_label.add_theme_font_override("font", font)
    volume_label.add_theme_font_size_override("font_size", 40)
    volume_label.add_theme_constant_override("outline_size", 10)
    volume_label.add_theme_color_override("font_outline_color", Color.BLACK)
    content_vbox.add_child(volume_label)

    options_volume_slider = HSlider.new()
    options_volume_slider.min_value = 0.0
    options_volume_slider.max_value = 1.0
    options_volume_slider.step = 0.05
    options_volume_slider.value = options_volume_value
    options_volume_slider.custom_minimum_size = Vector2(0, 30)
    options_volume_slider.value_changed.connect(_on_options_volume_changed)
    content_vbox.add_child(options_volume_slider)


    var speed_label = Label.new()
    speed_label.text = "GAME SPEED"
    speed_label.add_theme_font_override("font", font)
    speed_label.add_theme_font_size_override("font_size", 40)
    speed_label.add_theme_constant_override("outline_size", 10)
    speed_label.add_theme_color_override("font_outline_color", Color.BLACK)
    content_vbox.add_child(speed_label)

    var speed_hbox = HBoxContainer.new()
    speed_hbox.add_theme_constant_override("separation", 15)
    content_vbox.add_child(speed_hbox)

    options_speed_buttons.clear()
    for speed in [1, 2, 3, 4, 5]:
        var btn = Button.new()
        btn.text = "%dx" % speed
        btn.custom_minimum_size = Vector2(150, 75)
        btn.toggle_mode = true
        btn.button_pressed = (speed == options_selected_speed)
        btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        btn.add_theme_font_override("font", font)
        btn.add_theme_font_size_override("font_size", 40)
        btn.add_theme_constant_override("outline_size", 10)
        btn.add_theme_color_override("font_outline_color", Color.BLACK)

        var normal_s = _create_options_button_style(Color(0.3, 0.3, 0.3))
        var hover_s = _create_options_button_style(Color(0.2, 0.2, 0.2))
        var pressed_s = _create_options_button_style(Color(0.0, 0.5, 1.0))
        btn.add_theme_stylebox_override("normal", normal_s)
        btn.add_theme_stylebox_override("hover", hover_s)
        btn.add_theme_stylebox_override("pressed", pressed_s)
        btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

        btn.pressed.connect(_on_speed_button_pressed.bind(speed))
        speed_hbox.add_child(btn)
        options_speed_buttons.append(btn)


    var avatar_label = Label.new()
    avatar_label.text = "AVATAR"
    avatar_label.add_theme_font_override("font", font)
    avatar_label.add_theme_font_size_override("font_size", 40)
    avatar_label.add_theme_constant_override("outline_size", 10)
    avatar_label.add_theme_color_override("font_outline_color", Color.BLACK)
    content_vbox.add_child(avatar_label)

    var avatar_hbox = HBoxContainer.new()
    avatar_hbox.add_theme_constant_override("separation", 30)
    avatar_hbox.alignment = BoxContainer.ALIGNMENT_CENTER


    var avatar_scroll = ScrollContainer.new()
    avatar_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    avatar_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    avatar_scroll.custom_minimum_size = Vector2(0, 170)
    avatar_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    content_vbox.add_child(avatar_scroll)
    avatar_scroll.add_child(avatar_hbox)

    options_avatar_buttons.clear()
    for i in range(13):
        var tex_btn = TextureButton.new()
        var frame_tex = load("res://assets/portraits/player%dframe.png" % i)
        tex_btn.texture_normal = frame_tex
        tex_btn.custom_minimum_size = Vector2(150, 150)
        tex_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
        tex_btn.ignore_texture_size = true
        tex_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        tex_btn.scale = Vector2(1.0, 1.0)
        tex_btn.pivot_offset = Vector2(75, 75)


        if i == options_selected_avatar:
            tex_btn.modulate = Color(1, 1, 1, 1)
        else:
            tex_btn.modulate = Color(0.5, 0.5, 0.5, 1)

        tex_btn.pressed.connect(_on_avatar_button_pressed.bind(i))
        tex_btn.mouse_entered.connect(_on_avatar_hover.bind(tex_btn, i))
        tex_btn.mouse_exited.connect(_on_avatar_unhover.bind(tex_btn, i))
        avatar_hbox.add_child(tex_btn)
        options_avatar_buttons.append(tex_btn)


    var cardback_label = Label.new()
    cardback_label.text = "CARD BACK"
    cardback_label.add_theme_font_override("font", font)
    cardback_label.add_theme_font_size_override("font_size", 40)
    cardback_label.add_theme_constant_override("outline_size", 10)
    cardback_label.add_theme_color_override("font_outline_color", Color.BLACK)
    content_vbox.add_child(cardback_label)

    var cardback_hbox = HBoxContainer.new()
    cardback_hbox.add_theme_constant_override("separation", 30)
    cardback_hbox.alignment = BoxContainer.ALIGNMENT_CENTER


    var cardback_scroll = ScrollContainer.new()
    cardback_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    cardback_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    cardback_scroll.custom_minimum_size = Vector2(0, 120)
    cardback_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    content_vbox.add_child(cardback_scroll)
    cardback_scroll.add_child(cardback_hbox)

    options_cardback_buttons.clear()
    for i in range(28):
        var tex_btn = TextureButton.new()
        var cb_path = "res://assets/cards/card_back.png" if i == 0 else "res://assets/cards/card_back%d.png" % i
        var cb_tex = load(cb_path) if ResourceLoader.exists(cb_path) else load("res://icon.svg")
        tex_btn.texture_normal = cb_tex

        var tex_size = cb_tex.get_size()
        tex_btn.custom_minimum_size = tex_size * 0.3
        tex_btn.stretch_mode = TextureButton.STRETCH_SCALE
        tex_btn.ignore_texture_size = true
        tex_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

        if i == options_selected_cardback:
            tex_btn.modulate = Color(1, 1, 1, 1)
        else:
            tex_btn.modulate = Color(0.5, 0.5, 0.5, 1)

        tex_btn.pressed.connect(_on_cardback_button_pressed.bind(i))
        tex_btn.mouse_entered.connect(_on_cardback_hover.bind(tex_btn, i))
        tex_btn.mouse_exited.connect(_on_cardback_unhover.bind(tex_btn, i))
        cardback_hbox.add_child(tex_btn)
        options_cardback_buttons.append(tex_btn)


    var is_pc = not (OS.has_feature("mobile") or OS.has_feature("web") or OS.has_feature("HTML5"))
    if is_pc:
        var windowed_hbox = HBoxContainer.new()
        windowed_hbox.add_theme_constant_override("separation", 15)
        windowed_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
        content_vbox.add_child(windowed_hbox)

        var windowed_check = CheckBox.new()
        windowed_check.text = "WINDOWED MODE"
        windowed_check.button_pressed = options_windowed_mode
        windowed_check.add_theme_font_override("font", font)
        windowed_check.add_theme_font_size_override("font_size", 35)
        windowed_check.add_theme_constant_override("outline_size", 10)
        windowed_check.add_theme_color_override("font_outline_color", Color.BLACK)
        windowed_check.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        windowed_check.toggled.connect( func(pressed): options_windowed_mode = pressed)
        windowed_hbox.add_child(windowed_check)


    var delete_hbox = HBoxContainer.new()
    delete_hbox.add_theme_constant_override("separation", 15)
    delete_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    content_vbox.add_child(delete_hbox)

    delete_save_button = Button.new()
    delete_save_button.text = "DELETE\nSAVE DATA"
    delete_save_button.custom_minimum_size = Vector2(250, 80)
    delete_save_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    delete_save_button.add_theme_font_override("font", font)
    delete_save_button.add_theme_font_size_override("font_size", 30)
    delete_save_button.add_theme_constant_override("outline_size", 5)
    delete_save_button.add_theme_color_override("font_outline_color", Color.BLACK)

    var del_normal_s = _create_options_button_style(Color(0.8, 0.1, 0.1))
    var del_hover_s = _create_options_button_style(Color(0.9, 0.2, 0.2))
    var del_pressed_s = _create_options_button_style(Color(0.6, 0.05, 0.05))
    delete_save_button.add_theme_stylebox_override("normal", del_normal_s)
    delete_save_button.add_theme_stylebox_override("hover", del_hover_s)
    delete_save_button.add_theme_stylebox_override("pressed", del_pressed_s)
    delete_save_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

    delete_save_button.pressed.connect(_on_delete_save_button_pressed)
    delete_hbox.add_child(delete_save_button)


    var save_transfer_hbox = HBoxContainer.new()
    save_transfer_hbox.add_theme_constant_override("separation", 20)
    save_transfer_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    content_vbox.add_child(save_transfer_hbox)

    var export_button = Button.new()
    export_button.text = "EXPORT TO\nCLIPBOARD"
    export_button.custom_minimum_size = Vector2(250, 80)
    export_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    export_button.add_theme_font_override("font", font)
    export_button.add_theme_font_size_override("font_size", 25)
    export_button.add_theme_constant_override("outline_size", 5)
    export_button.add_theme_color_override("font_outline_color", Color.BLACK)

    var exp_ns = _create_options_button_style(Color(0.2, 0.4, 0.8))
    var exp_hs = _create_options_button_style(Color(0.3, 0.5, 0.9))
    var exp_ps = _create_options_button_style(Color(0.1, 0.3, 0.6))
    export_button.add_theme_stylebox_override("normal", exp_ns)
    export_button.add_theme_stylebox_override("hover", exp_hs)
    export_button.add_theme_stylebox_override("pressed", exp_ps)
    export_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
    export_button.pressed.connect(_on_export_save_pressed)
    save_transfer_hbox.add_child(export_button)

    var import_button = Button.new()
    import_button.text = "IMPORT FROM\nCLIPBOARD"
    import_button.custom_minimum_size = Vector2(250, 80)
    import_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    import_button.add_theme_font_override("font", font)
    import_button.add_theme_font_size_override("font_size", 25)
    import_button.add_theme_constant_override("outline_size", 5)
    import_button.add_theme_color_override("font_outline_color", Color.BLACK)

    var imp_ns = _create_options_button_style(Color(0.2, 0.6, 0.2))
    var imp_hs = _create_options_button_style(Color(0.3, 0.7, 0.3))
    var imp_ps = _create_options_button_style(Color(0.1, 0.5, 0.1))
    import_button.add_theme_stylebox_override("normal", imp_ns)
    import_button.add_theme_stylebox_override("hover", imp_hs)
    import_button.add_theme_stylebox_override("pressed", imp_ps)
    import_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
    import_button.pressed.connect(_on_import_save_pressed)
    save_transfer_hbox.add_child(import_button)


    var buttons_hbox = HBoxContainer.new()
    buttons_hbox.add_theme_constant_override("separation", 20)
    buttons_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    content_vbox.add_child(buttons_hbox)

    for btn_info in [["SAVE", _on_options_save_pressed], ["BACK", _on_options_back_pressed]]:
        var btn = Button.new()
        btn.text = btn_info[0]
        btn.custom_minimum_size = Vector2(150, 55)
        btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        btn.add_theme_font_override("font", font_large)
        btn.add_theme_font_size_override("font_size", 35)
        btn.add_theme_constant_override("outline_size", 5)
        btn.add_theme_color_override("font_outline_color", Color.BLACK)

        var normal_s = _create_options_button_style(Color(0.3, 0.3, 0.3))
        var hover_s = _create_options_button_style(Color(0.15, 0.15, 0.15))
        var pressed_s = _create_options_button_style(Color(0.1, 0.1, 0.1))
        btn.add_theme_stylebox_override("normal", normal_s)
        btn.add_theme_stylebox_override("hover", hover_s)
        btn.add_theme_stylebox_override("pressed", pressed_s)
        btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

        btn.pressed.connect(btn_info[1])
        buttons_hbox.add_child(btn)


    $UI.add_child(options_panel)

func _on_options_volume_changed(value: float):
    options_volume_value = value

func _on_speed_button_pressed(speed: int):
    _play_confirm_sound()
    options_selected_speed = speed
    for i in range(options_speed_buttons.size()):
        options_speed_buttons[i].button_pressed = ((i + 1) == speed)

func _on_avatar_button_pressed(index: int):
    _play_confirm_sound()
    options_selected_avatar = index
    for i in range(options_avatar_buttons.size()):
        if i == index:
            options_avatar_buttons[i].modulate = Color(1, 1, 1, 1)
        else:
            options_avatar_buttons[i].modulate = Color(0.5, 0.5, 0.5, 1)

func _on_avatar_hover(btn: TextureButton, index: int):
    if index != options_selected_avatar:
        var tween = create_tween()
        tween.tween_property(btn, "modulate", Color(0.8, 0.8, 0.8, 1), 0.1)

func _on_avatar_unhover(btn: TextureButton, index: int):
    if index != options_selected_avatar:
        var tween = create_tween()
        tween.tween_property(btn, "modulate", Color(0.5, 0.5, 0.5, 1), 0.1)

func _on_cardback_button_pressed(index: int):
    _play_confirm_sound()
    options_selected_cardback = index
    for i in range(options_cardback_buttons.size()):
        if i == index:
            options_cardback_buttons[i].modulate = Color(1, 1, 1, 1)
        else:
            options_cardback_buttons[i].modulate = Color(0.5, 0.5, 0.5, 1)

func _on_cardback_hover(btn: TextureButton, index: int):
    if index != options_selected_cardback:
        var tween = create_tween()
        tween.tween_property(btn, "modulate", Color(0.8, 0.8, 0.8, 1), 0.1)

func _on_cardback_unhover(btn: TextureButton, index: int):
    if index != options_selected_cardback:
        var tween = create_tween()
        tween.tween_property(btn, "modulate", Color(0.5, 0.5, 0.5, 1), 0.1)









func _on_export_save_pressed() -> void :
    _play_confirm_sound()
    if not has_node("/root/Global"):
        return

    var global = get_node("/root/Global")
    if global.export_save_to_clipboard():
        OS.alert("Save data securely copied to your Clipboard!\nPaste it anywhere (like Telegram/WhatsApp/Notes) to transfer to your other device.", "Export Success")
    else:
        OS.alert("Error exporting save data.\nPlease ensure you have a save file first.", "Export Error")

func _on_import_save_pressed() -> void :
    _play_confirm_sound()
    if not has_node("/root/Global"):
        return

    var global = get_node("/root/Global")
    var result = global.import_save_from_clipboard()
    if result == 0:
        _on_options_back_pressed()
        OS.alert("Save data successfully imported from Clipboard!\nReloading...", "Import Success")
        get_tree().create_timer(1.5).timeout.connect( func(): get_tree().reload_current_scene())
    elif result == 1:
        OS.alert("Your Clipboard is empty.\nPlease copy the Base64 save text generated from your other device, and then click Import again.", "Import Error")
    else:
        OS.alert("The save text in your Clipboard is invalid or corrupted.\nPlease ensure you copied the entire text correctly.", "Import Error")
        global.selected_avatar = options_selected_avatar
        global.selected_card_back = options_selected_cardback
        global.windowed_mode = options_windowed_mode
        global._apply_volume()
        global._apply_game_speed()

func _on_options_save_pressed():
    _play_confirm_sound()
    var global = get_node_or_null("/root/Global")
    if global:
        global.game_volume = options_volume_value
        global.game_speed = options_selected_speed
        global.selected_avatar = options_selected_avatar
        global.selected_card_back = options_selected_cardback
        global.windowed_mode = options_windowed_mode
        global._apply_volume()
        global._apply_game_speed()
        global._apply_window_mode()
        global.save_player_data()

    if options_panel:
        options_panel.queue_free()
        options_panel = null

func _on_options_back_pressed():
    _play_confirm_sound()
    if options_panel:
        options_panel.queue_free()
        options_panel = null

func _on_exit_button_pressed():
    _play_confirm_sound()
    get_tree().quit()


func _input(event):

    if credits.visible and credits.modulate.a >= 0.9 and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _play_confirm_sound()
        _close_credits()
        return


    if event is InputEventMouseButton and event.pressed and can_skip:
        if current_state == MenuState.INTRO_VIDEO or current_state == MenuState.MENU_VIDEO:
            video_player.stop()
            on_video_finished()


    if event is InputEventKey and event.pressed and current_state == MenuState.NAME_INPUT:
        if event.keycode == KEY_ENTER:
            _on_confirm_button_pressed()


func _on_vs_1_button_pressed() -> void :
    _play_confirm_sound()

    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/FreePlay.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/FreePlay.tscn")
    )

func _on_tournament_button_pressed() -> void :
    pass


func _on_online_button_pressed() -> void :
    pass


func _on_back_button_pressed() -> void :
    _play_confirm_sound()
    freeplay_buttons.visible = false
    menu_buttons.visible = true


func _play_confirm_sound():

    var sound_path = "res://assets/sounds/sfx/confirmbutton.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()


func _on_credits_button_pressed() -> void :
    _play_confirm_sound()


    credits_text.position.y = original_credits_text_y


    var out_tween = create_tween()
    out_tween.tween_property(ui, "modulate", Color(1, 1, 1, 0), 0.5)
    out_tween.tween_callback( func(): ui.visible = false)


    credits.visible = true
    credits.modulate = Color(1, 1, 1, 0)

    if credits_tween:
        credits_tween.kill()

    credits_tween = create_tween()
    credits_tween.set_parallel(true)
    credits_tween.tween_property(credits, "modulate", Color(1, 1, 1, 1), 1.0)

    var target_y = original_credits_text_y - 5400.0
    credits_tween.tween_property(credits_text, "position:y", target_y, 60.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


    credits_tween.chain().tween_callback( func(): _close_credits())

func _close_credits() -> void :
    if credits_tween:
        credits_tween.kill()

    var close_tween = create_tween()
    close_tween.tween_property(credits, "modulate", Color(1, 1, 1, 0), 0.5)
    close_tween.tween_callback( func():
        credits.visible = false
        ui.visible = true
        var ui_in_tween = create_tween()
        ui_in_tween.tween_property(ui, "modulate", Color(1, 1, 1, 1), 0.5)
    )

func _on_delete_save_button_pressed() -> void :
    if not waiting_for_delete_confirmation:
        _play_confirm_sound()
        waiting_for_delete_confirmation = true
        if delete_save_button:
            delete_save_button.text = "SURE?"


            var timer = get_tree().create_timer(3.0)
            timer.timeout.connect( func():
                waiting_for_delete_confirmation = false
                if is_instance_valid(delete_save_button):
                    delete_save_button.text = "DELETE\nSAVE DATA"
            )
        return

    _play_confirm_sound()


    var target_save_file = Global.get_save_path("player_save.dat")
    var target_deck_file = Global.get_save_path("player_deck.dat")


    if FileAccess.file_exists(target_save_file):
        DirAccess.remove_absolute(target_save_file)
        print("Save deletado: ", target_save_file)

    if FileAccess.file_exists(target_deck_file):
        DirAccess.remove_absolute(target_deck_file)
        print("Deck deletado: ", target_deck_file)


    Global.gold = 0
    Global.wins = 0
    Global.losses = 0
    Global.campaign_step = 0
    Global.enemy_stats.clear()
    Global.recently_unlocked.clear()
    Global.unlocked_duelists.clear()
    Global.player_deck_slots = [[], [], []]


    if has_node("/root/PlayerDeck"):
        var player_deck_node = get_node("/root/PlayerDeck")
        player_deck_node.create_starter_deck()
        player_deck_node.save_deck()

    Global.initialize_new_player()


    get_tree().quit()
