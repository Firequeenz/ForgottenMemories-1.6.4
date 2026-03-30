
extends Label

@export var max_font_size: int = 24
@export var min_font_size: int = 10

func set_name_text(new_name: String):
    text = new_name
    adjust_font_size()

func adjust_font_size():

    var current_size = max_font_size
    add_theme_font_size_override("font_size", current_size)



    await get_tree().process_frame


    var max_width = get_parent().size.x


    while get_combined_minimum_size().x > max_width and current_size > min_font_size:
        current_size -= 1
        add_theme_font_size_override("font_size", current_size)
