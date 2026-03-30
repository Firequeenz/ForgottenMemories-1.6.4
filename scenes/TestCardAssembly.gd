extends Node2D

@onready var visual_card = $CardVisual

func _ready():


    var blue_eyes_data = CardDatabase.get_card(1)

    if blue_eyes_data == null:
        print("ERRO: Carta ID 1 não encontrada no CardDatabase!")
        return

    print("Testando montagem da carta: " + blue_eyes_data.name)



    visual_card.set_card_data(blue_eyes_data, 0)
