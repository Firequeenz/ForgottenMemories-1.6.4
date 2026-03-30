extends Control

@onready var texture_rect = $TextureRect
@onready var bgm_player = $BGMPlayer

var is_transitioning: bool = false
var audio_player: AudioStreamPlayer = null

func _ready() -> void :

    var go_bgm = load("res://assets/sounds/bgm/gameover.mp3")
    if go_bgm:
        bgm_player.stream = go_bgm
        bgm_player.play()


    var go_tween = create_tween()
    go_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 2.0)

func _gui_input(event: InputEvent) -> void :
    if is_transitioning:
        return

    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        is_transitioning = true
        _play_confirm_sound()


        var out_tween = create_tween()
        out_tween.tween_property(texture_rect, "modulate", Color(0, 0, 0, 1), 1.0)
        out_tween.parallel().tween_property(bgm_player, "volume_db", -80.0, 1.0)
        out_tween.tween_callback( func():
            if has_node("/root/SceneManage"):
                var scene_manager = get_node("/root/SceneManage")
                scene_manager.change_scene("res://main_menu.tscn", false)
            else:
                get_tree().change_scene_to_file("res://main_menu.tscn")
        ).set_delay(1.0)

func _play_confirm_sound() -> void :
    var sound_path = "res://assets/sounds/sfx/confirmbutton.wav"
    if ResourceLoader.exists(sound_path):
        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)
        var stream = load(sound_path)
        if stream:
            audio_player.stream = stream
            audio_player.play()
