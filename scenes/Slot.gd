extends TextureButton


signal slot_clicked(slot_instance)


var slot_index: int = 0
var is_player_slot: bool = true
var is_occupied: bool = false
var stored_card_data: CardData
var has_attacked_this_turn: bool = false


var can_select: bool = false


@onready var highlight = $Highlight
@onready var spawn_point = $SpawnPoint


func _ready():
    _connect_signals()
    _setup_ui()

func _connect_signals():
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    pressed.connect(_on_pressed)

func _setup_ui():
    if highlight:
        highlight.visible = false


func _on_mouse_entered():
    if can_select and highlight:
        highlight.visible = true

func _on_mouse_exited():
    if highlight:
        highlight.visible = false

func _on_pressed():
    if can_select:
        slot_clicked.emit(self)


func set_selectable(state: bool):
    can_select = state

    if not state and highlight:
        highlight.visible = false


func reset_turn_state():
    has_attacked_this_turn = false

    if is_occupied:
        _reset_card_visual()

func _reset_card_visual():
    if not spawn_point or spawn_point.get_child_count() == 0:
        return

    var card_visual = spawn_point.get_child(0)
    if card_visual and card_visual.has_method("set_exhausted"):
        card_visual.set_exhausted(false)



func get_card_visual() -> Node:
    if spawn_point and spawn_point.get_child_count() > 0:
        return spawn_point.get_child(0)
    return null


func clear_slot():
    is_occupied = false
    stored_card_data = null
    has_attacked_this_turn = false

    if spawn_point:
        for child in spawn_point.get_children():
            child.queue_free()


func has_face_down_card() -> bool:
    var card = get_card_visual()
    if card and "is_face_down" in card:
        return card.is_face_down
    return false
