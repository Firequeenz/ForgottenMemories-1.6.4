extends Node2D


signal clicked()


const GRAVEYARD_SCALE = Vector2(0.25, 0.25)
const CARD_ORIGINAL_SIZE = Vector2(364, 530)


var card_scene = preload("res://scenes/CardVisual.tscn")


@export var card_rotation: float = 0.0


@onready var container = $CardContainer
@onready var counter_label = $CountLabel
@onready var click_area = $ClickArea


var _has_cards: bool = false
var _click_debounce: bool = false
var _linked_window: Node = null


func _ready():
    _clear_container()
    _setup_counter_label()
    _setup_click_area()

func _setup_counter_label():
    if counter_label:
        counter_label.text = "0"

func _setup_click_area():
    if not click_area:
        return

    if not click_area.pressed.is_connected(_on_area_pressed):
        click_area.pressed.connect(_on_area_pressed)

    click_area.mouse_default_cursor_shape = Control.CURSOR_ARROW
    click_area.focus_mode = Control.FOCUS_NONE


func update_graveyard(graveyard_list: Array[CardData]):
    if not graveyard_list:
        graveyard_list = []

    var count = graveyard_list.size()

    _update_counter(count)
    _update_cursor_state(count)
    _clear_container()

    if count > 0:
        await _display_top_card(graveyard_list.back())

func _update_counter(count: int):
    _has_cards = (count > 0)

    if counter_label:
        counter_label.text = str(count)

func _update_cursor_state(count: int):
    if click_area:
        click_area.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if count > 0 else Control.CURSOR_ARROW


func _display_top_card(card_data: CardData):
    if not container or not card_data:
        return


    var card_instance = card_scene.instantiate()


    container.add_child(card_instance)


    await get_tree().process_frame


    if not is_instance_valid(card_instance) or not card_instance.is_inside_tree():
        return


    card_instance.set_card_data(card_data, -1, false)


    card_instance.size = CARD_ORIGINAL_SIZE
    card_instance.pivot_offset = CARD_ORIGINAL_SIZE / 2
    card_instance.position = - CARD_ORIGINAL_SIZE / 2
    card_instance.scale = GRAVEYARD_SCALE
    card_instance.rotation_degrees = card_rotation
    card_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE


    if card_instance.has_method("set_clickable"):
        card_instance.set_clickable(false)
    if card_instance.has_method("set_owner_is_player"):
        card_instance.set_owner_is_player(false)


func _clear_container():
    for child in container.get_children():
        child.queue_free()


func _on_area_pressed():
    print("[GraveyardVisual] Clique detectado - has_cards:", _has_cards, " debounce:", _click_debounce)

    if not _has_cards or _click_debounce:
        return


    if _linked_window:
        var is_window_open = _linked_window.is_open()
        print("[GraveyardVisual] Janela está aberta?", is_window_open)

        if is_window_open:

            print("[GraveyardVisual] Fechando janela (estava aberta)")
            _linked_window.close()
            return
    else:
        print("[GraveyardVisual] AVISO: _linked_window é null!")



    if _linked_window and _linked_window.is_in_cooldown():
        print("[GraveyardVisual] Janela em COOLDOWN - ignorando clique")
        return

    print("[GraveyardVisual] Emitindo sinal clicked")
    _click_debounce = true
    clicked.emit()


    await get_tree().create_timer(0.2).timeout
    _click_debounce = false



func get_card_count() -> int:
    return int(counter_label.text) if counter_label else 0


func is_empty() -> bool:
    return not _has_cards


func set_counter_visible(visible: bool):
    if counter_label:
        counter_label.visible = visible


func set_clickable(enabled: bool):
    if click_area:
        click_area.visible = enabled


func link_graveyard_window(window: Node):
    _linked_window = window
