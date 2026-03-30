class_name TrapSystem extends Node


const TRAP_IDS = {
    "MIRROR_FORCE": 723
}



static func check_reaction(duel_manager, trigger: String, attacker_slot, defender_slot) -> bool:


    var defender_is_player = false
    if defender_slot and "is_player_slot" in defender_slot:
        defender_is_player = defender_slot.is_player_slot
    elif attacker_slot and "is_player_slot" in attacker_slot:

        defender_is_player = !attacker_slot.is_player_slot


    var trap_slots = duel_manager.player_spell_slots if defender_is_player else duel_manager.enemy_spell_slots

    print("[TrapSystem] Audit: Checking traps for trigger: ", trigger)
    print("[TrapSystem] Defender is player: ", defender_is_player)
    print("[TrapSystem] Scanning ", trap_slots.size(), " trap slots")


    for i in range(trap_slots.size()):
        var slot = trap_slots[i]
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data


            var visual = null
            if slot.has_node("SpawnPoint") and slot.get_node("SpawnPoint").get_child_count() > 0:
                visual = slot.get_node("SpawnPoint").get_child(0)
            elif slot.get_child_count() > 0:
                visual = slot.get_child(0)

            var is_facedown = false
            if visual:
                if visual.has_method("is_face_down"):
                    is_facedown = visual.is_face_down()

                elif "rotation_degrees" in visual:
                    is_facedown = (visual.rotation_degrees != 0)

            print("[TrapSystem] Slot ", i, ": Card ID=", card.id, " FaceDown=", is_facedown)


            if is_facedown:

                if card.id == TRAP_IDS.MIRROR_FORCE and trigger == "on_attack_declared":
                    print("[TrapSystem] ⚡ TRIGGERED: Mirror Force!")


                    if visual and visual.has_method("set_face_down"):
                        visual.set_face_down(false)
                    elif visual and "rotation_degrees" in visual:
                        visual.rotation_degrees = 0


                    await duel_manager.get_tree().create_timer(1.0).timeout


                    print("[TrapSystem] >> Mirror Force: Destroying enemy attack-position monsters <<")
                    await _execute_mirror_force_effect(duel_manager, defender_is_player)


                    if duel_manager.has_method("_destroy_card"):
                        duel_manager._destroy_card(slot)
                    else:

                        slot.clear_slot()

                    return true

    return false


static func _execute_mirror_force_effect(duel_manager, trap_owner_is_player: bool):




    var target_slots = duel_manager.enemy_slots if trap_owner_is_player else duel_manager.player_slots

    var destroyed_count = 0

    for slot in target_slots:
        if slot.is_occupied and slot.stored_card_data:
            var visual = null
            if slot.has_node("SpawnPoint") and slot.get_node("SpawnPoint").get_child_count() > 0:
                visual = slot.get_node("SpawnPoint").get_child(0)


            var is_attack_position = false
            if visual:
                if "rotation_degrees" in visual:


                    if trap_owner_is_player:

                        is_attack_position = (visual.rotation_degrees == 180)
                    else:

                        is_attack_position = (visual.rotation_degrees == 0)

            if is_attack_position:
                print("[TrapSystem] Mirror Force destroying: ", slot.stored_card_data.name)


                if duel_manager.has_method("_destroy_card"):
                    duel_manager._destroy_card(slot)
                else:

                    if slot.stored_card_data:
                        var graveyard = duel_manager.player_graveyard if !trap_owner_is_player else duel_manager.enemy_graveyard
                        graveyard.append(slot.stored_card_data)
                    slot.clear_slot()

                destroyed_count += 1


                await duel_manager.get_tree().create_timer(0.2).timeout

    print("[TrapSystem] Mirror Force destroyed ", destroyed_count, " monsters")
