extends Control

signal hovered
signal unhovered
signal clicked
signal add_clicked
signal remove_clicked

@onready var id_label = $HBoxContainer / IDLabel
@onready var name_label = $HBoxContainer / NameLabel
@onready var stats_label = $HBoxContainer / StatsLabel
@onready var type_icon = $HBoxContainer / TypeLabel
@onready var attr_icon = $HBoxContainer / AttrLabel
@onready var gs_icon = $HBoxContainer / GSLabel
@onready var deck_icon = $HBoxContainer / DeckIcon
@onready var deck_count_label = $HBoxContainer / DeckCountLabel
@onready var chest_icon = $HBoxContainer / ChestIcon
@onready var chest_count_label = $HBoxContainer / ChestCountLabel
@onready var add_button = $HBoxContainer / AddButton
@onready var remove_button = $HBoxContainer / RemoveButton

var card_id: int = -1
var is_selectable: bool = true

func _ready():

    custom_minimum_size.y = 50
    size_flags_vertical = Control.SIZE_EXPAND_FILL

    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    gui_input.connect(_on_gui_input)
    add_button.pressed.connect( func(): add_clicked.emit())
    remove_button.pressed.connect( func(): remove_clicked.emit())

    var style = StyleBoxFlat.new()
    style.bg_color = Color(0.1, 0.1, 0.1, 0.05)
    style.content_margin_top = 2
    style.content_margin_bottom = 2
    add_theme_stylebox_override("panel", style)

func setup(card_id: int, card_data: CardData, count_in_deck: int, chest_count: int):
    self.card_id = card_id


    id_label.custom_minimum_size.x = 80
    name_label.custom_minimum_size.x = 480
    stats_label.custom_minimum_size.x = 220
    type_icon.custom_minimum_size.x = 80
    attr_icon.custom_minimum_size.x = 80
    gs_icon.custom_minimum_size.x = 80
    chest_icon.custom_minimum_size.x = 40
    chest_count_label.custom_minimum_size.x = 30
    deck_icon.custom_minimum_size.x = 40
    deck_count_label.custom_minimum_size.x = 30
    add_button.custom_minimum_size.x = 60
    remove_button.custom_minimum_size.x = 60


    if has_node("/root/Global") and get_node("/root/Global").is_recently_unlocked(card_id):
        id_label.text = "NEW!"
        id_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
    else:
        id_label.text = "#%04d" % card_id
        id_label.remove_theme_color_override("font_color")
    name_label.text = card_data.name
    _load_icon(type_icon, "types", card_data.type)
    _load_icon(attr_icon, "attributes", card_data.attribute)
    _load_icon(gs_icon, "guardianstar", card_data.guardian_star)


    if _is_monster(card_data):
        stats_label.text = "ATK: %d / DEF: %d" % [card_data.atk, card_data.def]
    else:
        stats_label.text = ""
        _load_icon(type_icon, "types", card_data.type)


    chest_icon.texture = load("res://assets/cards/chest.png")
    chest_count_label.text = ": %d" % chest_count
    deck_icon.texture = load("res://assets/cards/deck.png")
    deck_count_label.text = ": %d" % count_in_deck

    var max_copies_allowed = card_data.limit


    if count_in_deck >= max_copies_allowed:
        modulate = Color(1.0, 1.0, 1.0, 1.0)
        add_button.disabled = true
    else:
        modulate = Color.WHITE
        add_button.disabled = (chest_count == 0)

    remove_button.disabled = (count_in_deck == 0)

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
            return


    print("Ícone não encontrado: ", path1)
    icon_node.visible = false

func _is_monster(card_data: CardData) -> bool:
    if not card_data:
        return false
    return card_data.category in [
        CardData.CardCategory.NORMAL_MONSTER, 
        CardData.CardCategory.EFFECT_MONSTER, 
        CardData.CardCategory.FUSION_MONSTER, 
        CardData.CardCategory.RITUAL_MONSTER, 
        CardData.CardCategory.SYNCHRO_MONSTER, 
        CardData.CardCategory.XYZ_MONSTER, 
        CardData.CardCategory.PENDULUM_MONSTER, 
        CardData.CardCategory.LINK_MONSTER
    ]

func _on_mouse_entered():
    modulate = Color(0.984, 0.776, 0.0, 0.784)
    hovered.emit()

func _on_mouse_exited():
    modulate = Color.WHITE
    unhovered.emit()

func _on_gui_input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

        modulate = Color(0.983, 0.776, 0.0, 1.0)
        clicked.emit()


        var tween = create_tween()
        tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_delay(0.1)


func get_card_id() -> int:
    return card_id
