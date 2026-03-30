extends Node2D

var CARD_BACK_TEXTURE = preload("res://assets/cards/card_back.png")
@export var is_enemy_pile: bool = false
const STACK_OFFSET = Vector2(0, -0.6)
const DECK_SCALE = Vector2(0.25, 0.25)
const MAX_VISIBLE_CARDS = 30

var current_count: int = 0
var card_sprites: Array[Sprite2D] = []

func setup_deck(initial_count: int):
    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        if global.has_method("get_card_back_texture_path"):
            var cb_path = global.get_card_back_texture_path()
            if ResourceLoader.exists(cb_path):
                CARD_BACK_TEXTURE = load(cb_path)

    current_count = initial_count
    _refresh_full_stack()

func remove_top_card():
    if current_count <= 0:
        return

    current_count -= 1

    if current_count >= MAX_VISIBLE_CARDS:
        _animate_phantom_card()

    else:
        if card_sprites.size() > 0:
            var top_sprite = card_sprites.pop_back()
            _animate_existing_sprite(top_sprite)

func _animate_phantom_card():
    if card_sprites.is_empty(): return

    var top_pos = card_sprites.back().position
    var phantom_sprite = Sprite2D.new()

    phantom_sprite.texture = CARD_BACK_TEXTURE
    phantom_sprite.scale = DECK_SCALE
    phantom_sprite.position = top_pos
    if is_enemy_pile:
        phantom_sprite.rotation_degrees = 180

    add_child(phantom_sprite)

    _run_draw_animation(phantom_sprite)

func _animate_existing_sprite(sprite: Sprite2D):
    _run_draw_animation(sprite)

func _run_draw_animation(sprite: Node2D):
    sprite.z_index = 100

    var tween = create_tween()

    tween.tween_property(sprite, "position", sprite.position + Vector2(0, -50), 0.3)
    tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.3)
    tween.tween_callback(sprite.queue_free)

func _refresh_full_stack():
    for child in get_children():
        child.queue_free()
    card_sprites.clear()

    var cards_to_draw = min(current_count, MAX_VISIBLE_CARDS)

    for i in range(cards_to_draw):
        var sprite = Sprite2D.new()
        sprite.texture = CARD_BACK_TEXTURE
        sprite.scale = DECK_SCALE
        sprite.position = STACK_OFFSET * i
        if is_enemy_pile:
            sprite.rotation_degrees = 180

        if i < cards_to_draw - 1:
            var darken = 0.8 + (float(i) / cards_to_draw) * 0.2
            sprite.modulate = Color(darken, darken, darken)

        add_child(sprite)
        card_sprites.append(sprite)

    if current_count == 0:
        var base = Sprite2D.new()
        base.texture = CARD_BACK_TEXTURE
        base.scale = DECK_SCALE
        base.modulate = Color(0, 0, 0, 0.2)
        if is_enemy_pile:
            base.rotation_degrees = 180
        add_child(base)
