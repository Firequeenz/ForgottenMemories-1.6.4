extends Control


const INSPECTOR_SCALE = Vector2(0.83, 0.83)
const CARD_ORIGINAL_SIZE = Vector2(364, 530)


var card_scene = preload("res://scenes/CardVisual.tscn")


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


@onready var card_container = $CardPreviewContainer
@onready var atk_def_lbl = $VBoxContainer / InfoPanel / VBoxInfo / StatsHeader / AtkDefLabel
@onready var level_lbl = $VBoxContainer / InfoPanel / VBoxInfo / StatsHeader / LevelLabel
@onready var attr_icon = $VBoxContainer / InfoPanel / VBoxInfo / StatsHeader / AttributeIcon
@onready var type_icon = $VBoxContainer / InfoPanel / VBoxInfo / StatsHeader / TypeIcon
@onready var gs_icon = $VBoxContainer / InfoPanel / VBoxInfo / StatsHeader / GuardianStarIcon
@onready var name_lbl = $VBoxContainer / InfoPanel / VBoxInfo / NameLabel
@onready var type_lbl = $VBoxContainer / InfoPanel / VBoxInfo / TypeLabel
@onready var desc_lbl = $VBoxContainer / InfoPanel / VBoxInfo / DescLabel
@onready var attr_txt_lbl = $VBoxContainer / InfoPanel / VBoxInfo / AttributeLabel
@onready var gs_txt_lbl = $VBoxContainer / InfoPanel / VBoxInfo / GuardianStarLabel


var _original_pos: Vector2
var _slide_tween: Tween


func _ready():
    _original_pos = position
    visible = false

func _play_show_animation():
    visible = true

    position.x = - size.x

    if _slide_tween and _slide_tween.is_valid():
        _slide_tween.kill()

    _slide_tween = create_tween()
    _slide_tween.set_trans(Tween.TRANS_QUART)
    _slide_tween.set_ease(Tween.EASE_OUT)
    _slide_tween.tween_property(self, "position:x", _original_pos.x, 0.2)


func show_card(card_data: CardData):
    "Método simplificado para mostrar carta no DeckBuilder"
    if card_data == null:
        clear_info()
        return

    _clear_preview()
    _play_show_animation()


    var preview_card = card_scene.instantiate()
    card_container.add_child(preview_card)


    preview_card.set_card_data(card_data, -1, false)
    preview_card.scale = INSPECTOR_SCALE
    var target_pos = _calculate_centered_position()
    preview_card.position = Vector2(round(target_pos.x), round(target_pos.y))
    preview_card.set_anchors_preset(Control.PRESET_TOP_LEFT)


    preview_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
    if preview_card.has_method("set_clickable"):
        preview_card.set_clickable(false)


    _update_card_info_simple(card_data)

func _update_card_info_simple(card_data: CardData):
    "Versão simplificada para DeckBuilder"
    name_lbl.text = "[b][%s][/b]" % card_data.name
    desc_lbl.text = card_data.description

    if _is_monster(card_data):
        atk_def_lbl.text = "ATK/%d\nDEF/%d" % [card_data.atk, card_data.def]
        level_lbl.text = "★%d" % card_data.level
        type_lbl.text = "[b]Type:[/b] %s" % card_data.type
        attr_txt_lbl.text = "[b]Attribute:[/b] %s" % card_data.attribute
        gs_txt_lbl.text = "[b]Guardian Star:[/b] %s" % card_data.guardian_star

        _load_icon(type_icon, "types", card_data.type)
        _load_icon(attr_icon, "attributes", card_data.attribute)
        _load_icon(gs_icon, "guardianstar", card_data.guardian_star)


        attr_icon.visible = true
        attr_txt_lbl.visible = true
        gs_icon.visible = true
        gs_txt_lbl.visible = true
        type_icon.visible = true
    else:

        atk_def_lbl.text = "[MAGIC]" if card_data.category == CardData.CardCategory.MAGIC else "[TRAP]"
        level_lbl.text = ""
        type_lbl.text = "[b]Type:[/b] %s" % card_data.type


        attr_icon.visible = false
        attr_txt_lbl.visible = false
        gs_icon.visible = false
        gs_txt_lbl.visible = false
        type_icon.visible = false


func update_inspector(source_card_visual, is_hidden: bool):
    _clear_preview()

    if not _validate_input(source_card_visual, is_hidden):
        clear_info()
        return

    var card_data = source_card_visual.my_card_data
    _play_show_animation()


    var preview_card = _create_card_preview(card_data, source_card_visual)


    _update_card_info(card_data, source_card_visual, preview_card)


func _validate_input(source_card_visual, is_hidden: bool) -> bool:
    if source_card_visual == null or is_hidden:
        return false

    if source_card_visual.my_card_data == null:
        return false

    return true


func _create_card_preview(card_data: CardData, source_visual) -> Node:
    var preview_card = card_scene.instantiate()
    card_container.add_child(preview_card)


    var is_fusion = source_visual.is_fusion_style
    preview_card.set_card_data(card_data, -1, is_fusion)


    preview_card.scale = INSPECTOR_SCALE
    var target_pos = _calculate_centered_position()
    preview_card.position = Vector2(round(target_pos.x), round(target_pos.y))
    preview_card.set_anchors_preset(Control.PRESET_TOP_LEFT)


    preview_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
    if preview_card.has_method("set_clickable"):
        preview_card.set_clickable(false)
    if preview_card.has_method("set_owner_is_player"):
        preview_card.set_owner_is_player(false)


    var current_atk = int(source_visual.atk_lbl.text)
    var current_def = int(source_visual.def_lbl.text)
    preview_card.update_stats_visual(current_atk, current_def, card_data.atk, card_data.def)

    return preview_card

func _calculate_centered_position() -> Vector2:
    var scaled_size = CARD_ORIGINAL_SIZE * INSPECTOR_SCALE
    return (card_container.size / 2) - (scaled_size / 2)


func _update_card_info(card_data: CardData, source_visual, preview_card):
    name_lbl.text = "[b][%s][/b]" % card_data.name
    desc_lbl.text = card_data.description

    if _is_monster(card_data):
        _update_monster_info(card_data, source_visual)
    else:
        _update_spell_trap_info(card_data)

func _is_monster(card_data: CardData) -> bool:
    return card_data.category in MONSTER_CATEGORIES


func _update_monster_info(card_data: CardData, source_visual):
    var current_atk = int(source_visual.atk_lbl.text)
    var current_def = int(source_visual.def_lbl.text)


    atk_def_lbl.text = "ATK/%d\nDEF/%d" % [current_atk, current_def]
    level_lbl.text = "★%d" % card_data.level
    type_lbl.text = "[b]Type:[/b] %s" % card_data.type
    attr_txt_lbl.text = "[b]Attribute:[/b] %s" % card_data.attribute
    gs_txt_lbl.text = "[b]Guardian Star:[/b] %s" % card_data.guardian_star


    _load_icon(type_icon, "types", card_data.type)
    _load_icon(attr_icon, "attributes", card_data.attribute)
    _load_icon(gs_icon, "guardianstar", card_data.guardian_star)


    attr_txt_lbl.visible = true
    gs_txt_lbl.visible = true


func _update_spell_trap_info(card_data: CardData):

    level_lbl.text = ""


    var type_text = _get_spell_trap_type(card_data)
    var category_label = "[TRAP]" if card_data.category == CardData.CardCategory.TRAP else "[MAGIC]"

    atk_def_lbl.text = category_label
    type_lbl.text = "[b]Type:[/b] %s" % type_text


    _hide_monster_elements()

func _get_spell_trap_type(card_data: CardData) -> String:
    if card_data.category == CardData.CardCategory.TRAP:
        return "Trap Card"

    match card_data.type:
        "Equip": return "Equip Spell"
        "Field": return "Field Spell"
        _: return "Magic Card"

func _hide_monster_elements():
    attr_icon.visible = false
    attr_txt_lbl.visible = false
    gs_txt_lbl.visible = false
    type_icon.visible = false
    gs_icon.visible = false


func _load_icon(icon_node: TextureRect, folder: String, icon_name: String):
    var clean_name = icon_name.to_lower().replace(" ", "-")
    var path1 = "res://assets/cards/%s/%s.png" % [folder, clean_name]
    var path2 = "res://assets/cards/%s/%s.png" % [folder, icon_name]
    var path3 = "res://assets/cards/%s/%s.png" % [folder, icon_name.to_lower()]
    var path4 = "res://assets/cards/%s/%s.png" % [folder, icon_name.to_lower().replace("-", " ")]

    for path in [path1, path2, path3, path4]:
        if ResourceLoader.exists(path) or FileAccess.file_exists(path + ".import"):
            icon_node.texture = load(path)
            icon_node.visible = true
            icon_node.custom_minimum_size = Vector2(45, 45)
            icon_node.size = Vector2(45, 45)
            return

    icon_node.visible = false


func _clear_preview():
    for child in card_container.get_children():
        child.queue_free()



func set_card_data(card_data: CardData):
    if card_data == null:
        clear_info()
        return

    _clear_preview()
    _play_show_animation()


    var preview_card = card_scene.instantiate()
    card_container.add_child(preview_card)

    preview_card.set_card_data(card_data, -1, false)
    preview_card.scale = INSPECTOR_SCALE
    var target_pos = _calculate_centered_position()
    preview_card.position = Vector2(round(target_pos.x), round(target_pos.y))
    preview_card.set_anchors_preset(Control.PRESET_TOP_LEFT)

    preview_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
    if preview_card.has_method("set_clickable"):
        preview_card.set_clickable(false)


    name_lbl.text = "[b][%s][/b]" % card_data.name
    desc_lbl.text = card_data.description

    if _is_monster(card_data):
        atk_def_lbl.text = "ATK/%d\nDEF/%d" % [card_data.atk, card_data.def]
        level_lbl.text = "★%d" % card_data.level
        type_lbl.text = "[b]Type:[/b] %s" % card_data.type
        attr_txt_lbl.text = "[b]Attribute:[/b] %s" % card_data.attribute
        gs_txt_lbl.text = "[b]Guardian Star:[/b] %s" % card_data.guardian_star

        _load_icon(type_icon, "types", card_data.type)
        _load_icon(attr_icon, "attributes", card_data.attribute)
        _load_icon(gs_icon, "guardianstar", card_data.guardian_star)

        attr_txt_lbl.visible = true
        gs_txt_lbl.visible = true
    else:
        _update_spell_trap_info(card_data)


func clear_info():
    if _slide_tween and _slide_tween.is_valid():
        _slide_tween.kill()
    _clear_preview()
    visible = false
