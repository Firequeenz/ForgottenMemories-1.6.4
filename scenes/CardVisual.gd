extends TextureButton


signal attack_requested(card_visual)
signal change_position_requested(card_visual)
signal card_selected(visual_card)
signal hovered(card_visual)
signal unhovered(card_visual)
signal activate_requested(card_visual)


const COLOR_BUFF = Color(0.0, 0.433, 0.785, 1.0)
const COLOR_DEBUFF = Color(0.784, 0.0, 0.122, 1.0)
const COLOR_DEFAULT = Color.BLACK
const ATTR_POS_SPELL = Vector2(155, 432)
const STAR_TEXTURE = preload("res://assets/cards/star.png")
const HOLO_SHADER = preload("res://assets/shaders/holographic.gdshader")
const DEBUG_STAT_COLORS = false


const MONSTER_CATEGORIES = [
    CardData.CardCategory.NORMAL_MONSTER, 
    CardData.CardCategory.EFFECT_MONSTER, 
    CardData.CardCategory.FUSION_MONSTER, 
    CardData.CardCategory.RITUAL_MONSTER, 
    CardData.CardCategory.SYNCHRO_MONSTER, 
    CardData.CardCategory.XYZ_MONSTER, 
    CardData.CardCategory.PENDULUM_MONSTER, 
    CardData.CardCategory.LINK_MONSTER
]


var my_card_data: CardData
var hand_index: int = -1
var is_fusion_style: bool = false
var is_player_card: bool = false
var is_exhausted: bool = false
var is_face_down: bool = false
var is_selected: bool = false
var original_y_position: float = 0.0
var buttons_active: bool = false
var hover_tween: Tween = null
var _last_discard_time: int = 0
var _card_discard_delay_offset: float = 0.0
var duel_manager: Node = null


@onready var art_tex = $ArtTexture
@onready var frame_tex = $FrameTexture
@onready var attr_tex = $AttributeIcon
@onready var type_tex = $TypeIcon
@onready var atk_lbl = $AtkLabel
@onready var def_lbl = $DefLabel
@onready var level_container = $LevelContainer
@onready var highlight = $HighlightBorder
@onready var order_icon = $OrderIcon
@onready var action_buttons = $ActionButtons
@onready var btn_attack = $ActionButtons / BtnAttack
@onready var btn_position = $ActionButtons / BtnPosition
@onready var btn_activate = $ActionButtons / BtnActivate
@onready var audio_player: AudioStreamPlayer = null


func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP

    _setup_children_filters()
    _setup_ui_elements()
    _connect_signals()

    original_y_position = position.y

    if action_buttons:
        action_buttons.visible = false

func _setup_children_filters():
    for child in get_children():
        if not child is Control:
            continue

        if child.name == "ActionButtons":
            child.mouse_filter = Control.MOUSE_FILTER_STOP
            for btn in child.get_children():
                if btn is Control:
                    btn.mouse_filter = Control.MOUSE_FILTER_STOP
                    btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        else:
            child.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _setup_ui_elements():
    if has_node("ActionButtons"):
        action_buttons.mouse_filter = Control.MOUSE_FILTER_PASS
        action_buttons.visible = false

    if has_node("HighlightBorder"):
        highlight.visible = false

    if has_node("OrderIcon"):
        order_icon.visible = false

    if btn_attack and btn_position:
        btn_attack.mouse_filter = Control.MOUSE_FILTER_STOP
        btn_position.mouse_filter = Control.MOUSE_FILTER_STOP

func _connect_signals():
    gui_input.connect(_on_gui_input)
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

    if btn_attack:
        btn_attack.pressed.connect(_on_attack_pressed)
        btn_attack.mouse_entered.connect(_on_button_hover.bind(btn_attack))
        btn_attack.mouse_exited.connect(_on_button_unhover.bind(btn_attack))

    if btn_position:
        btn_position.pressed.connect(_on_position_pressed)
        btn_position.mouse_entered.connect(_on_button_hover.bind(btn_position))
        btn_position.mouse_exited.connect(_on_button_unhover.bind(btn_position))

    if btn_activate:
        btn_activate.pressed.connect(_on_activate_pressed)
        btn_activate.mouse_entered.connect(_on_button_hover.bind(btn_activate))
        btn_activate.mouse_exited.connect(_on_button_unhover.bind(btn_activate))


func set_card_data(card: CardData, index: int, is_fusion_result: bool = false):
    my_card_data = card
    hand_index = index


    is_fusion_style = _calculate_fusion_style(card, is_fusion_result)


    _load_card_art(card.id)


    _update_frame_visual()


    _configure_card_layout(card)

func _calculate_fusion_style(card: CardData, is_fusion_result: bool) -> bool:
    var is_monster = card.category in MONSTER_CATEGORIES

    if is_monster:
        return is_fusion_result or card.category == CardData.CardCategory.FUSION_MONSTER
    else:
        return false

func _load_card_art(card_id: int):
    if not art_tex:
        return

    var art_path = "res://assets/cards/art/%d.png" % card_id
    art_tex.texture = load(art_path) if ResourceLoader.exists(art_path) else load("res://icon.svg")

func set_owner_is_player(value: bool):
    is_player_card = value


func _update_frame_visual():
    if not frame_tex or not my_card_data:
        return

    var frame_path = _get_frame_path(my_card_data, is_fusion_style)

    if ResourceLoader.exists(frame_path):
        frame_tex.texture = load(frame_path)


        if frame_path.contains("fullarts/"):
            if not frame_tex.material:
                var mat = ShaderMaterial.new()
                mat.shader = HOLO_SHADER
                frame_tex.material = mat

            if art_tex:
                art_tex.visible = false
        else:

            frame_tex.material = null
            if art_tex and not is_face_down:
                art_tex.visible = true

func _get_frame_path(card: CardData, is_fusion: bool) -> String:

    var special_path = "res://assets/cards/fullarts/%d.png" % card.id
    var global = get_node_or_null("/root/Global")

    if global and global.is_special_frame_unlocked(card.id):
        if ResourceLoader.exists(special_path):
            return special_path


    var base_folder = "res://assets/cards/frames/"

    if card.category == CardData.CardCategory.FUSION_MONSTER or is_fusion:
        return base_folder + "fusion_monster.png"

    match card.category:
        CardData.CardCategory.EFFECT_MONSTER:
            return base_folder + "effect_monster.png"
        CardData.CardCategory.RITUAL_MONSTER:
            return base_folder + "ritual_monster.png"
        CardData.CardCategory.SYNCHRO_MONSTER:
            return base_folder + "synchro_monster.png"
        CardData.CardCategory.XYZ_MONSTER:
            return base_folder + "xyz_monster.png"
        CardData.CardCategory.PENDULUM_MONSTER:
            return base_folder + "pendulum_monster.png"
        CardData.CardCategory.LINK_MONSTER:
            return base_folder + "link_monster.png"
        CardData.CardCategory.MAGIC:
            return base_folder + "magic.png"
        CardData.CardCategory.TRAP:
            return base_folder + "trap.png"
        _:
            return base_folder + "normal_monster.png"


func set_face_down(value: bool):
    is_face_down = value

    if is_face_down:
        _apply_face_down_visual()
    else:
        _apply_face_up_visual()

func _apply_face_down_visual():
    var card_back_path = "res://assets/cards/card_back.png"
    if has_node("/root/Global"):
        card_back_path = get_node("/root/Global").get_card_back_texture_path()

    if art_tex:
        art_tex.texture = load(card_back_path) if ResourceLoader.exists(card_back_path) else load("res://icon.svg")
        art_tex.visible = true


    if frame_tex: frame_tex.visible = false
    if atk_lbl: atk_lbl.visible = false
    if def_lbl: def_lbl.visible = false
    if attr_tex: attr_tex.visible = false
    if type_tex: type_tex.visible = false
    if level_container: level_container.visible = false

func _apply_face_up_visual():
    if frame_tex:
        frame_tex.visible = true

    if my_card_data:
        _load_card_art(my_card_data.id)
        _configure_card_layout(my_card_data)
        _update_frame_visual()


func _configure_card_layout(card: CardData):
    if not card:
        return

    var is_monster = _is_monster(card)


    if atk_lbl: atk_lbl.visible = is_monster
    if def_lbl: def_lbl.visible = is_monster
    if level_container: level_container.visible = is_monster
    if type_tex: type_tex.visible = is_monster
    if attr_tex: attr_tex.visible = true

    if is_monster:
        _configure_monster_layout(card)
    else:
        _configure_spell_trap_layout(card)

func _configure_monster_layout(card: CardData):

    if attr_tex:
        _load_texture(attr_tex, "attributes", card.attribute)


    if type_tex:
        _load_texture(type_tex, "types", card.type)


    update_stats_display()
    update_level_display(card.level)

func _configure_spell_trap_layout(card: CardData):
    if attr_tex:
        attr_tex.position = ATTR_POS_SPELL


        var icon_name = "magic" if card.category == CardData.CardCategory.MAGIC else "trap"
        _load_texture(attr_tex, "attributes", icon_name)

    update_level_display(0)

func _load_texture(texture_node: TextureRect, folder: String, icon_name: String):
    if not texture_node:
        return

    var clean_name = icon_name.to_lower().replace(" ", "-")
    var path1 = "res://assets/cards/%s/%s.png" % [folder, clean_name]
    var path2 = "res://assets/cards/%s/%s.png" % [folder, icon_name]
    var path3 = "res://assets/cards/%s/%s.png" % [folder, icon_name.to_lower()]
    var path4 = "res://assets/cards/%s/%s.png" % [folder, icon_name.to_lower().replace("-", " ")]

    for path in [path1, path2, path3, path4]:
        if ResourceLoader.exists(path) or FileAccess.file_exists(path + ".import"):
            texture_node.texture = load(path)
            return


func update_stats_display():
    if not my_card_data or not atk_lbl or not def_lbl:
        return

    var db_card = CardDatabase.get_card(my_card_data.id)

    if DEBUG_STAT_COLORS:
        if db_card == null:
            print("  ❌ DATABASE CARD IS NULL (fusion not in database?)")
        else:
            var atk_color = _get_stat_color(my_card_data.atk, db_card.atk)
            var def_color = _get_stat_color(my_card_data.def, db_card.def)
            print("  Expected ATK color: ", atk_color, " (", _color_name(atk_color), ")")
            print("  Expected DEF color: ", def_color, " (", _color_name(def_color), ")")
    var current_atk = my_card_data.atk
    var current_def = my_card_data.def

    atk_lbl.text = str(max(0, current_atk))
    def_lbl.text = str(max(0, current_def))

    atk_lbl.modulate = _get_stat_color(current_atk, db_card.atk)
    def_lbl.modulate = _get_stat_color(current_def, db_card.def)

    adjust_label_scale(atk_lbl, atk_lbl.size.x)
    adjust_label_scale(def_lbl, def_lbl.size.x)

func update_stats_visual(new_atk: int, new_def: int, original_atk: int = -1, original_def: int = -1):
    if not atk_lbl or not def_lbl:
        return

    atk_lbl.text = str(max(0, new_atk))
    def_lbl.text = str(max(0, new_def))


    var base_atk: int
    var base_def: int


    if is_fusion_style or (my_card_data and my_card_data.category == CardData.CardCategory.FUSION_MONSTER):
        print("É fusão, usando my_card_data")


        base_atk = my_card_data.atk if my_card_data else new_atk
        base_def = my_card_data.def if my_card_data else new_def
    elif original_atk != -1 and original_def != -1:
        print("Usando parâmetros recebidos")

        base_atk = original_atk
        base_def = original_def
    else:

        print("Não é fusão, tentando CardDatabase")
        var db_card = CardDatabase.get_card(my_card_data.id) if my_card_data else null
        if db_card:
            print("Encontrou no CardDatabase")
            base_atk = db_card.atk
            base_def = db_card.def
        else:
            print("Não encontrou no CardDatabase, usando valores atuais")

            base_atk = new_atk
            base_def = new_def

    atk_lbl.modulate = _get_stat_color(new_atk, base_atk)
    def_lbl.modulate = _get_stat_color(new_def, base_def)

    adjust_label_scale(atk_lbl, atk_lbl.size.x)
    adjust_label_scale(def_lbl, def_lbl.size.x)

func _get_stat_color(current_val: int, base_val: int) -> Color:
    if current_val > base_val:
        return COLOR_BUFF
    elif current_val < base_val:
        return COLOR_DEBUFF
    else:
        return COLOR_DEFAULT

func adjust_label_scale(label: Label, max_width: float):
    if not label:
        return

    label.scale = Vector2(1, 1)

    var font = label.label_settings.font if label.label_settings else label.get_theme_font("font")
    var font_size = label.label_settings.font_size if label.label_settings else label.get_theme_font_size("font_size")
    var text_size = font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)

    if text_size.x > max_width:
        var new_scale = max_width / text_size.x
        label.scale = Vector2(new_scale, new_scale)
        label.pivot_offset = label.size / 2
    else:
        label.pivot_offset = Vector2.ZERO


func update_level_display(level_count: int):
    if not level_container:
        return


    for child in level_container.get_children():
        child.queue_free()

    if level_count <= 0:
        return


    for i in range(level_count):
        var star = TextureRect.new()
        star.texture = STAR_TEXTURE
        star.expand_mode = TextureRect.EXPAND_FIT_WIDTH
        star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        star.custom_minimum_size = Vector2(16, 14)
        level_container.add_child(star)


func animate_stats_bonus(target_atk: int, target_def: int, original_atk: int = -1, original_def: int = -1, duration: float = 0.5):
    if my_card_data == null:
        return

    var start_atk = int(atk_lbl.text)
    var start_def = int(def_lbl.text)

    if start_atk == target_atk and start_def == target_def:
        return


    var base_atk: int
    var base_def: int

    if original_atk != -1 and original_def != -1:
        base_atk = original_atk
        base_def = original_def
    else:
        var db_card = CardDatabase.get_card(my_card_data.id)
        base_atk = db_card.atk
        base_def = db_card.def

    var final_atk_color = _get_stat_color(target_atk, base_atk)
    var final_def_color = _get_stat_color(target_def, base_def)
    var final_modulate_color = Color(0.6, 0.6, 0.6) if is_exhausted else Color.WHITE


    self.modulate = Color(1.5, 1.5, 1.3)


    if not is_face_down:
        if target_atk > start_atk or target_def > start_def:
            _play_statsup_sound()

        if target_atk < start_atk or target_def < start_def:
            _play_statsdown_sound()

    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)

    tween.tween_property(self, "modulate", final_modulate_color, duration)

    if start_atk != target_atk:
        tween.tween_method( func(val): atk_lbl.text = str(max(0, val)), start_atk, target_atk, duration)
        atk_lbl.modulate = final_atk_color

    if start_def != target_def:
        tween.tween_method( func(val): def_lbl.text = str(max(0, val)), start_def, target_def, duration)
        def_lbl.modulate = final_def_color

    await tween.finished
    self.modulate = final_modulate_color


func update_selection_visual(selection_order: int):
    if not order_icon:
        return

    if selection_order > 0:

        is_selected = true

        if hover_tween and hover_tween.is_running():
            hover_tween.kill()

        position = Vector2(0, -100)




        var icon_path = "res://assets/cards/s%d.png" % selection_order
        if ResourceLoader.exists(icon_path):
            order_icon.texture = load(icon_path)
            order_icon.visible = true
    else:

        is_selected = false

        position = Vector2(0, 0)


        order_icon.visible = false

func deselect_card():
    is_selected = false
    order_icon.visible = false


    if hand_index != -1:
        position.y = 0
        original_y_position = 0
    else:
        position.y = 0
        original_y_position = 0


    if highlight:
        highlight.visible = false
    if action_buttons:
        action_buttons.visible = false

func force_reset_hover_position():
    "Função de emergência para resetar a posição da carta.\n    Usada em casos onde a carta pode ter ficado travada em posição intermediária."


    if hover_tween and hover_tween.is_running():
        hover_tween.kill()


    if hand_index != -1:
        position.y = original_y_position


func set_exhausted(value: bool):
    is_exhausted = value

    if is_exhausted:
        modulate = Color(0.5, 0.5, 0.5)

        mouse_filter = Control.MOUSE_FILTER_STOP
        if action_buttons:
            action_buttons.visible = false
    else:

        modulate = Color.WHITE
        mouse_filter = Control.MOUSE_FILTER_STOP


func set_clickable(enabled: bool):
    var filter_mode = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_PASS
    mouse_filter = filter_mode

    for child in get_all_children(self):
        if child is Control:
            child.mouse_filter = filter_mode


func _on_mouse_entered():

    var is_in_hand = (hand_index != -1)


    if highlight:
        highlight.visible = true
    hovered.emit(self)


    if is_selected:
        return


    if is_in_hand:

        if hover_tween and hover_tween.is_running():
            hover_tween.kill()



        hover_tween = create_tween()
        hover_tween.set_trans(Tween.TRANS_CUBIC)
        hover_tween.set_ease(Tween.EASE_OUT)
        hover_tween.tween_property(self, "position:y", original_y_position - 30, 0.2)




func _on_mouse_exited():
    await get_tree().process_frame


    unhovered.emit(self)


    if is_selected:
        return


    var is_in_hand = (hand_index != -1)


    if is_in_hand:

        if hover_tween and hover_tween.is_running():
            hover_tween.kill()


        hover_tween = create_tween()
        hover_tween.set_trans(Tween.TRANS_CUBIC)
        hover_tween.set_ease(Tween.EASE_IN)
        hover_tween.tween_property(self, "position:y", original_y_position, 0.2)

    var mouse_pos = get_local_mouse_position()
    var rect = Rect2(Vector2.ZERO, size)

    if not rect.has_point(mouse_pos):
        if highlight:
            highlight.visible = false



func _show_action_buttons():
    if not action_buttons:
        return

    var is_on_field = (hand_index == -1)

    if not is_on_field:
        action_buttons.visible = false
        return

    action_buttons.visible = true


    if btn_attack: btn_attack.visible = false
    if btn_position: btn_position.visible = false
    if btn_activate: btn_activate.visible = false

    var is_monster = _is_monster(my_card_data)

    if is_monster:
        if btn_attack: btn_attack.visible = true
        if btn_position: btn_position.visible = true
    else:
        if btn_activate: btn_activate.visible = true


func _on_button_hover(button):
    button.modulate = Color(0.392, 0.392, 0.392, 1.0)

func _on_button_unhover(button):
    button.modulate = Color(1, 1, 1, 1)


func apply_attack_glow():
    if is_exhausted:
        set_exhausted(true)
    else:

        var tween = create_tween()
        tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.2)

func remove_attack_glow():
    if is_exhausted:
        set_exhausted(true)
    else:

        var tween = create_tween()
        tween.tween_property(self, "modulate", Color.WHITE, 0.2)

func _on_attack_pressed(_is_mobile_btn: bool = false):
    reset_selection_visual()

    apply_attack_glow()


    if action_buttons:
        action_buttons.visible = false
        buttons_active = false
        is_selected = false

    if duel_manager != null:
        var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
        var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
        var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")
        if mob_atk_btn: mob_atk_btn.hide()
        if mob_def_btn: mob_def_btn.hide()
        if mob_act_btn: mob_act_btn.hide()


    attack_requested.emit(self)

func _on_position_pressed(_is_mobile_btn: bool = false):
    reset_selection_visual()
    if action_buttons:
        action_buttons.visible = false
        buttons_active = false
        is_selected = false

    if duel_manager != null:
        var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
        var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
        var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")
        if mob_atk_btn: mob_atk_btn.hide()
        if mob_def_btn: mob_def_btn.hide()
        if mob_act_btn: mob_act_btn.hide()


    change_position_requested.emit(self)

func _on_activate_pressed(_is_mobile_btn: bool = false):
    reset_selection_visual()
    if action_buttons:
        action_buttons.visible = false
        buttons_active = false
        is_selected = false

    if duel_manager != null:
        var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
        var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
        var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")
        if mob_atk_btn: mob_atk_btn.hide()
        if mob_def_btn: mob_def_btn.hide()
        if mob_act_btn: mob_act_btn.hide()


    activate_requested.emit(self)

func reset_selection_visual():
    "Reseta todos os efeitos visuais de seleção"
    if is_exhausted:
        set_exhausted(true)
    else:

        var tween = create_tween()
        tween.tween_property(self, "modulate", Color.WHITE, 0.2)


    if highlight:
        highlight.visible = false

func toggle_action_buttons():
    if not action_buttons:
        return

    var is_on_field = (hand_index == -1)

    if not is_on_field:
        return





    if not buttons_active and duel_manager != null:
        if duel_manager.last_card_with_buttons != null and duel_manager.last_card_with_buttons != self:
            var prev_card = duel_manager.last_card_with_buttons
            if is_instance_valid(prev_card) and prev_card.has_method("hide_action_buttons"):
                prev_card.hide_action_buttons()
                prev_card.reset_selection_visual()


    buttons_active = not buttons_active
    action_buttons.visible = buttons_active

    if buttons_active:

        var is_monster = _is_monster(my_card_data)

        if btn_attack: btn_attack.visible = is_monster
        if btn_position: btn_position.visible = is_monster
        if btn_activate: btn_activate.visible = not is_monster


        if duel_manager != null:
            var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
            var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
            var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")

            if mob_atk_btn:
                mob_atk_btn.visible = is_monster
                if is_monster:

                    var callable = Callable(self, "_on_attack_pressed").bind(true)
                    for conn in mob_atk_btn.pressed.get_connections():
                        mob_atk_btn.pressed.disconnect(conn["callable"])
                    mob_atk_btn.pressed.connect(callable)

            if mob_def_btn:
                mob_def_btn.visible = is_monster
                if is_monster:
                    var callable = Callable(self, "_on_position_pressed").bind(true)
                    for conn in mob_def_btn.pressed.get_connections():
                        mob_def_btn.pressed.disconnect(conn["callable"])
                    mob_def_btn.pressed.connect(callable)

            if mob_act_btn:
                mob_act_btn.visible = not is_monster
                if not is_monster:
                    var callable = Callable(self, "_on_activate_pressed").bind(true)
                    for conn in mob_act_btn.pressed.get_connections():
                        mob_act_btn.pressed.disconnect(conn["callable"])
                    mob_act_btn.pressed.connect(callable)


        if highlight:
            highlight.visible = true


        is_selected = true


        var tween = create_tween()
        tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.1)


        if duel_manager != null:
            duel_manager.last_card_with_buttons = self
    else:

        reset_selection_visual()
        is_selected = false


        if duel_manager != null:
            duel_manager.last_card_with_buttons = null

        if duel_manager != null:
            var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
            var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
            var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")
            if mob_atk_btn: mob_atk_btn.hide()
            if mob_def_btn: mob_def_btn.hide()
            if mob_act_btn: mob_act_btn.hide()

func hide_action_buttons():

    if not action_buttons:
        return

    if duel_manager != null:
        var mob_atk_btn = duel_manager.get_node_or_null("CanvasLayer/AtkMobileButton")
        var mob_def_btn = duel_manager.get_node_or_null("CanvasLayer/ChangePosMobileButton")
        var mob_act_btn = duel_manager.get_node_or_null("CanvasLayer/ActivateMobileButton")

        if mob_atk_btn: mob_atk_btn.hide()
        if mob_def_btn: mob_def_btn.hide()
        if mob_act_btn: mob_act_btn.hide()

    buttons_active = false
    action_buttons.visible = false
    is_selected = false






func _on_gui_input(event):
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            card_selected.emit(self)

            if is_player_card and not is_exhausted and hand_index == -1:
                toggle_action_buttons()

func _on_pressed():
    card_selected.emit(self)

    if is_player_card and not is_exhausted and hand_index == -1:
        toggle_action_buttons()


func _is_monster(card: CardData) -> bool:
    return card.category in MONSTER_CATEGORIES

func get_all_children(node) -> Array:
    var nodes = []
    for child in node.get_children():
        nodes.append(child)
        if child.get_child_count() > 0:
            nodes.append_array(get_all_children(child))
    return nodes


func _update_atk_text(value: int):
    atk_lbl.text = str(value)

func _update_def_text(value: int):
    def_lbl.text = str(value)


func _color_name(color: Color) -> String:
    if color == COLOR_BUFF:
        return "BLUE"
    elif color == COLOR_DEBUFF:
        return "RED"
    elif color == COLOR_DEFAULT:
        return "BLACK"
    else:
        return "UNKNOWN"

func _play_statsup_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/statsup.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _play_statsdown_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/statsdown.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)
