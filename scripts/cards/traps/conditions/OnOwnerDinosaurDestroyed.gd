extends Resource
class_name OnOwnerDinosaurDestroyed




func check_destruction(slot_node, card_data, trap: TrapData) -> bool:
    if slot_node == null or card_data == null or trap.owner == null:
        return false


    if slot_node.is_player_slot != trap.owner.is_player_slot:
        return false


    if card_data.type and card_data.type.to_lower() == "dinosaur":
        print("Survival Instinct: Dinossauro do dono destruído. Ativando.")
        return true

    return false
