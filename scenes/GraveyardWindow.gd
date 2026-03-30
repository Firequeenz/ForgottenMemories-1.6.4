extends PanelContainer


signal card_hovered(card_visual)


const CARD_ORIGINAL_SIZE = Vector2(364, 530)
const CARD_SCALE = Vector2(0.25, 0.25)


var card_scene = preload("res://scenes/CardVisual.tscn")


@onready var title_lbl = $VBoxContainer / Header / TitleLabel
@onready var grid_container = $VBoxContainer / ScrollContainer / GridContainer
@onready var close_btn = $VBoxContainer / Header / CloseButton


var _is_opening: bool = false
var _is_locked: bool = false
var _close_cooldown_frames: int = 0


func _ready():
    visible = false
    _setup_close_button()

func _setup_close_button():
    if close_btn:
        close_btn.pressed.connect(_on_close_pressed)


func _input(event):

    if not visible:
        return


    if _is_opening or _is_locked:
        return


    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var is_inside = get_global_rect().has_point(event.position)

        if not is_inside:
            print("[GraveyardWindow] Clique FORA - Fechando janela")
            _on_close_pressed()

func _process(_delta):

    if _close_cooldown_frames > 0:
        _close_cooldown_frames -= 1
        if _close_cooldown_frames == 0:
            print("[GraveyardWindow] Cooldown expirado - Pode reabrir")


func show_graveyard(title_text: String, card_list: Array[CardData]):
    print("[GraveyardWindow] show_graveyard chamado - visible:", visible, " cooldown:", _close_cooldown_frames)


    if _close_cooldown_frames > 0:
        print("[GraveyardWindow] EM COOLDOWN - Aguardando", _close_cooldown_frames, "frames")
        return


    if visible:
        print("[GraveyardWindow] JÁ VISÍVEL - Ignorando")
        return

    if _is_opening:
        print("[GraveyardWindow] JÁ ABRINDO - Ignorando")
        return

    if _is_locked:
        print("[GraveyardWindow] BLOQUEADA - Ignorando")
        return

    print("[GraveyardWindow] === ABRINDO JANELA ===")
    _is_opening = true
    _is_locked = true


    visible = true
    move_to_front()

    _update_title(title_text)
    _clear_grid()
    _populate_grid(card_list)

    print("[GraveyardWindow] === JANELA ABERTA ===")


    await get_tree().process_frame
    _is_opening = false


    await get_tree().create_timer(0.3).timeout
    _is_locked = false
    print("[GraveyardWindow] Lock liberado")

func _update_title(title_text: String):
    if title_lbl:
        title_lbl.text = title_text

func _clear_grid():
    for child in grid_container.get_children():
        child.queue_free()

func _populate_grid(card_list: Array[CardData]):
    var mini_size = CARD_ORIGINAL_SIZE * CARD_SCALE

    for card_data in card_list:
        _create_grid_card(card_data, mini_size)

func _create_grid_card(card_data: CardData, mini_size: Vector2):

    var wrapper = Control.new()
    wrapper.custom_minimum_size = mini_size
    wrapper.mouse_filter = Control.MOUSE_FILTER_PASS
    grid_container.add_child(wrapper)


    var card_visual = card_scene.instantiate()
    wrapper.add_child(card_visual)


    card_visual.set_card_data(card_data, -1, false)


    _configure_card_visual(card_visual)


    _connect_hover_signals(card_visual)

func _configure_card_visual(card_visual: Node):
    card_visual.set_anchors_preset(Control.PRESET_TOP_LEFT)
    card_visual.scale = CARD_SCALE
    card_visual.position = Vector2.ZERO
    card_visual.mouse_filter = Control.MOUSE_FILTER_PASS

    if card_visual.has_method("set_clickable"):
        card_visual.set_clickable(false)
    if card_visual.has_method("set_owner_is_player"):
        card_visual.set_owner_is_player(false)

func _connect_hover_signals(card_visual: Node):
    card_visual.mouse_entered.connect( func(): card_hovered.emit(card_visual))
    card_visual.mouse_exited.connect( func(): card_hovered.emit(null))


func _on_close_pressed():
    print("[GraveyardWindow] === FECHANDO JANELA ===")
    visible = false
    card_hovered.emit(null)
    _is_opening = false
    _is_locked = false


    _close_cooldown_frames = 15
    print("[GraveyardWindow] Cooldown iniciado: 15 frames")



func is_open() -> bool:
    return visible


func is_in_cooldown() -> bool:
    return _close_cooldown_frames > 0


func close():
    _on_close_pressed()


func get_displayed_card_count() -> int:
    return grid_container.get_child_count()
