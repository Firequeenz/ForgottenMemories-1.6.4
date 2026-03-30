extends CanvasLayer

signal video_finished()

@onready var video_player = $VideoStreamPlayer
@onready var background = $Background

func _ready():
    visible = false
    background.modulate.a = 0.0

func play_effect_video(video_path: String):

    if ResourceLoader.exists(video_path):
        video_player.stream = load(video_path)
    visible = true

    var tween = create_tween()

    tween.tween_property(background, "modulate:a", 1.0, 0.5)
    tween.parallel().tween_property(video_player, "modulate:a", 1.0, 0.5)
    await tween.finished

    video_player.play()

    await video_player.finished

    var out_tween = create_tween()

    out_tween.tween_property(background, "modulate:a", 0.0, 0.5)
    out_tween.parallel().tween_property(video_player, "modulate:a", 0.0, 0.5)
    await out_tween.finished

    visible = false
    video_finished.emit()
