extends CanvasLayer


signal intro_finished()


const FADE_IN_DURATION = 0.1
const DUEL_APPEAR_DURATION = 0.2
const GLOW_DURATION = 0.5
const DUEL_STAY_DURATION = 0.2
const FADE_OUT_DURATION = 0.1
const SCREEN_DARKEN_DURATION = 0.3


@onready var overlay = $Overlay
@onready var duel_sprite = $DuelSprite


func _ready():

    visible = false
    overlay.modulate.a = 0.0
    duel_sprite.modulate.a = 0.0
    duel_sprite.scale = Vector2(0.8, 0.8)


    _center_sprite()

func _center_sprite():

    var viewport_size = get_viewport().get_visible_rect().size
    duel_sprite.position = viewport_size / 2


func play_intro():
    visible = true


    var tween = create_tween()
    tween.set_parallel(false)


    tween.tween_property(overlay, "modulate:a", 0.7, SCREEN_DARKEN_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


    tween.tween_property(duel_sprite, "modulate:a", 1.0, DUEL_APPEAR_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.parallel().tween_property(duel_sprite, "scale", Vector2(0.2, 0.2), DUEL_APPEAR_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


    tween.tween_property(duel_sprite, "modulate", Color(2.0, 2.0, 2.0, 1.0), GLOW_DURATION * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(duel_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), GLOW_DURATION * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


    tween.tween_interval(DUEL_STAY_DURATION)


    tween.tween_property(duel_sprite, "modulate:a", 0.0, FADE_OUT_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.parallel().tween_property(duel_sprite, "scale", Vector2(1.2, 1.2), FADE_OUT_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


    tween.tween_property(overlay, "modulate:a", 0.0, FADE_IN_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


    tween.tween_callback(_on_intro_complete)


func _on_intro_complete():
    visible = false
    intro_finished.emit()



func skip_intro():
    visible = false
    intro_finished.emit()
