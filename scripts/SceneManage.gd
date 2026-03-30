
extends Node
class_name SceneManager

signal scene_changed(new_scene_name)
signal scene_paused(paused)
signal scene_loaded


const MAIN_MENU_PATH = "res://main_menu.tscn"


var scene_stack: Array[String] = []
var current_scene: Node = null
var current_scene_path: String = ""
var scene_transition: PackedScene = null
var is_transitioning: bool = false


func _ready():

    process_mode = Node.PROCESS_MODE_ALWAYS


    get_tree().node_added.connect(_on_node_added)
    get_tree().node_removed.connect(_on_node_removed)




    print("SceneManager inicializado")


func change_scene(scene_path: String, add_to_history: bool = true):
    if is_transitioning:
        print("Já está em transição!")
        return

    if not ResourceLoader.exists(scene_path):
        push_error("Cena não encontrada: " + scene_path)
        return

    print("Mudando para cena: ", scene_path)


    if add_to_history and current_scene_path != "":
        scene_stack.push_back(current_scene_path)
        print("Cena salva no histórico: ", current_scene_path)


    if scene_transition:
        _start_transition(scene_path)
    else:
        _load_scene_immediately(scene_path)

func change_scene_to_packed(packed_scene: PackedScene, add_to_history: bool = true):
    if add_to_history and current_scene_path != "":
        scene_stack.push_back(current_scene_path)

    var temp_scene = packed_scene.instantiate()
    var scene_path = temp_scene.scene_file_path if temp_scene.scene_file_path else ""
    temp_scene.queue_free()

    change_scene(scene_path, add_to_history)

func go_back():
    if scene_stack.size() > 0:
        var previous_scene_path = scene_stack.pop_back()
        print("Voltando para: ", previous_scene_path)
        change_scene(previous_scene_path, false)
    else:
        print("Sem histórico, indo para menu principal")
        change_scene(MAIN_MENU_PATH, false)

func reload_current_scene():
    if current_scene_path:
        change_scene(current_scene_path, false)

func clear_history():
    scene_stack.clear()
    print("Histórico de cenas limpo")


var _loading_overlay: CanvasLayer = null
var _loading_label: Label = null
var _loading_dot_timer: float = 0.0
var _loading_dot_count: int = 0
var _loading_target_path: String = ""
var _is_loading: bool = false

func _process(delta: float) -> void :
    if not _is_loading:
        return


    _loading_dot_timer += delta
    if _loading_dot_timer >= 0.5:
        _loading_dot_timer = 0.0
        _loading_dot_count = (_loading_dot_count + 1) % 4
        if _loading_label:
            _loading_label.text = "Loading" + ".".repeat(_loading_dot_count)


    var status = ResourceLoader.load_threaded_get_status(_loading_target_path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var packed_scene = ResourceLoader.load_threaded_get(_loading_target_path) as PackedScene
        if packed_scene:
            current_scene_path = _loading_target_path
            get_tree().change_scene_to_packed(packed_scene)
            emit_signal("scene_changed", _loading_target_path.get_file().get_basename())
        else:
            push_error("Erro ao obter cena carregada: " + _loading_target_path)
        _hide_loading_overlay()
    elif status == ResourceLoader.THREAD_LOAD_FAILED:
        push_error("Erro ao carregar cena em background: " + _loading_target_path)
        _hide_loading_overlay()

func _show_loading_overlay():
    if _loading_overlay:
        _loading_overlay.queue_free()

    _loading_overlay = CanvasLayer.new()
    _loading_overlay.layer = 100

    var bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 1)
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    _loading_overlay.add_child(bg)

    _loading_label = Label.new()
    _loading_label.text = "Loading"
    _loading_label.set_anchors_preset(Control.PRESET_CENTER)
    _loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _loading_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _loading_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
    _loading_label.grow_vertical = Control.GROW_DIRECTION_BOTH


    var base_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
    if base_font:
        var font = FontVariation.new()
        font.base_font = base_font
        font.spacing_glyph = 3
        _loading_label.add_theme_font_override("font", font)
    _loading_label.add_theme_font_size_override("font_size", 60)
    _loading_label.add_theme_constant_override("outline_size", 5)
    _loading_label.add_theme_color_override("font_outline_color", Color.BLACK)

    _loading_overlay.add_child(_loading_label)
    get_tree().root.add_child(_loading_overlay)

    _loading_dot_count = 0
    _loading_dot_timer = 0.0

func _hide_loading_overlay():
    _is_loading = false
    _loading_target_path = ""
    if _loading_overlay:
        _loading_overlay.queue_free()
        _loading_overlay = null
        _loading_label = null


func _load_scene_immediately(scene_path: String):
    _loading_target_path = scene_path
    _is_loading = true
    _show_loading_overlay()
    ResourceLoader.load_threaded_request(scene_path)

func _start_transition(scene_path: String):
    is_transitioning = true


    var transition = scene_transition.instantiate()
    get_tree().root.add_child(transition)


    if transition.has_signal("transition_halfway"):
        transition.transition_halfway.connect(_on_transition_halfway.bind(scene_path))
    if transition.has_signal("transition_finished"):
        transition.transition_finished.connect(_on_transition_finished)


    if transition.has_method("start"):
        transition.start()
    else:

        _on_transition_halfway(scene_path)

func _on_transition_halfway(scene_path: String):

    _load_scene_immediately(scene_path)

func _on_transition_finished():
    is_transitioning = false


func get_current_scene_name() -> String:
    if current_scene:
        return current_scene.name
    return ""

func get_scene_history() -> Array[String]:
    return scene_stack.duplicate()

func get_scene_count_in_history() -> int:
    return scene_stack.size()

func is_in_menu() -> bool:
    return current_scene_path == MAIN_MENU_PATH or "menu" in current_scene_path.to_lower()


func toggle_pause():
    get_tree().paused = !get_tree().paused
    emit_signal("scene_paused", get_tree().paused)
    return get_tree().paused

func set_pause(paused: bool):
    get_tree().paused = paused
    emit_signal("scene_paused", paused)


func _on_node_added(node: Node):

    if node == get_tree().current_scene:
        current_scene = node
        print("Nova cena carregada: ", node.name)
        emit_signal("scene_loaded")

func _on_node_removed(node: Node):

    if node == current_scene:
        current_scene = null


func get_scene_manager() -> SceneManager:
    return self


func return_to_main_menu():
    clear_history()
    change_scene(MAIN_MENU_PATH, false)


func can_go_back() -> bool:
    return scene_stack.size() > 0


func push_scene_to_history(scene_path: String):
    scene_stack.push_back(scene_path)
