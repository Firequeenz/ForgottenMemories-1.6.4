extends Control


const SORT_MODES = ["id", "name", "atk", "def", "type", "attribute", "new"]
const SORT_MODE_LABELS = ["ID", "NAME", "ATK", "DEF", "TYPE", "ATTR.", "NEW"]
const DECK_SIZE = 40


@onready var card_inspector = $CardInspector
@onready var chest_list = $Content / RightPanel / ChestScroll / ChestList
@onready var deck_list = $Content / RightPanel / DeckScroll / DeckList
@onready var chest_count_label = $Header / LeftPanel / ChestCount
@onready var deck_count_label = $Header / RightPanel / DeckCount
@onready var sort_buttons_container = $Header / CenterPanel / SortButtons
@onready var category_dropdown = $Header / CenterPanel / CategoryDropdown
@onready var sort_indicator = $StatusIndicators / SortIndicator
@onready var cat_indicator = $StatusIndicators / CatIndicator
@onready var deck_indicator = $StatusIndicators / DeckIndicator
@onready var chest_mode_button = $Footer / ModeButtonsContainer / ChestModeButton
@onready var deck_mode_button = $Footer / ModeButtonsContainer / DeckModeButton
@onready var save_button = $Footer / SaveButton
@onready var back_button = $Footer / BackButton
@onready var clear_deck_button = $Footer / ClearDeckButton
var save_slot_buttons: Array = []
var load_slot_buttons: Array = []
@onready var chest_scroll = $Content / RightPanel / ChestScroll
@onready var deck_scroll = $Content / RightPanel / DeckScroll
@onready var save_success_label = $Footer / SaveSuccess
@onready var save_error_label = $Footer / SaveError
@onready var search_bar = $Header / SearchBarContainer / SearchBar
@onready var search_button = $Header / SearchBarContainer / SearchButton
@onready var clear_search_button = $Header / SearchBarContainer / SearchBar / ClearSearchButton
@onready var audio_player: AudioStreamPlayer = null


var collection
var current_mode = "chest"
var current_sort_mode = "id"
var sort_ascending: bool = true
var current_filter_category: int = -1
var active_deck_slot: int = -1
var hovered_card_id = -1
var hover_timer = 0.0
var hover_delay = 0.3
var is_hovering = false
var search_text: String = ""
var is_searching: bool = false
var _last_discard_time: int = 0
var _card_discard_delay_offset: float = 0.0


var _chest_items: Dictionary = {}
var _deck_items: Dictionary = {}


var last_clicked_chest_id: int = -1
var last_clicked_chest_time: int = 0
var last_clicked_deck_id: int = -1
var last_clicked_deck_time: int = 0
const DOUBLE_CLICK_TIME_MS: int = 500


func _ready():

    if has_node("/root/CardCollection"):
        collection = get_node("/root/CardCollection")
        print("CardCollection carregada do nó /root")
    else:
        push_error("CardCollection não encontrada!")
        return


    setup_sort_buttons()
    setup_category_dropdown()
    setup_search_bar()
    switch_to_chest()
    update_counts()
    update_indicators()


    save_button.pressed.connect(_on_save_button_pressed)
    back_button.pressed.connect(_on_back_button_pressed)
    clear_deck_button.pressed.connect(_on_clear_deck_pressed)
    chest_mode_button.pressed.connect(switch_to_chest)
    deck_mode_button.pressed.connect(switch_to_deck)


    _setup_deck_slot_buttons()


    _play_bgm()


    save_success_label.visible = false
    save_error_label.visible = false


    check_deck_validity()


    chest_scroll.get_v_scroll_bar().custom_minimum_size.x = 30
    deck_scroll.get_v_scroll_bar().custom_minimum_size.x = 30

    print("=== DECKBUILDER INICIALIZADO ===")
    print("Modo atual: ", current_mode)
    print("Cartas no deck: ", collection.get_deck_count())
    print("Cartas desbloqueadas: ", collection.get_unlocked_card_ids().size())

    _setup_transition_effect()

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


func setup_search_bar():
    if search_bar:
        search_bar.text_changed.connect(_on_search_text_changed)
        search_bar.text_submitted.connect(_on_search_text_submitted)

    if search_button:
        search_button.pressed.connect(_on_search_button_pressed)

    if clear_search_button:
        clear_search_button.pressed.connect(_on_clear_search_pressed)
        clear_search_button.visible = false

func _on_search_text_changed(new_text: String):
    search_text = new_text.strip_edges()
    is_searching = search_text.length() > 0


    if clear_search_button:
        clear_search_button.visible = is_searching


    if current_mode == "chest":
        refresh_chest_list()
    else:
        refresh_deck_list()

func _on_search_text_submitted(new_text: String):
    _on_search_text_changed(new_text)

func _on_search_button_pressed():

    if search_bar:
        search_bar.grab_focus()

func _on_clear_search_pressed():
    if search_bar:
        search_bar.text = ""
        search_bar.release_focus()
    search_text = ""
    is_searching = false

    if clear_search_button:
        clear_search_button.visible = false


    if current_mode == "chest":
        refresh_chest_list()
    else:
        refresh_deck_list()


func setup_sort_buttons():

    for child in sort_buttons_container.get_children():
        child.queue_free()


    for i in range(SORT_MODES.size()):
        var button = Button.new()
        button.text = SORT_MODE_LABELS[i]
        button.custom_minimum_size = Vector2(130, 50)


        var base_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
        var font = FontVariation.new()
        font.base_font = base_font
        font.spacing_glyph = 2
        button.add_theme_font_override("font", font)
        button.add_theme_font_size_override("font_size", 35)
        button.add_theme_constant_override("outline_size", 10)
        button.add_theme_color_override("font_outline_color", Color.BLACK)
        button.toggle_mode = true
        button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        button.connect("pressed", _on_sort_button_pressed.bind(SORT_MODES[i]))


        var normal_style: = StyleBoxFlat.new()
        normal_style.bg_color = Color(0.393, 0.393, 0.393, 1.0)
        normal_style.content_margin_top = 10
        normal_style.corner_radius_top_left = 5
        normal_style.corner_radius_top_right = 5
        normal_style.corner_radius_bottom_left = 5
        normal_style.corner_radius_bottom_right = 5


        var hover_style: = StyleBoxFlat.new()
        hover_style.bg_color = Color(0.392, 0.392, 0.392, 0.863)
        hover_style.content_margin_top = 10
        hover_style.corner_radius_top_left = 5
        hover_style.corner_radius_top_right = 5
        hover_style.corner_radius_bottom_left = 5
        hover_style.corner_radius_bottom_right = 5


        var pressed_style: = StyleBoxFlat.new()
        pressed_style.bg_color = Color.BLACK
        pressed_style.content_margin_top = 10
        pressed_style.corner_radius_top_left = 5
        pressed_style.corner_radius_top_right = 5
        pressed_style.corner_radius_bottom_left = 5
        pressed_style.corner_radius_bottom_right = 5

        button.add_theme_stylebox_override("normal", normal_style)
        button.add_theme_stylebox_override("hover", hover_style)
        button.add_theme_stylebox_override("pressed", pressed_style)
        button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

        sort_buttons_container.add_child(button)


    if sort_buttons_container.get_child_count() > 0:
        var first_button = sort_buttons_container.get_child(0) as Button
        first_button.button_pressed = true


func setup_category_dropdown():
    if not category_dropdown: return

    category_dropdown.alignment = HORIZONTAL_ALIGNMENT_CENTER
    var popup = category_dropdown.get_popup()

    var font_res = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
    if font_res:
        var font_var = FontVariation.new()
        font_var.base_font = font_res
        popup.add_theme_font_override("font", font_var)
    popup.add_theme_font_size_override("font_size", 35)


    popup.add_theme_constant_override("v_separation", 10)
    popup.add_theme_constant_override("item_start_padding", 15)
    popup.add_theme_constant_override("item_end_padding", 15)

    category_dropdown.clear()


    var all_tex = load("res://assets/cards/categories/catall.png")
    if all_tex:
        category_dropdown.add_icon_item(all_tex, "")
    else:
        category_dropdown.add_item("ALL")
    category_dropdown.set_item_metadata(0, -1)


    var cat_configs = [
        {"name": "", "enum": CardData.CardCategory.NORMAL_MONSTER, "icon": "res://assets/cards/categories/catnormal.png"}, 
        {"name": "", "enum": CardData.CardCategory.EFFECT_MONSTER, "icon": "res://assets/cards/categories/cateffect.png"}, 
        {"name": "", "enum": CardData.CardCategory.FUSION_MONSTER, "icon": "res://assets/cards/categories/catfusion.png"}, 
        {"name": "", "enum": CardData.CardCategory.RITUAL_MONSTER, "icon": "res://assets/cards/categories/catritual.png"}, 
        {"name": "", "enum": CardData.CardCategory.SYNCHRO_MONSTER, "icon": "res://assets/cards/categories/catsynchro.png"}, 
        {"name": "", "enum": CardData.CardCategory.XYZ_MONSTER, "icon": "res://assets/cards/categories/catxyz.png"}, 
        {"name": "", "enum": CardData.CardCategory.PENDULUM_MONSTER, "icon": "res://assets/cards/categories/catpendulum.png"}, 
        {"name": "", "enum": CardData.CardCategory.LINK_MONSTER, "icon": "res://assets/cards/categories/catlink.png"}, 
        {"name": "", "enum": CardData.CardCategory.MAGIC, "icon": "res://assets/cards/categories/catmagic.png"}, 
        {"name": "", "enum": CardData.CardCategory.TRAP, "icon": "res://assets/cards/categories/cattrap.png"}
    ]

    var index = 1
    for config in cat_configs:
        var tex = load(config.icon) if ResourceLoader.exists(config.icon) else null
        if tex:
            category_dropdown.add_icon_item(tex, config.name)
        else:
            category_dropdown.add_item(config.name)

        category_dropdown.set_item_metadata(index, config.enum )
        index += 1

    category_dropdown.item_selected.connect(_on_category_selected)

func _on_category_selected(index: int):
    _play_confirm_sound()
    current_filter_category = category_dropdown.get_item_metadata(index)
    update_indicators()

    if current_mode == "chest":
        refresh_chest_list()
    else:
        refresh_deck_list()

func update_indicators():
    if sort_indicator:
        var order_str = "Asc." if sort_ascending else "Desc."
        sort_indicator.text = "Sort: " + current_sort_mode.to_upper() + " " + order_str

    if cat_indicator:
        var cat_name = "ALL"
        if category_dropdown and category_dropdown.selected > 0:
            var cat_enum = category_dropdown.get_item_metadata(category_dropdown.selected)
            match cat_enum:
                CardData.CardCategory.NORMAL_MONSTER: cat_name = "Normal"
                CardData.CardCategory.EFFECT_MONSTER: cat_name = "Effect"
                CardData.CardCategory.FUSION_MONSTER: cat_name = "Fusion"
                CardData.CardCategory.RITUAL_MONSTER: cat_name = "Ritual"
                CardData.CardCategory.SYNCHRO_MONSTER: cat_name = "Synchro"
                CardData.CardCategory.XYZ_MONSTER: cat_name = "XYZ"
                CardData.CardCategory.PENDULUM_MONSTER: cat_name = "Pendulum"
                CardData.CardCategory.LINK_MONSTER: cat_name = "Link"
                CardData.CardCategory.MAGIC: cat_name = "Magic"
                CardData.CardCategory.TRAP: cat_name = "Trap"
        cat_indicator.text = "Cat: " + cat_name

    if deck_indicator:
        if active_deck_slot >= 0:
            deck_indicator.text = "Deck: Slot " + str(active_deck_slot + 1)
        else:
            deck_indicator.text = "Deck: Unsaved"

func _on_sort_button_pressed(mode: String):
    _play_confirm_sound()

    if current_sort_mode == mode:
        sort_ascending = !sort_ascending
    else:
        current_sort_mode = mode

        sort_ascending = (mode == "id")


    for i in range(sort_buttons_container.get_child_count()):
        var button = sort_buttons_container.get_child(i) as Button
        if SORT_MODES[i] == mode:
            button.button_pressed = true
            button.text = SORT_MODE_LABELS[i] + (" ^" if sort_ascending else " v")
        else:
            button.button_pressed = false
            button.text = SORT_MODE_LABELS[i]

    update_indicators()


    if current_mode == "chest":
        refresh_chest_list()
    else:
        refresh_deck_list()



func switch_to_chest():
    current_mode = "chest"

    if chest_scroll:
        chest_scroll.visible = true
    if deck_scroll:
        deck_scroll.visible = false

    if chest_mode_button:
        chest_mode_button.modulate = Color(0.2, 0.5, 1.0)
    if deck_mode_button:
        deck_mode_button.modulate = Color.WHITE

    refresh_chest_list()
    print("Modo alterado para: Chest")

func switch_to_deck():
    current_mode = "deck"

    if chest_scroll:
        chest_scroll.visible = false
    if deck_scroll:
        deck_scroll.visible = true

    if chest_mode_button:
        chest_mode_button.modulate = Color.WHITE
    if deck_mode_button:
        deck_mode_button.modulate = Color(0.2, 0.5, 1.0)
        deck_mode_button.text = "DECK\n(%d/40)" % collection.get_deck_count()

    refresh_deck_list()
    print("Modo alterado para: Deck")



func refresh_chest_list():
    if not chest_list:
        print("Erro: chest_list não encontrado!")
        return

    if not collection:
        print("Erro: collection não disponível!")
        return


    for child in chest_list.get_children():
        child.queue_free()
    _chest_items.clear()


    var unlocked_ids = collection.get_unlocked_card_ids()
    var sorted_card_ids: Array = _sort_card_ids(unlocked_ids, current_sort_mode)


    if current_filter_category != -1:
        var filtered_by_cat = []
        for card_id in sorted_card_ids:
            var card = CardDatabase.get_card(card_id)
            if card and card.category == current_filter_category:
                filtered_by_cat.append(card_id)
        sorted_card_ids = filtered_by_cat


    if is_searching and search_text.length() > 0:
        sorted_card_ids = _filter_cards_by_search(sorted_card_ids)

    print("Cartas para mostrar no Chest: ", sorted_card_ids.size())
    if is_searching:
        print("Filtrando por: '", search_text, "'")


    for card_id in sorted_card_ids:
        var card_data = CardDatabase.get_card(card_id)
        if card_data:
            create_chest_item(card_id, card_data)


    if sorted_card_ids.size() == 0:
        var label = Label.new()
        if is_searching:
            label.text = "No cards found for: '%s'" % search_text
        else:
            label.text = "Empty!"
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
        chest_list.add_child(label)

func refresh_deck_list():
    if not deck_list:
        print("Erro: deck_list não encontrado!")
        return

    if not collection:
        print("Erro: collection não disponível!")
        return


    for child in deck_list.get_children():
        child.queue_free()
    _deck_items.clear()


    var deck_cards = collection.get_deck_cards()


    if current_filter_category != -1:
        var filtered_by_cat = []
        for card_id in deck_cards:
            var card = CardDatabase.get_card(card_id)
            if card and card.category == current_filter_category:
                filtered_by_cat.append(card_id)
        deck_cards = filtered_by_cat


    if is_searching and search_text.length() > 0:
        deck_cards = _filter_cards_by_search(deck_cards)

    if deck_cards.size() == 0:
        var label = Label.new()
        if is_searching:
            label.text = "No deck cards found for: '%s'" % search_text
        else:
            label.text = "Deck Empty!"
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
        deck_list.add_child(label)
        return


    var card_counts = {}
    for card_id in deck_cards:
        card_counts[card_id] = card_counts.get(card_id, 0) + 1


    var unique_ids = card_counts.keys()


    var sorted_ids = _sort_card_ids(unique_ids, current_sort_mode)

    for card_id in sorted_ids:
        var card_data = CardDatabase.get_card(card_id)
        if card_data:
            create_deck_item(card_id, card_data, card_counts[card_id])


func _filter_cards_by_search(card_ids: Array) -> Array:
    var filtered_ids: Array = []
    var search_lower = search_text.to_lower()

    for card_id in card_ids:
        var card_data = CardDatabase.get_card(card_id)
        if card_data:

            if search_lower in card_data.name.to_lower():
                filtered_ids.append(card_id)

            elif search_lower.is_valid_int() and str(card_id).contains(search_lower):
                filtered_ids.append(card_id)

            elif search_lower in card_data.type.to_lower():
                filtered_ids.append(card_id)
            elif search_lower in card_data.attribute.to_lower():
                filtered_ids.append(card_id)

    return filtered_ids


func _sort_card_ids(card_ids: Array, sort_mode: String) -> Array:
    "Ordena IDs de cartas baseado no modo de ordenação atual"
    var sorted_ids = card_ids.duplicate()

    match sort_mode:
        "id":
            sorted_ids.sort()
        "name":
            sorted_ids.sort_custom( func(a, b):
                var card_a = CardDatabase.get_card(a)
                var card_b = CardDatabase.get_card(b)
                if card_a and card_b:
                    return card_a.name < card_b.name
                return false
            )
        "atk":
            sorted_ids.sort_custom( func(a, b):
                var card_a = CardDatabase.get_card(a)
                var card_b = CardDatabase.get_card(b)
                if card_a and card_b:
                    return card_a.atk > card_b.atk
                return false
            )
        "def":
            sorted_ids.sort_custom( func(a, b):
                var card_a = CardDatabase.get_card(a)
                var card_b = CardDatabase.get_card(b)
                if card_a and card_b:
                    return card_a.def > card_b.def
                return false
            )
        "type":
            sorted_ids.sort_custom( func(a, b):
                var card_a = CardDatabase.get_card(a)
                var card_b = CardDatabase.get_card(b)
                if card_a and card_b:
                    return card_a.type < card_b.type
                return false
            )
        "attribute":
            sorted_ids.sort_custom( func(a, b):
                var card_a = CardDatabase.get_card(a)
                var card_b = CardDatabase.get_card(b)
                if card_a and card_b:
                    return card_a.attribute < card_b.attribute
                return false
            )
        "new":
            var global = get_node_or_null("/root/Global")
            if global:
                sorted_ids.sort_custom( func(a, b):
                    var a_new = global.is_recently_unlocked(a)
                    var b_new = global.is_recently_unlocked(b)
                    if a_new and not b_new:
                        return true
                    elif not a_new and b_new:
                        return false
                    elif a_new and b_new:
                        return global.recently_unlocked.find(a) < global.recently_unlocked.find(b)
                    else:
                        return a < b
                )


    if not sort_ascending and sort_mode in ["id", "name", "type", "attribute", "new"]:
        sorted_ids.reverse()
    elif sort_ascending and sort_mode in ["atk", "def"]:
        sorted_ids.reverse()

    return sorted_ids

func create_chest_item(card_id: int, card_data: CardData):
    var item = preload("res://scenes/deck_builder/ChestItem.tscn").instantiate()
    chest_list.add_child(item)
    _chest_items[card_id] = item


    var total_owned = collection.get_card_quantity(card_id)
    var deck_count = collection.get_card_quantity_in_deck(card_id)
    var chest_count = total_owned - deck_count
    var can_add = collection.can_add_to_deck(card_id)


    item.setup(
        card_id, 
        card_data, 
        chest_count, 
        deck_count, 
        can_add
    )


    item.hovered.connect(_on_item_hovered.bind(card_id))
    item.unhovered.connect(_on_item_unhovered)
    item.clicked.connect(_on_chest_item_clicked.bind(card_id))
    item.add_clicked.connect(_on_chest_item_clicked.bind(card_id))
    item.remove_clicked.connect(_on_deck_item_clicked.bind(card_id))

func create_deck_item(card_id: int, card_data: CardData, count_in_deck: int):
    var item = preload("res://scenes/deck_builder/DeckItem.tscn").instantiate()
    deck_list.add_child(item)
    _deck_items[card_id] = item


    var total_owned = collection.get_card_quantity(card_id)
    var chest_count = total_owned - count_in_deck
    item.setup(card_id, card_data, count_in_deck, chest_count)


    item.hovered.connect(_on_item_hovered.bind(card_id))
    item.unhovered.connect(_on_item_unhovered)
    item.clicked.connect(_on_deck_item_clicked.bind(card_id))
    item.add_clicked.connect(_on_chest_item_clicked.bind(card_id))
    item.remove_clicked.connect(_on_deck_item_clicked.bind(card_id))


func _on_item_hovered(card_id: int):
    hovered_card_id = card_id
    is_hovering = true
    hover_timer = 0.0
    show_card_inspector(card_id)

func _on_item_unhovered():
    is_hovering = false
    hovered_card_id = -1
    if card_inspector and card_inspector.has_method("clear_info"):
        card_inspector.clear_info()

func _on_chest_item_clicked(card_id: int):
    var os_name = OS.get_name()
    if os_name == "Android" or os_name == "iOS":
        var current_time = Time.get_ticks_msec()
        if last_clicked_chest_id == card_id and (current_time - last_clicked_chest_time) <= DOUBLE_CLICK_TIME_MS:
            last_clicked_chest_id = -1
        else:
            last_clicked_chest_id = card_id
            last_clicked_chest_time = current_time
            show_card_inspector(card_id)
            return

    if collection.add_to_deck(card_id):
        _play_swipe_sound()
        update_counts()
        check_deck_validity()

        _update_chest_item(card_id)
        _update_deck_item_after_add(card_id)
        print("Carta ", card_id, " adicionada ao deck")

func _on_deck_item_clicked(card_id: int):
    var os_name = OS.get_name()
    if os_name == "Android" or os_name == "iOS":
        var current_time = Time.get_ticks_msec()
        if last_clicked_deck_id == card_id and (current_time - last_clicked_deck_time) <= DOUBLE_CLICK_TIME_MS:
            last_clicked_deck_id = -1
        else:
            last_clicked_deck_id = card_id
            last_clicked_deck_time = current_time
            show_card_inspector(card_id)
            return

    if collection.remove_from_deck(card_id):
        _play_swipe_sound()
        update_counts()
        check_deck_validity()

        _update_chest_item(card_id)
        _update_deck_item_after_remove(card_id)
        print("Carta ", card_id, " removida do deck")


func _update_chest_item(card_id: int):
    "Atualiza in-place o ChestItem de uma carta sem recriar a lista inteira."
    var total_owned = collection.get_card_quantity(card_id)
    var deck_count = collection.get_card_quantity_in_deck(card_id)
    var chest_count = total_owned - deck_count
    var can_add = collection.can_add_to_deck(card_id)
    var card_data = CardDatabase.get_card(card_id)

    if not card_data:
        return

    if card_id in _chest_items and is_instance_valid(_chest_items[card_id]):

        _chest_items[card_id].setup(card_id, card_data, chest_count, deck_count, can_add)
    else:


        if current_filter_category == -1 and not is_searching:
            create_chest_item(card_id, card_data)

func _update_deck_item_after_add(card_id: int):
    "Atualiza ou cria o DeckItem após uma carta ser adicionada ao deck."
    var total_owned = collection.get_card_quantity(card_id)
    var deck_count = collection.get_card_quantity_in_deck(card_id)
    var chest_count = total_owned - deck_count
    var card_data = CardDatabase.get_card(card_id)

    if not card_data:
        return

    if card_id in _deck_items and is_instance_valid(_deck_items[card_id]):

        _deck_items[card_id].setup(card_id, card_data, deck_count, chest_count)
    else:


        var passes_filter = (current_filter_category == -1 or card_data.category == current_filter_category)
        var passes_search = not is_searching or search_text.to_lower() in card_data.name.to_lower()
        if passes_filter and passes_search:
            create_deck_item(card_id, card_data, deck_count)

func _update_deck_item_after_remove(card_id: int):
    "Remove ou atualiza o DeckItem após uma carta ser removida do deck."
    var total_owned = collection.get_card_quantity(card_id)
    var deck_count = collection.get_card_quantity_in_deck(card_id)
    var chest_count = total_owned - deck_count
    var card_data = CardDatabase.get_card(card_id)

    if not card_data:
        return

    if card_id in _deck_items and is_instance_valid(_deck_items[card_id]):
        if deck_count <= 0:

            _deck_items[card_id].queue_free()
            _deck_items.erase(card_id)
        else:

            _deck_items[card_id].setup(card_id, card_data, deck_count, chest_count)










func show_card_inspector(card_id: int):
    var card_data = CardDatabase.get_card(card_id)
    if card_data and card_inspector:
        if card_inspector.has_method("show_card"):
            card_inspector.show_card(card_data)


func update_counts():
    if not collection:
        return


    var unique_cards = collection.get_unlocked_card_ids().size()

    if chest_count_label:
        chest_count_label.text = "UNLOCKED:\n%d/%d" % [unique_cards, CardDatabase.cards.size()]


    var deck_count = collection.get_deck_count()

    if deck_count_label:
        deck_count_label.text = "Deck: %d/40" % deck_count


    if deck_mode_button:
        deck_mode_button.text = "DECK\n(%d/40)" % deck_count


func check_deck_validity():
    if not collection:
        return

    var deck_count = collection.get_deck_count()
    var is_valid = (deck_count == DECK_SIZE)


    if save_button:
        save_button.visible = false


    for btn in save_slot_buttons:
        btn.disabled = not is_valid
        if is_valid:
            btn.add_theme_color_override("font_color", Color(0.5, 1, 0.5))
        else:
            btn.add_theme_color_override("font_color", Color(1, 0, 0))


    var global = get_node_or_null("/root/Global")
    if global:
        for i in range(load_slot_buttons.size()):
            load_slot_buttons[i].disabled = global.is_deck_slot_empty(i)

    if back_button:
        back_button.disabled = not is_valid


func _setup_deck_slot_buttons():
    var font = _get_slot_button_font()
    var footer = $Footer
    if not footer:
        return


    var slots_container = VBoxContainer.new()
    slots_container.add_theme_constant_override("separation", 8)
    slots_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL


    var save_hbox = HBoxContainer.new()
    save_hbox.add_theme_constant_override("separation", 8)
    save_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    slots_container.add_child(save_hbox)

    save_slot_buttons.clear()
    for i in range(3):
        var btn = Button.new()
        btn.text = "SAVE\nSLOT %d" % (i + 1)
        btn.custom_minimum_size = Vector2(120, 55)
        btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        btn.add_theme_font_override("font", font)
        btn.add_theme_font_size_override("font_size", 30)
        btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

        var normal_s = _create_slot_button_style(Color(0.15, 0.35, 0.15))
        var hover_s = _create_slot_button_style(Color(0.2, 0.5, 0.2))
        var pressed_s = _create_slot_button_style(Color(0.1, 0.6, 0.1))
        var disabled_s = _create_slot_button_style(Color(0.2, 0.2, 0.2))
        btn.add_theme_stylebox_override("normal", normal_s)
        btn.add_theme_stylebox_override("hover", hover_s)
        btn.add_theme_stylebox_override("pressed", pressed_s)
        btn.add_theme_stylebox_override("disabled", disabled_s)

        btn.pressed.connect(_on_save_slot_pressed.bind(i))
        save_hbox.add_child(btn)
        save_slot_buttons.append(btn)


    var load_hbox = HBoxContainer.new()
    load_hbox.add_theme_constant_override("separation", 8)
    load_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    slots_container.add_child(load_hbox)

    load_slot_buttons.clear()
    for i in range(3):
        var btn = Button.new()
        btn.text = "LOAD\nSLOT %d" % (i + 1)
        btn.custom_minimum_size = Vector2(120, 55)
        btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        btn.add_theme_font_override("font", font)
        btn.add_theme_font_size_override("font_size", 30)
        btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

        var normal_s = _create_slot_button_style(Color(0.15, 0.15, 0.35))
        var hover_s = _create_slot_button_style(Color(0.2, 0.2, 0.5))
        var pressed_s = _create_slot_button_style(Color(0.1, 0.1, 0.6))
        var disabled_s = _create_slot_button_style(Color(0.2, 0.2, 0.2))
        btn.add_theme_stylebox_override("normal", normal_s)
        btn.add_theme_stylebox_override("hover", hover_s)
        btn.add_theme_stylebox_override("pressed", pressed_s)
        btn.add_theme_stylebox_override("disabled", disabled_s)

        btn.pressed.connect(_on_load_slot_pressed.bind(i))
        load_hbox.add_child(btn)
        load_slot_buttons.append(btn)


    var back_idx = back_button.get_index() if back_button else footer.get_child_count()
    footer.add_child(slots_container)
    footer.move_child(slots_container, back_idx)

func _get_slot_button_font() -> FontVariation:
    var base_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
    if base_font:
        var font = FontVariation.new()
        font.base_font = base_font
        return font
    return null

func _create_slot_button_style(bg_color: Color) -> StyleBoxFlat:
    var style = StyleBoxFlat.new()
    style.bg_color = bg_color
    style.corner_radius_top_left = 5
    style.corner_radius_top_right = 5
    style.corner_radius_bottom_left = 5
    style.corner_radius_bottom_right = 5
    style.content_margin_top = 15
    style.content_margin_bottom = 5
    style.content_margin_left = 10
    style.content_margin_right = 10
    return style

func _on_save_slot_pressed(slot_index: int):
    if not collection:
        return

    var deck = collection.get_deck_cards()
    if deck.size() != DECK_SIZE:
        show_save_feedback(false, "Deck must have exactly 40 cards!")
        return

    var global = get_node_or_null("/root/Global")
    if global:
        if global.save_deck_to_slot(slot_index, deck):
            _play_confirm_sound()


            global.player_deck = deck.duplicate()
            global.save_player_data()


            if has_node("/root/PlayerDeck"):
                var player_deck_node = get_node("/root/PlayerDeck")
                player_deck_node.set_deck(deck)

            active_deck_slot = slot_index
            update_indicators()
            show_save_feedback(true, "Deck saved\nto Slot %d!" % (slot_index + 1))
            check_deck_validity()
        else:
            show_save_feedback(false, "Error saving to Slot %d!" % (slot_index + 1))
    else:
        show_save_feedback(false, "Error: Global not found!")

func _on_load_slot_pressed(slot_index: int):
    var global = get_node_or_null("/root/Global")
    if not global:
        show_save_feedback(false, "Error: Global not found!")
        return

    if global.is_deck_slot_empty(slot_index):
        show_save_feedback(false, "Slot %d is empty!" % (slot_index + 1))
        return

    var deck = global.load_deck_from_slot(slot_index)
    if deck.size() != DECK_SIZE:
        show_save_feedback(false, "Slot %d has invalid deck!" % (slot_index + 1))
        return

    if collection:
        _play_confirm_sound()
        collection.clear_deck()
        for card_id in deck:
            collection.deck_cards.append(card_id)


        global.player_deck = deck.duplicate()
        global.save_player_data()


        if has_node("/root/PlayerDeck"):
            var player_deck_node = get_node("/root/PlayerDeck")
            player_deck_node.set_deck(deck)

        active_deck_slot = slot_index
        update_indicators()
        update_counts()
        refresh_chest_list()
        refresh_deck_list()
        check_deck_validity()
        show_save_feedback(true, "Deck loaded\nfrom Slot %d!" % (slot_index + 1))

func _on_clear_deck_pressed():
    if not collection: return
    _play_confirm_sound()


    var current_deck = collection.get_deck_cards().duplicate()
    for card_id in current_deck:
        collection.remove_from_deck(card_id)

    update_counts()
    check_deck_validity()


    if current_mode == "chest":
        refresh_chest_list()
    else:
        refresh_deck_list()

func _on_save_button_pressed():

    _on_save_slot_pressed(0)

func show_save_feedback(is_success: bool, message: String):
    var label = get_node_or_null("SaveFeedbackLabel")
    if not label: return

    label.text = message.to_upper()
    label.add_theme_color_override("font_color", Color(0.5, 1, 0.5) if is_success else Color(1, 0.3, 0.3))


    label.modulate.a = 0.0
    label.visible = true


    if label.has_meta("current_tween"):
        var old_tween = label.get_meta("current_tween")
        if old_tween and old_tween.is_valid():
            old_tween.kill()

    var tween = create_tween()
    label.set_meta("current_tween", tween)

    tween.tween_property(label, "modulate:a", 1.0, 0.3)
    tween.tween_interval(2.0)
    tween.tween_property(label, "modulate:a", 0.0, 0.3)


    tween.tween_callback( func(): label.visible = false)

func _on_back_button_pressed():
    _play_confirm_sound()

    if has_node("/root/SceneManage"):
        var scene_manager = get_node("/root/SceneManage")
        scene_manager.go_back()
    else:

        get_tree().change_scene_to_file("res://main_menu.tscn")

func _play_bgm():
    var player = AudioStreamPlayer.new()
    var stream = load("res://assets/sounds/bgm/deckbuilder.mp3")
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

func _play_swipe_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/swipe.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)
