extends Node


@onready var duel_manager = get_parent()


const EXODIA_IDS = [17, 18, 19, 20, 21]
const KURIBOH_ID = 58
const EQUIP_DARK_ENERGY = 303
const EQUIP_LEGENDARY_SWORD = 301
const EQUIP_SWORD_DARK_DESTRUCTION = 302
const EQUIP_AXE_OF_DESPAIR = 304
const EQUIP_LASER_CANNON_ARMOR = 305
const EQUIP_INSECT_ARMOR_WITH_LASER_CANNON = 306
const EQUIP_ELFS_LIGHT = 307
const EQUIP_BEAST_FANGS = 308
const EQUIP_STEEL_SHELL = 309
const EQUIP_VILE_GERMS = 310
const EQUIP_BLACK_PENDANT = 311
const EQUIP_SILVER_BOW_ARROW = 312
const EQUIP_HORN_OF_LIGHT = 313
const EQUIP_HORN_OF_THE_UNICORN = 314
const EQUIP_DRAGON_TREASURE = 315
const EQUIP_ELECTRO_WHIP = 316
const EQUIP_CYBER_SHIELD = 317
const EQUIP_ELEGANT_EGOTIST = 318
const HARPY_LADY_ID = 62
const EQUIP_MYSTICAL_MOON = 319
const EQUIP_MALEVOLENT_NUZZLER = 321
const EQUIP_VIOLET_CRYSTAL = 322
const EQUIP_BOOK_OF_SECRET_ARTS = 323
const EQUIP_INVIGORATION = 324
const EQUIP_MACHINE_CONVERSION_FACTORY = 325
const EQUIP_RAISE_BODY_HEAT = 326
const EQUIP_FOLLOW_WIND = 327
const EQUIP_POWER_OF_KAISHIN = 328
const EQUIP_SALAMANDRA = 654
const EQUIP_MAGICAL_LABYRINTH = 652
const EQUIP_MEGAMORPH = 657
const EQUIP_METALMORPH = 658
const EQUIP_GUST_FAN = 738
const EQUIP_SWORD_DEEP_SEATED = 752
const EQUIP_PHOTON_BOOSTER = 757
const EQUIP_GRAVITY_AXE_GRARL = 777
const COMMENCEMENT_REQUIRED_IDS = [249, 395, 511]
const HAMBURGER_RECIPE_REQUIRED_IDS = [14, 295, 547]
const WARLION_RITUAL_REQUIRED_IDS = [201, 403, 483]
const ZERA_RITUAL_REQUIRED_IDS = [85, 298, 377]
const BLACK_LUSTER_REQUIRED_IDS = [27, 38, 58]
const BEASTLY_MIRROR_REQUIRED_IDS = [186, 261, 595]
const REVIVAL_OF_DOKURORIDER_REQUIRED_IDS = [146, 479, 485]
const NOVOX_PRAYER_REQUIRED_IDS = [160, 161, 535]
const TURTLE_OATH_REQUIRED_IDS = [89, 449, 451]
const RESURRECTION_OF_CHAKRA_REQUIRED_IDS = [178, 296, 288]
const GARMA_SWORD_OATH_REQUIRED_IDS = [239, 378, 621]
const FORTRESS_WHALE_OATH_REQUIRED_IDS = [436, 441, 542]
const BLACK_MAGIC_RITUAL_REQUIRED_IDS = [7, 35, 471]
const JAVELIN_BEETLE_PACT_IDS = [52, 480, 533]
const LORD_OF_D_ID = 728
const SUMMON_FACE_UP_IDS = [16, 40, 83, 84, 95, 120, 162, 166, 171, 224, 
266, 428, 429, 462, 469, 492, 500, 506, 512, 524, 527, 540, 562, 580, 591, 
583, 586, 598, 602, 609, 611, 616, 628, 641, 728, 734, 747, 760, 761, 762, 763, 766, 768, 769, 
774, 780, 781, 784, 786, 787, 793, 794, 798, 799, 800, 99999]


var enemy_turn_counter: int = 0
var current_enemy_difficulty: String = "Easy"
var enemy_hand: Array[CardData] = []
var enemy_slots: Array = []
var player_slots: Array = []
var enemy_spell_slots: Array = []


func setup(enemy_hand_ref: Array[CardData], enemy_slots_ref: Array, player_slots_ref: Array, enemy_spell_slots_ref: Array):
    enemy_hand = enemy_hand_ref
    enemy_slots = enemy_slots_ref
    player_slots = player_slots_ref
    enemy_spell_slots = enemy_spell_slots_ref
    enemy_turn_counter = 0

func set_difficulty(difficulty: String):
    current_enemy_difficulty = difficulty

func get_current_difficulty() -> String:
    if duel_manager and "current_enemy_difficulty" in duel_manager:
        return duel_manager.current_enemy_difficulty
    return current_enemy_difficulty

func get_enemy_turn_counter() -> int:
    if duel_manager and "enemy_turn_counter" in duel_manager:
        return duel_manager.enemy_turn_counter
    return enemy_turn_counter


func play_turn() -> void :
    if duel_manager.enemy_has_played:
        return

    duel_manager.enemy_has_played = true
    enemy_turn_counter += 1


    var can_fusion_this_turn = _can_ai_fusion()

    await duel_manager.get_tree().create_timer(1.0).timeout


    var used_magic = await _try_use_special_magic()

    if used_magic:

        print("IA: Jogou carta mágica/armadilha, pulando fase de summon")


        await duel_manager.get_tree().create_timer(1.0).timeout


        var has_attackable_monsters = false
        for e_slot in enemy_slots:
            if e_slot.is_occupied:
                var my_visual = e_slot.spawn_point.get_child(0)
                if my_visual and my_visual.rotation_degrees == 180:
                    has_attackable_monsters = true
                    break

                elif my_visual and (my_visual.rotation_degrees == -90 or duel_manager._has_card_back(my_visual)):
                    var my_card = e_slot.stored_card_data
                    if _should_reveal_and_attack_from_defense(my_card, e_slot):
                        has_attackable_monsters = true
                        break

        if has_attackable_monsters:
            print("IA: Tem monstros em campo, iniciando fase de batalha")
            await _perform_battle_phase()
        else:
            print("IA: Nenhum monstro pode atacar, terminando turno")

        duel_manager.end_enemy_turn()
        return


    print("IA: Não jogou magia, jogando monstro")
    var played_monster = await _play_monster(can_fusion_this_turn)

    if not used_magic and not played_monster:
        print("IA: Turno ocioso detectado! Forçando jogada de carta mágica/armadilha...")
        await _force_play_random_magic()



    if duel_manager.get("is_processing_trap") or duel_manager.get("additional_processing_lock") > 0:
        print("IA: Aguardando resolução de trap/efeitos...")
        while duel_manager.is_processing_trap or duel_manager.additional_processing_lock > 0:
            await duel_manager.get_tree().create_timer(0.5).timeout

    await duel_manager.get_tree().create_timer(1.0).timeout


    var has_attackable_monsters_after_summon = false
    for e_slot in enemy_slots:
        if e_slot.is_occupied:
            var my_visual = e_slot.spawn_point.get_child(0)
            if my_visual and (my_visual.rotation_degrees == 180 or _can_switch_to_attack(e_slot.stored_card_data, e_slot)):
                has_attackable_monsters_after_summon = true
                break

    if has_attackable_monsters_after_summon:
        print("IA: Iniciando fase de batalha após summon")
        await _perform_battle_phase()
    else:
        print("IA: Nenhum monstro pode atacar após summon")

    await duel_manager.get_tree().create_timer(0.25).timeout

    duel_manager.end_enemy_turn()

func _should_reveal_and_attack_from_defense(card: CardData, slot) -> bool:

    var player_has_monsters = false
    for p_slot in player_slots:
        if p_slot.is_occupied:
            player_has_monsters = true
            break

    if not player_has_monsters and card.atk > 0:
        return true


    if card.id in duel_manager.DIRECT_ATTACK_MONSTER_IDS:
        return true


    if card.atk < 1000:
        return false


    var best_priority = -9999
    for p_slot in player_slots:
        if p_slot.is_occupied:
            var priority = _calculate_target_priority(card, p_slot)
            if priority > best_priority:
                best_priority = priority


    return best_priority > 500


func _can_switch_to_attack(card: CardData, slot) -> bool:
    return _should_reveal_and_attack_from_defense(card, slot)

func _can_ai_fusion() -> bool:
    match current_enemy_difficulty:
        "Easy": return enemy_turn_counter % 3 == 0
        "Medium": return enemy_turn_counter % 2 == 0
        "Hard": return true
    return false


func _try_use_special_magic() -> bool:
    for i in range(enemy_hand.size()):
        var card = enemy_hand[i]
        if card == null:
            continue


        if card.type == "Magic" or card.type == "Trap":
            var should_use = await _check_and_use_magic(card, i)
            if should_use:
                return true
            await duel_manager.get_tree().create_timer(0.5).timeout

    return false


func _check_and_use_magic(card: CardData, hand_index: int) -> bool:
    var should_use = false


    if card.id == 746:
        should_use = randf() <= 0.1


    if card.id == 748:

        var hand_size = 0
        for c in duel_manager.enemy_hand:
            if c != null:
                hand_size += 1


        var has_faceup = false
        for slot in duel_manager.player_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    has_faceup = true
                    break

        if hand_size > 1 and has_faceup:
            should_use = randf() <= 0.1


    if card.id == 750:
        var my_faceup_count = 0
        var my_lowest_atk = 999999
        for slot in duel_manager.enemy_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    my_faceup_count += 1
                    var catk = duel_manager.get_effective_atk(slot.stored_card_data, null)
                    if catk < my_lowest_atk:
                        my_lowest_atk = catk

        var opp_faceup_count = 0
        var opp_highest_atk = -1
        for slot in duel_manager.player_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    opp_faceup_count += 1
                    var catk = duel_manager.get_effective_atk(slot.stored_card_data, null)
                    if catk > opp_highest_atk:
                        opp_highest_atk = catk

        if my_faceup_count > 0 and opp_faceup_count > 0:
            if opp_highest_atk > my_lowest_atk:
                should_use = randf() <= 0.8


    if card.id == 767:
        var my_faceup_count = 0
        var my_lowest_atk = 999999
        for slot in duel_manager.enemy_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    my_faceup_count += 1
                    var catk = duel_manager.get_effective_atk(slot.stored_card_data, null)
                    if catk < my_lowest_atk:
                        my_lowest_atk = catk

        var opp_faceup_count = 0
        var opp_highest_atk = -1
        for slot in duel_manager.player_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    opp_faceup_count += 1
                    var catk = duel_manager.get_effective_atk(slot.stored_card_data, null)
                    if catk > opp_highest_atk:
                        opp_highest_atk = catk

        if my_faceup_count > 0 and opp_faceup_count > 0:
            if opp_highest_atk > my_lowest_atk:
                should_use = randf() <= 0.8


    if card.id == 751:
        var total_my_adv_before = 0
        var total_opp_adv_before = 0
        var total_my_adv_after = 0
        var total_opp_adv_after = 0
        var faceup_count = 0

        for slot in duel_manager.enemy_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    faceup_count += 1
                    total_my_adv_before += slot.stored_card_data.atk
                    total_my_adv_after += slot.stored_card_data.def

        for slot in duel_manager.player_slots:
            if slot.is_occupied:
                var visual = slot.spawn_point.get_child(0)
                if visual and visual.has_method("is_face_down") and not visual.is_face_down():
                    faceup_count += 1
                    total_opp_adv_before += slot.stored_card_data.atk
                    total_opp_adv_after += slot.stored_card_data.def

        if faceup_count > 0:
            var diff_before = total_my_adv_before - total_opp_adv_before
            var diff_after = total_my_adv_after - total_opp_adv_after
            if diff_after > diff_before:
                should_use = randf() <= 0.8


    if card.id == 753:
        var my_spell_count = 0
        for slot in duel_manager.enemy_spell_slots:
            if slot.is_occupied:
                my_spell_count += 1
        var opp_spell_count = 0
        for slot in duel_manager.player_spell_slots:
            if slot.is_occupied:
                opp_spell_count += 1

        if opp_spell_count > my_spell_count and opp_spell_count > 0:
            should_use = randf() <= 0.8


    if card.id == 723:
        should_use = randf() <= 0.15


    if card.id == 695:
        should_use = randf() <= 0.15


    if card.id == 329:
        should_use = randf() <= 0.15


    if card.id == 349:
        should_use = randf() <= 0.15


    if card.id == 661:
        should_use = randf() <= 0.15


    if card.id == 669:
        should_use = randf() <= 0.15


    if card.id == 681:
        should_use = randf() <= 0.15


    if card.id == 682:
        should_use = randf() <= 0.15


    if card.id == 690:
        should_use = randf() <= 0.15


    if card.id == 666:
        should_use = randf() <= 0.15


    if card.id == 683:
        should_use = randf() <= 0.15


    if card.id == 684:
        should_use = randf() <= 0.15


    if card.id == 659:
        should_use = randf() <= 0.15


    if card.id == 685:
        should_use = randf() <= 0.15


    if card.id == 686:
        should_use = randf() <= 0.15


    if card.id == 689:
        should_use = randf() <= 0.15


    if card.id == 727:
        should_use = randf() <= 0.15


    if card.id == 729:
        should_use = randf() <= 0.15


    if card.id == 735:
        should_use = randf() <= 0.15


    if card.id == 749:
        should_use = randf() <= 0.15


    if card.id == 754:
        should_use = randf() <= 0.15


    if card.id == 755:
        should_use = randf() <= 0.15


    if card.id == 758:
        should_use = randf() <= 0.15


    if card.id == 764:
        should_use = randf() <= 0.15


    if card.id == 676:
        should_use = _should_use_commencement_dance()


    if card.id == 696:
        should_use = _should_use_javelin_beetle_pact()


    if card.id == 700:
        should_use = _should_use_fortress_whale_oath()


    if card.id == 697:
        should_use = _should_use_garma_sword_oath()


    if card.id == 677:
        should_use = _should_use_hamburger_recipe()


    if card.id == 673:
        should_use = _should_use_warlion_ritual()


    if card.id == 671:
        should_use = _should_use_zera_ritual()


    if card.id == 674:
        should_use = _should_use_beastly_mirror_ritual()


    if card.id == 670:
        should_use = _should_use_black_luster_ritual()


    if card.id == 699:
        should_use = _should_use_revival_of_dokurorider()


    if card.id == 679:
        should_use = _should_use_novox_prayer()


    if card.id == 692:
        should_use = _should_use_turtle_oath()


    if card.id == 694:
        should_use = _should_use_resurrection_of_chakra()


    if card.id == 721:
        should_use = _should_use_black_magic_ritual()


    if card.id == 343:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 200 or randf() <= 0.1


    if card.id == 739:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 300 or randf() <= 0.1


    if card.id == 344:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 500 or randf() <= 0.1


    if card.id == 345:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 600 or randf() <= 0.1


    if card.id == 346:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 800 or randf() <= 0.1


    if card.id == 347:
        should_use = _has_any_monster_on_field() and duel_manager.player_lp <= 1000 and duel_manager.enemy_lp >= 500 or randf() <= 0.1


    elif card.id == 338:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 5000 or randf() <= 0.1)


    elif card.id == 339:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 4000 or randf() <= 0.1)


    elif card.id == 737:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 4000 or randf() <= 0.1)


    elif card.id == 340:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 3000 or randf() <= 0.1)


    elif card.id == 341:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 2000 or randf() <= 0.1)


    elif card.id == 342:
        should_use = _has_any_monster_on_field() and (duel_manager.enemy_lp <= 1000 or randf() <= 0.1)


    elif card.id == 665:
        should_use = randf() <= 0.1


    elif card.id == 680:
        should_use = randf() <= 0.1


    elif card.id == 691:
        should_use = randf() <= 0.1


    elif card.id == 678:
        should_use = _should_use_fissure()


    elif card.id == 693:
        should_use = _should_use_monster_reborn()


    elif card.id == 698:
        should_use = _should_use_change_of_heart()


    elif card.id == 337:
        should_use = _should_use_raigeki()


    elif card.id == 336:
        should_use = _should_use_dark_hole()


    elif card.id == 653:
        should_use = _should_use_warrior_elimination()


    elif card.id == 656:
        should_use = _should_use_eternal_rest()


    elif card.id == 662:
        should_use = _should_use_eradicating_aerosol()


    elif card.id == 663:
        should_use = _should_use_breath_of_light()


    elif card.id == 664:
        should_use = _should_use_eternal_draught()


    elif card.id == 672:
        should_use = _should_use_harpies_feather_duster()


    elif card.id == 804:
        should_use = _should_use_twister()


    elif card.id == 805:
        should_use = _should_use_book_of_life()


    elif card.id == 348:
        should_use = _should_use_swords_of_revealing_light() or randf() <= 0.1


    elif card.id == 350:
        should_use = _should_use_dark_piercing_light()


    elif card.id == 330:
        should_use = _should_use_forest()


    elif card.id == 331:
        should_use = _should_use_wasteland()


    elif card.id == 332:
        should_use = _should_use_mountain()


    elif card.id == 333:
        should_use = _should_use_sogen()


    elif card.id == 730:
        should_use = _should_use_flute_of_summoning_dragon()


    elif card.id == 732:
        should_use = randf() <= 0.1


    elif card.id == 791:
        should_use = _should_use_insect_imitation()


    elif card.id == 733:
        should_use = _should_use_last_will()


    elif card.id == 334:
        should_use = _should_use_umi()


    elif card.id == 335:
        should_use = _should_use_yami()


    elif card.id == 756:
        should_use = _should_use_sanctuary()


    elif card.id == 757:
        print("IA: Photon Booster encontrada - ALTA PRIORIDADE!")
        return await _try_use_equipment_card(hand_index, EQUIP_PHOTON_BOOSTER)


    elif card.id == 304:
        print("IA: Axe of Despair encontrada - PRIORIDADE MÁXIMA!")
        return await _try_use_equipment_card(hand_index, EQUIP_AXE_OF_DESPAIR)

    elif card.id == 777:
        print("IA: Gravity Axe Grarl encontrada - PRIORIDADE MÁXIMA!")
        return await _try_use_equipment_card(hand_index, EQUIP_GRAVITY_AXE_GRARL)


    elif card.id == 657:
        print("IA: Megamorph encontrada - PRIORIDADE MÁXIMA!")
        return await _try_use_equipment_card(hand_index, EQUIP_MEGAMORPH)


    elif card.id == 658:
        print("IA: Metalmorph encontrada - PRIORIDADE MÁXIMA!")
        return await _try_use_equipment_card(hand_index, EQUIP_METALMORPH)


    elif card.id == 311:
        print("IA: Black Pendant encontrada - ALTA PRIORIDADE!")
        return await _try_use_equipment_card(hand_index, EQUIP_BLACK_PENDANT)


    elif card.id == 303:
        return await _try_use_equipment_card(hand_index, EQUIP_DARK_ENERGY)


    elif card.id == 301:
        return await _try_use_equipment_card(hand_index, EQUIP_LEGENDARY_SWORD)


    elif card.id == 302:
        return await _try_use_equipment_card(hand_index, EQUIP_SWORD_DARK_DESTRUCTION)


    elif card.id == 305:
        print("IA: Laser Cannon Armor encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_LASER_CANNON_ARMOR)


    elif card.id == 306:
        print("IA: Insect Armor with Laser Cannon encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_INSECT_ARMOR_WITH_LASER_CANNON)


    elif card.id == 307:
        print("IA: Elf's Light encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_ELFS_LIGHT)


    elif card.id == 308:
        print("IA: Beast Fangs encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_BEAST_FANGS)


    elif card.id == 309:
        print("IA: Steel Shell encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_STEEL_SHELL)


    elif card.id == 310:
        print("IA: Vile Germs encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_VILE_GERMS)


    elif card.id == 312:
        print("IA: Silver Bow and Arrow encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_SILVER_BOW_ARROW)


    elif card.id == 313:
        print("IA: Horn of Light encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_HORN_OF_LIGHT)


    elif card.id == 314:
        print("IA: Horn of the Unicorn encontrada - ALTA PRIORIDADE!")
        return await _try_use_equipment_card(hand_index, EQUIP_HORN_OF_THE_UNICORN)


    elif card.id == 315:
        print("IA: Dragon Treasure encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_DRAGON_TREASURE)


    elif card.id == 316:
        print("IA: Electro-whip encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_ELECTRO_WHIP)


    elif card.id == 317:
        print("IA: Cyber Shield encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_CYBER_SHIELD)


    elif card.id == 318:
        print("IA: Elegant Egotist encontrada!")
        return await _try_use_elegant_egotist(hand_index)


    elif card.id == 319:
        print("IA: Mystical Moon encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_MYSTICAL_MOON)


    elif card.id == 320:
        print("IA: Stop Defense encontrada")
        return await _try_use_stop_defense(hand_index)


    elif card.id == 321:
        print("IA: Malevolent Nuzzler encontrada - PRIORIDADE ALTA!")
        return await _try_use_equipment_card(hand_index, EQUIP_MALEVOLENT_NUZZLER)


    elif card.id == 322:
        print("IA: Violet Crystal encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_VIOLET_CRYSTAL)


    elif card.id == 323:
        print("IA: Book of Secret Arts encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_BOOK_OF_SECRET_ARTS)


    elif card.id == 324:
        print("IA: Invigoration encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_INVIGORATION)


    elif card.id == 325:
        print("IA: Machine Conversion Factory encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_MACHINE_CONVERSION_FACTORY)


    elif card.id == 326:
        print("IA: Raise Body Heat encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_RAISE_BODY_HEAT)


    elif card.id == 327:
        print("IA: Follow Wind encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_FOLLOW_WIND)


    elif card.id == 328:
        print("IA: Power of Kaishin encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_POWER_OF_KAISHIN)


    elif card.id == 654:
        print("IA: Salamandra encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_SALAMANDRA)


    elif card.id == 738:
        print("IA: Gust Fan encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_GUST_FAN)


    elif card.id == 752:
        print("IA: Sword of Deep-Seated encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_SWORD_DEEP_SEATED)


    elif card.id == 652:
        print("IA: Magical Labyrinth encontrada")
        return await _try_use_equipment_card(hand_index, EQUIP_MAGICAL_LABYRINTH)

    if should_use:
        var spell_slot = _get_free_spell_slot()
        if spell_slot:
            var is_trap = (card.type == "Trap")
            var is_defense_set = is_trap
            enemy_hand[hand_index] = null
            duel_manager.update_enemy_hand_ui()
            await duel_manager.spawn_card_on_field(card, spell_slot, is_defense_set, false, false)
            await duel_manager.get_tree().create_timer(0.5).timeout
            if not is_trap:
                await duel_manager._resolve_magic_effect(spell_slot)
            return true

    return false


func _try_use_stop_defense(hand_index: int) -> bool:
    print("IA: Analisando uso de Stop Defense...")


    var best_target = null
    var best_priority = -9999

    for p_slot in player_slots:
        if p_slot.is_occupied:
            var p_card = p_slot.stored_card_data
            var p_visual = p_slot.spawn_point.get_child(0)


            var is_in_defense = false
            if p_visual:
                if p_visual.has_method("is_face_down") and p_visual.is_face_down():
                    is_in_defense = true
                else:
                    is_in_defense = (p_visual.rotation_degrees == 90)

            if is_in_defense:

                var priority = p_card.def - p_card.atk


                if p_visual.has_method("is_face_down") and p_visual.is_face_down():
                    priority += 1000

                if priority > best_priority:
                    best_priority = priority
                    best_target = p_slot

    if best_target and best_priority > 0:
        print("IA: Usando Stop Defense no monstro ", best_target.stored_card_data.name)


        await EffectManager.resolve_effect(enemy_hand[hand_index], false)


        await duel_manager.get_tree().create_timer(0.5).timeout


        if best_target.is_occupied:
            var p_visual = best_target.spawn_point.get_child(0)


            if p_visual.has_method("set_face_down"):
                p_visual.set_face_down(false)

            var target_rotation = 0
            var tween = create_tween()
            tween.tween_property(p_visual, "rotation_degrees", target_rotation, 0.3)

            print("IA: ", best_target.stored_card_data.name, " virado para ataque!")


        enemy_hand[hand_index] = null
        duel_manager.update_enemy_hand_ui()
        return true

    print("IA: Nenhum alvo bom para Stop Defense")
    return false

func _try_use_elegant_egotist(hand_index: int) -> bool:

    var harpy_lady_slot = null

    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.id == HARPY_LADY_ID:
            harpy_lady_slot = slot
            break

    if harpy_lady_slot:
        print("IA: Harpy Lady encontrada no campo! Usando Elegant Egotist...")


        await duel_manager._create_harpy_lady_copies(harpy_lady_slot.stored_card_data)


        enemy_hand[hand_index] = null
        duel_manager.update_enemy_hand_ui()
        return true
    else:
        print("IA: Não há Harpy Lady no campo para usar Elegant Egotist")
        return false

func _should_use_raigeki() -> bool:
    var highest_player_atk = 0
    var player_has_monsters = false

    for slot in player_slots:
        if slot.is_occupied:
            player_has_monsters = true
            if slot.stored_card_data.atk > highest_player_atk:
                highest_player_atk = slot.stored_card_data.atk

    if not player_has_monsters:
        return false

    var highest_hand_atk = 0
    for h_card in enemy_hand:
        if h_card and duel_manager._is_monster(h_card):
            if h_card.atk > highest_hand_atk:
                highest_hand_atk = h_card.atk

    return highest_player_atk >= 3000 or highest_hand_atk <= highest_player_atk

func _should_use_fissure() -> bool:
    var highest_player_atk = 0
    var player_has_face_up_monsters = false

    for slot in player_slots:
        if slot.is_occupied:
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down:
                player_has_face_up_monsters = true
                if slot.stored_card_data.atk > highest_player_atk:
                    highest_player_atk = slot.stored_card_data.atk

    if not player_has_face_up_monsters:
        return false

    var highest_hand_atk = 0
    for h_card in enemy_hand:
        if h_card and duel_manager._is_monster(h_card):
            if h_card.atk > highest_hand_atk:
                highest_hand_atk = h_card.atk

    return highest_player_atk >= 3000 or highest_hand_atk <= highest_player_atk

func _should_use_warrior_elimination() -> bool:
    print("IA: Verificando se deve usar Warrior Elimination...")

    var player_warriors = 0
    var enemy_warriors = 0

    for slot in player_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "warrior":
                player_warriors += 1

    for slot in enemy_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "warrior":
                enemy_warriors += 1

    return player_warriors > enemy_warriors or (player_warriors > 0 and enemy_warriors == 0)

func _should_use_eradicating_aerosol() -> bool:
    print("IA: Verificando se deve usar Eradicating Aerosol...")

    var player_insects = 0
    var enemy_insects = 0

    for slot in player_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "insect":
                player_insects += 1

    for slot in enemy_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "insect":
                enemy_insects += 1

    return player_insects > enemy_insects or (player_insects > 0 and enemy_insects == 0)

func _should_use_breath_of_light() -> bool:
    print("IA: Verificando se deve usar Breath of Light...")

    var player_rocks = 0
    var enemy_rocks = 0

    for slot in player_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "rock":
                player_rocks += 1

    for slot in enemy_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "rock":
                enemy_rocks += 1

    return player_rocks > enemy_rocks or (player_rocks > 0 and enemy_rocks == 0)

func _should_use_eternal_draught() -> bool:
    print("IA: Verificando se deve usar Eternal Draught...")

    var player_fish = 0
    var enemy_fish = 0

    for slot in player_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "fish":
                player_fish += 1

    for slot in enemy_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down and slot.stored_card_data.type.to_lower() == "fish":
                enemy_fish += 1

    return player_fish > enemy_fish or (player_fish > 0 and enemy_fish == 0)

func _should_use_harpies_feather_duster() -> bool:
    print("IA: Verificando se deve usar Harpie's Feather Duster...")

    for slot in player_slots:


        break
    for slot in duel_manager.player_spell_slots:
        if slot.is_occupied:
            return true
    return false

func _should_use_twister() -> bool:
    print("IA: Verificando se deve usar Twister...")

    for slot in duel_manager.player_spell_slots:
        if slot.is_occupied:
            return true
    return false

func _should_use_book_of_life() -> bool:
    print("IA: Verificando se deve usar Book of Life...")


    var has_zombie_in_grave = false
    for grave_card in duel_manager.enemy_graveyard:
        if grave_card and "zombie" in str(grave_card.type).to_lower():
            has_zombie_in_grave = true
            break

    if not has_zombie_in_grave:
        return false


    return randf() <= 0.1

func _should_use_eternal_rest() -> bool:
    print("IA: Verificando se deve usar Eternal Rest...")

    var player_buffed = 0
    var enemy_buffed = 0

    for slot in player_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down:
                var card = slot.stored_card_data
                var original_db_card = CardDatabase.get_card(card.id)
                if original_db_card and (card.atk > original_db_card.atk or card.def > original_db_card.def):
                    player_buffed += 1

    for slot in enemy_slots:
        if slot.is_occupied and duel_manager._is_monster(slot.stored_card_data):
            var is_face_down = false
            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("is_face_down") and visual.is_face_down():
                    is_face_down = true

            if not is_face_down:
                var card = slot.stored_card_data
                var original_db_card = CardDatabase.get_card(card.id)
                if original_db_card and (card.atk > original_db_card.atk or card.def > original_db_card.def):
                    enemy_buffed += 1

    return player_buffed > enemy_buffed or (player_buffed > 0 and enemy_buffed == 0)

func _should_use_dark_hole() -> bool:
    print("IA: Verificando se deve usar Dark Hole...")






    var player_monster_count = 0
    var player_total_atk = 0
    var player_has_strong_monsters = false


    for slot in player_slots:
        if slot.is_occupied:
            player_monster_count += 1
            var monster = slot.stored_card_data
            player_total_atk += monster.atk


            if monster.atk > 1500:
                player_has_strong_monsters = true

    var ia_monster_count = 0
    var ia_total_atk = 0


    for slot in enemy_slots:
        if slot.is_occupied:
            ia_monster_count += 1
            var monster = slot.stored_card_data
            ia_total_atk += monster.atk


    if player_monster_count <= ia_monster_count:
        print("IA: Jogador não tem mais monstros (", player_monster_count, " vs ", ia_monster_count, ")")
        return false


    if not player_has_strong_monsters:
        print("IA: Jogador não tem monstros fortes")
        return false


    if player_total_atk <= ia_total_atk:
        print("IA: Jogador não tem mais ATK total (", player_total_atk, " vs ", ia_total_atk, ")")
        return false

    print("IA: Condições para Dark Hole atendidas!")
    print("  - Monstros: Jogador=", player_monster_count, " IA=", ia_monster_count)
    print("  - ATK total: Jogador=", player_total_atk, " IA=", ia_total_atk)
    print("  - Jogador tem monstros fortes: ", player_has_strong_monsters)

    return true

func _activate_dark_hole(hand_index: int) -> bool:
    print("IA: Ativando Dark Hole...")


    var spell_slot = await _get_free_spell_slot()
    if not spell_slot:
        print("IA: Não há slot de spell livre para Dark Hole")
        return false


    var card_to_play = enemy_hand[hand_index]
    enemy_hand[hand_index] = null
    duel_manager.update_enemy_hand_ui()


    await duel_manager.spawn_card_on_field(card_to_play, spell_slot, false, false, false)

    await duel_manager.get_tree().create_timer(0.5).timeout


    await EffectManager.resolve_effect(card_to_play, false)

    return true

func _should_use_swords_of_revealing_light() -> bool:
    print("IA: Verificando se deve usar Swords of Revealing Light...")

    if EffectManager.swords_of_revealing_light_active:
        if not EffectManager.swords_of_revealing_light_owner_is_player:
            print("IA: Já tem Swords ativa (ativada por mim mesmo)")
            return false


    var player_strong_monsters_count = 0
    var ia_total_atk = 0
    var ia_monster_count = 0


    for p_slot in player_slots:
        if p_slot.is_occupied:
            var p_visual = p_slot.spawn_point.get_child(0)
            if p_visual and p_visual.rotation_degrees == 0:
                var p_card = p_slot.stored_card_data
                if p_card.atk > 1500:
                    player_strong_monsters_count += 1


    for e_slot in enemy_slots:
        if e_slot.is_occupied:
            ia_monster_count += 1
            var e_card = e_slot.stored_card_data
            ia_total_atk += e_card.atk


    var player_total_atk = 0
    var player_monster_count = 0

    for p_slot in player_slots:
        if p_slot.is_occupied:
            var p_visual = p_slot.spawn_point.get_child(0)
            if p_visual and (p_visual.rotation_degrees == 0 or duel_manager._has_card_back(p_visual)):
                player_monster_count += 1
                var p_card = p_slot.stored_card_data
                player_total_atk += p_card.atk

    var player_avg_atk = player_total_atk / max(1, player_monster_count)
    var ia_avg_atk = ia_total_atk / max(1, ia_monster_count)



    var should_use = (player_strong_monsters_count >= 2 and 
                     player_avg_atk > ia_avg_atk and 
                     player_monster_count >= 2)

    print("IA: Swords of Revealing Light - Decisão: ", should_use)
    print("  - Monstros fortes do jogador: ", player_strong_monsters_count)
    print("  - ATK médio jogador: ", player_avg_atk, " vs IA: ", ia_avg_atk)

    return should_use

func _should_use_dark_piercing_light() -> bool:
    print("IA: Verificando se deve usar Dark-piercing Light...")


    var face_down_count = 0

    for p_slot in player_slots:
        if p_slot.is_occupied:
            var p_visual = p_slot.spawn_point.get_child(0)
            if p_visual and _is_card_face_down_ai(p_visual):
                face_down_count += 1


    var should_use = (face_down_count >= 2)

    print("IA: Dark-piercing Light - Decisão: ", should_use)
    print("  - Cartas face-down do jogador: ", face_down_count)

    print("IA: Dark-piercing Light - Decisão: ", should_use)
    print("  - Cartas face-down do jogador: ", face_down_count)

    return should_use

func _should_use_monster_reborn() -> bool:
    print("IA: Verificando se deve usar Monster Reborn (ID 693)...")


    var has_empty_slot = false
    for slot in enemy_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("IA: Monster Reborn - Sem slots vazios.")
        return false


    var found_strong_monster = false


    if duel_manager.player_graveyard:
        for card in duel_manager.player_graveyard:
            if card.type != "Magic" and card.type != "Trap":
                if card.atk >= 2000:
                    found_strong_monster = true
                    print("IA: Encontrado monstro forte no GY do Jogador: ", card.name, " (", card.atk, ")")
                    break

    if not found_strong_monster and duel_manager.enemy_graveyard:
        for card in duel_manager.enemy_graveyard:
            if card.type != "Magic" and card.type != "Trap":
                if card.atk >= 2000:
                    found_strong_monster = true
                    print("IA: Encontrado monstro forte no GY Inimigo: ", card.name, " (", card.atk, ")")
                    break

    if found_strong_monster:
        print("IA: Monster Reborn - Decisão: SIM (Slot vazio + Monstro forte)")
        return true

    print("IA: Monster Reborn - Decisão: NÃO (Nenhum monstro com >= 2000 ATK)")
    return false

func _should_use_change_of_heart() -> bool:
    print("IA: Verificando se deve usar Change of Heart (ID 698)...")

    var ia_strongest_atk = -1
    var has_face_up_monster = false


    for slot in enemy_slots:
        if slot.is_occupied:
            var is_face_up = false
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

            if card_visual:
                 if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                 elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)
                 else:
                    is_face_up = (card_visual.rotation_degrees == 0 or card_visual.rotation_degrees == 180)

            if is_face_up:
                has_face_up_monster = true
                if slot.stored_card_data.atk > ia_strongest_atk:
                    ia_strongest_atk = slot.stored_card_data.atk

    if not has_face_up_monster:
        print("IA: Change of Heart - Sem monstros face-up no campo da IA.")
        return false


    var player_strongest_atk = -1
    var has_player_face_up_monster = false

    for slot in player_slots:
         if slot.is_occupied:
            var is_face_up = false
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
            if card_visual:
                 if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                 elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)
                 else:
                    is_face_up = (card_visual.rotation_degrees == 0 or card_visual.rotation_degrees == 180)

            if is_face_up:
                has_player_face_up_monster = true
                if slot.stored_card_data.atk > player_strongest_atk:
                    player_strongest_atk = slot.stored_card_data.atk

    if not has_player_face_up_monster:
         print("IA: Change of Heart - Jogador sem monstros face-up.")
         return false


    if player_strongest_atk > ia_strongest_atk:
        print("IA: Change of Heart - Decisão: SIM (Player tem monstro mais forte: %d > %d)" % [player_strongest_atk, ia_strongest_atk])
        return true

    print("IA: Change of Heart - Decisão: NÃO (Player não tem monstro mais forte)")
    return false

func _is_card_face_down_ai(card_visual) -> bool:


    if card_visual.has_method("is_face_down"):
        return card_visual.is_face_down()


    elif duel_manager.has_method("_has_card_back") and duel_manager._has_card_back(card_visual):
        return true

    return false

func _should_use_forest() -> bool:
    if duel_manager.current_field_type == "Forest":
        return false

    var beneficial_types = ["Beast-Warrior", "Insect", "Plant", "Beast"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_wasteland() -> bool:
    if duel_manager.current_field_type == "Wasteland":
        return false

    var beneficial_types = ["Dinosaur", "Zombie", "Rock"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_mountain() -> bool:
    if duel_manager.current_field_type == "Mountain":
        return false

    var beneficial_types = ["Dragon", "Winged-Beast", "Thunder"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_sanctuary() -> bool:
    if not duel_manager: return false


    if EffectManager.active_field_id == 756:
        return false


    var my_fairies = 0
    var opp_fairies = 0

    for slot in duel_manager.enemy_slots:
        if slot.is_occupied:
            var card = slot.stored_card_data
            if card.type.to_lower() == "fairy":
                my_fairies += 1

    for slot in duel_manager.player_slots:
        if slot.is_occupied:
            var card = slot.stored_card_data
            if card.type.to_lower() == "fairy":
                opp_fairies += 1


    for card_visual in duel_manager.enemy_hand:
        var card = card_visual.card_data
        if card and card.type.to_lower() == "fairy" and card.type != "Magic" and card.type != "Trap" and card.type != "Equip" and card.type != "Ritual":
            my_fairies += 1


    if my_fairies > opp_fairies:
        return randf() <= 0.85
    elif my_fairies > 0 and opp_fairies == 0:
        return randf() <= 0.9

    return randf() <= 0.2

func _should_use_sogen() -> bool:
    if duel_manager.current_field_type == "Sogen":
        return false

    var beneficial_types = ["Beast-Warrior", "Warrior"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_umi() -> bool:
    if duel_manager.current_field_type == "Umi":
        return false

    var beneficial_types = ["Fish", "Sea Serpent", "Aqua", "Thunder"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_yami() -> bool:
    if duel_manager.current_field_type == "Yami":
        return false

    var beneficial_types = ["Fiend", "Spellcaster"]
    for slot in enemy_slots:
        if slot.is_occupied and slot.stored_card_data.type in beneficial_types:
            return true
    return false

func _should_use_flute_of_summoning_dragon() -> bool:
    print("IA: Analisando uso de The Flute of Summoning Dragon (ID 730)...")

    var has_empty_slot = false
    for slot in enemy_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("IA: Nenhum slot vazio para invocar o(s) dragão(ões).")
        return false

    var has_valid_dragon = false
    for d_card in duel_manager.enemy_deck_pile:
        if d_card.type == "Dragon" and d_card.level <= 4:
            has_valid_dragon = true
            break

    if not has_valid_dragon:
        print("IA: Nenhum dragão level <= 4 no deck.")
        return false

    print("IA: Condições ideais para usar The Flute of Summoning Dragon!")
    return true

func _should_use_insect_imitation() -> bool:
    print("IA: Verificando se deve usar Insect Imitation...")


    var has_empty_slot = false
    for slot in enemy_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("IA: Nenhum slot vazio para Insect Imitation")
        return false


    var has_faceup_insect = false
    for slot in enemy_slots:
        if slot.is_occupied:
            var card = slot.stored_card_data
            if card and card.type.to_lower() == "insect":

                var is_face_up = false
                if slot.spawn_point.get_child_count() > 0:
                    var visual = slot.spawn_point.get_child(0)
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()

                if is_face_up:
                    has_faceup_insect = true
                    break

    if not has_faceup_insect:
        print("IA: Nenhum monstro Insect face-up para Insect Imitation")
        return false

    print("IA: Decidido usar Insect Imitation!")
    return true

func _should_use_last_will() -> bool:
    print("IA: Analisando uso de Last Will (ID 733)...")

    var has_empty_slot = false
    for slot in enemy_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("IA: Nenhum slot vazio para invocar monstro pelo Last Will.")
        return false

    var has_valid_target = false
    for d_card in duel_manager.enemy_deck_pile:
        if d_card.type != "Magic" and d_card.type != "Trap" and d_card.atk <= 1500:
            has_valid_target = true
            break

    if not has_valid_target:
        print("IA: Nenhum monstro com ATK <= 1500 no deck.")
        return false

    print("IA: Condições ideais para usar Last Will!")
    return true

func _should_use_commencement_dance() -> bool:
    print("IA: Verificando se pode usar Commencement Dance...")


    var has_all_required = true
    var found_cards = []

    for required_id in COMMENCEMENT_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Commencement Dance!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Commencement Dance")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_javelin_beetle_pact() -> bool:
    print("IA: Verificando se pode usar Javelin Beetle Pact...")


    var has_all_required = true
    var found_cards = []

    for required_id in JAVELIN_BEETLE_PACT_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Javelin Beetle Pact!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Javelin Beetle Pact")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_black_magic_ritual() -> bool:
    print("IA: Verificando se pode usar Black Magic Ritual...")


    var has_all_required = true
    var found_cards = []

    for required_id in BLACK_MAGIC_RITUAL_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Black Magic Ritual!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Black Magic Ritual")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_fortress_whale_oath() -> bool:
    print("IA: Verificando se pode usar Fortress Whale Oath...")


    var has_all_required = true
    var found_cards = []

    for required_id in FORTRESS_WHALE_OATH_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Fortress Whale Oath!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Fortress Whale Oath!")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_garma_sword_oath() -> bool:
    print("IA: Verificando se pode usar Garma Sword Oath...")


    var has_all_required = true
    var found_cards = []

    for required_id in GARMA_SWORD_OATH_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Garma Sword Oath!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Garma Sword Oath")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_resurrection_of_chakra() -> bool:
    print("IA: Verificando se pode usar Resurrection of Chakra...")


    var has_all_required = true
    var found_cards = []

    for required_id in RESURRECTION_OF_CHAKRA_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Resurrection of Chakra!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Resurrection of Chakra")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_turtle_oath() -> bool:
    print("IA: Verificando se pode usar Turtle Oath...")


    var has_all_required = true
    var found_cards = []

    for required_id in TURTLE_OATH_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Turtle Oath!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Turtle Oath")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_novox_prayer() -> bool:
    print("IA: Verificando se pode usar Novox Prayer...")


    var has_all_required = true
    var found_cards = []

    for required_id in NOVOX_PRAYER_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Novox Prayer!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Novox Prayer")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_revival_of_dokurorider() -> bool:
    print("IA: Verificando se pode usar Revival of Dokurorider...")


    var has_all_required = true
    var found_cards = []

    for required_id in REVIVAL_OF_DOKURORIDER_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Revival of Dokurorider!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Revival of Dokurorider")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_hamburger_recipe() -> bool:
    print("IA: Verificando se pode usar Hamburger Recipe...")


    var has_all_required = true
    var found_cards = []

    for required_id in HAMBURGER_RECIPE_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Hamburger Recipe!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Hamburger Recipe")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_warlion_ritual() -> bool:
    print("IA: Verificando se pode usar Warlion Ritual...")


    var has_all_required = true
    var found_cards = []

    for required_id in WARLION_RITUAL_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Warlion Ritual!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Warlion Ritual")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_zera_ritual() -> bool:
    print("IA: Verificando se pode usar Zera Ritual...")


    var has_all_required = true
    var found_cards = []

    for required_id in ZERA_RITUAL_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Zera Ritual!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Zera Ritual")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_black_luster_ritual() -> bool:
    print("IA: Verificando se pode usar Black Luster Ritual...")


    var has_all_required = true
    var found_cards = []

    for required_id in BLACK_LUSTER_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Black Luster Ritual!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Black Luster Ritual")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false

func _should_use_beastly_mirror_ritual() -> bool:
    print("IA: Verificando se pode usar Beastly Mirror Ritual...")


    var has_all_required = true
    var found_cards = []

    for required_id in BEASTLY_MIRROR_REQUIRED_IDS:
        var has_card = false
        for hand_card in enemy_hand:
            if hand_card and hand_card.id == required_id:
                has_card = true
                found_cards.append(hand_card.name)
                break

        if not has_card:
            has_all_required = false
            print("  - Falta carta ID: ", required_id)

    if has_all_required:
        print("IA: Tem todas as cartas para Beastly Mirror Ritual!")
        for card_name in found_cards:
            print("  - ", card_name)


        var has_empty_slot = false
        for slot in enemy_slots:
            if not slot.is_occupied:
                has_empty_slot = true
                break

        if has_empty_slot:
            print("IA: Tem slot vazio, pode usar Beastly Mirror Ritual")
            return true
        else:
            print("IA: Sem slot vazio, não pode invocar")

    return false


func _try_use_equipment_card(hand_index: int, equip_id: int) -> bool:
    var best_target_slot = null
    var highest_atk = -1


    var is_axe_of_despair = (equip_id == EQUIP_AXE_OF_DESPAIR)
    var is_megamorph = (equip_id == EQUIP_MEGAMORPH)
    var is_metalmorph = (equip_id == EQUIP_METALMORPH)


    var is_cyber_shield = (equip_id == EQUIP_CYBER_SHIELD)

    for slot in enemy_slots:
        if slot.is_occupied:
            var monster = slot.stored_card_data
            if duel_manager._is_valid_equip_target(monster, equip_id) and monster.atk > highest_atk:

                var priority_score = monster.atk


                if is_axe_of_despair:
                    if monster.atk > 2000:
                        priority_score += 5000
                    elif monster.atk > 1500:
                        priority_score += 3000
                    elif monster.atk > 1000:
                        priority_score += 1000

                if is_megamorph or is_metalmorph:
                    if monster.atk > 2000:
                        priority_score += 5000
                    elif monster.atk > 1500:
                        priority_score += 3000
                    elif monster.atk > 1000:
                        priority_score += 1000



                if equip_id == EQUIP_BLACK_PENDANT:
                    if monster.def > 1500:
                        priority_score += 1000
                    elif monster.def > 1000:
                        priority_score += 500


                if is_cyber_shield:

                    if monster.atk > 1500:
                        priority_score += 3000
                    elif monster.atk > 1000:
                        priority_score += 1500

                if priority_score > highest_atk:
                    highest_atk = priority_score
                    best_target_slot = slot

    if best_target_slot:
        duel_manager._apply_equip_bonus(best_target_slot.stored_card_data, equip_id, false)
        var visual = best_target_slot.spawn_point.get_child(0)
        visual.animate_stats_bonus(best_target_slot.stored_card_data.atk, best_target_slot.stored_card_data.def)
        enemy_hand[hand_index] = null
        duel_manager.send_to_graveyard(enemy_hand[hand_index], false)
        duel_manager.update_enemy_hand_ui()
        return true

    return false


func _try_activate_equip_from_field() -> bool:
    for slot in enemy_spell_slots:
        if slot.is_occupied:
            var card = slot.stored_card_data
            if card and card.type == "Equip":

                if card.id in [EQUIP_DARK_ENERGY, EQUIP_LEGENDARY_SWORD, EQUIP_SWORD_DARK_DESTRUCTION, EQUIP_BEAST_FANGS, 
                EQUIP_AXE_OF_DESPAIR, EQUIP_ELEGANT_EGOTIST, EQUIP_SALAMANDRA, EQUIP_MAGICAL_LABYRINTH, EQUIP_MEGAMORPH, EQUIP_METALMORPH, 
                EQUIP_GUST_FAN, EQUIP_SWORD_DEEP_SEATED, EQUIP_PHOTON_BOOSTER, EQUIP_GRAVITY_AXE_GRARL, 
                EQUIP_DRAGON_TREASURE, EQUIP_ELFS_LIGHT, EQUIP_HORN_OF_LIGHT, EQUIP_HORN_OF_THE_UNICORN, EQUIP_INSECT_ARMOR_WITH_LASER_CANNON, 
                EQUIP_LASER_CANNON_ARMOR, EQUIP_SILVER_BOW_ARROW, EQUIP_STEEL_SHELL, EQUIP_VILE_GERMS, EQUIP_ELECTRO_WHIP, EQUIP_CYBER_SHIELD, 
                EQUIP_ELEGANT_EGOTIST, EQUIP_MYSTICAL_MOON, EQUIP_MALEVOLENT_NUZZLER, EQUIP_VIOLET_CRYSTAL, EQUIP_BOOK_OF_SECRET_ARTS, 
                EQUIP_INVIGORATION, EQUIP_MACHINE_CONVERSION_FACTORY, EQUIP_RAISE_BODY_HEAT, EQUIP_FOLLOW_WIND, EQUIP_POWER_OF_KAISHIN]:

                    var best_target_slot = null
                    var highest_atk = -1

                    for monster_slot in enemy_slots:
                        if monster_slot.is_occupied:
                            var monster = monster_slot.stored_card_data
                            if duel_manager._is_valid_equip_target(monster, card.id) and monster.atk > highest_atk:
                                highest_atk = monster.atk
                                best_target_slot = monster_slot

                    if best_target_slot:

                        duel_manager._apply_equip_bonus(best_target_slot.stored_card_data, card.id, false)
                        var visual = best_target_slot.spawn_point.get_child(0)
                        visual.animate_stats_bonus(best_target_slot.stored_card_data.atk, best_target_slot.stored_card_data.def)
                        return true

    return false

func _get_free_spell_slot() -> Node:
    for slot in enemy_spell_slots:
        if not slot.is_occupied:
            return slot
    return null


func _play_monster(can_fusion: bool) -> bool:
    var best_card: CardData = null
    var indices_to_discard: Array = []
    var was_fusion = false
    var visual_fusion_frame = false
    var original_fusion_cards: Array[CardData] = []
    var intermediate_fusion_results: Array[CardData] = []

    var can_use_exodia = _can_use_exodia_pieces()


    var kuriboh_index = -1
    for i in range(enemy_hand.size()):
        if enemy_hand[i] and enemy_hand[i].id == KURIBOH_ID:
            kuriboh_index = i
            break


    if kuriboh_index != -1:
        best_card = enemy_hand[kuriboh_index]
        indices_to_discard = [kuriboh_index]


        var is_defense = true
        var is_face_down = false


        var chosen_slot = null
        for i in range(enemy_slots.size() - 1, -1, -1):
            if not enemy_slots[i].is_occupied:
                chosen_slot = enemy_slots[i]
                break


        if not chosen_slot:
            var lowest_stat = 99999
            var weak_idx = 0

            for i in range(enemy_slots.size()):
                var c = enemy_slots[i].stored_card_data
                if c.atk < lowest_stat:
                    lowest_stat = c.atk
                    weak_idx = i

            chosen_slot = enemy_slots[weak_idx]
            duel_manager.send_to_graveyard(enemy_slots[weak_idx].stored_card_data, false, true)


        enemy_hand[kuriboh_index] = null
        duel_manager.update_enemy_hand_ui()


        await duel_manager.spawn_card_on_field(
            best_card, 
            chosen_slot, 
            is_defense, 
            false, 
            false, 
            true
        )

        return true


    if can_fusion:
        var fusion_result = _try_hand_fusion(can_use_exodia)
        if fusion_result:
            best_card = fusion_result.card
            indices_to_discard = fusion_result.indices
            was_fusion = fusion_result.was_fusion
            visual_fusion_frame = fusion_result.visual_frame


            for idx in indices_to_discard:
                if enemy_hand[idx]:
                    original_fusion_cards.append(enemy_hand[idx])


    if not best_card and not can_fusion:
        var equip_result = _try_equip_only(can_use_exodia)
        if equip_result:
            best_card = equip_result.card
            indices_to_discard = equip_result.indices
            was_fusion = equip_result.was_fusion
            visual_fusion_frame = equip_result.visual_frame

            for idx in indices_to_discard:
                if enemy_hand[idx]:
                    original_fusion_cards.append(enemy_hand[idx])


    if not best_card:
        var best_monster = _get_best_hand_monster(can_use_exodia)
        if best_monster:
            best_card = best_monster.card
            indices_to_discard = [best_monster.index]


    if not best_card and can_use_exodia:
        for i in range(enemy_hand.size()):
            if enemy_hand[i] and duel_manager._is_monster(enemy_hand[i]):
                best_card = enemy_hand[i]
                indices_to_discard = [i]
                break

    if not best_card:
        return false


    var highest_player_atk = _get_highest_player_atk()
    var is_defense = false
    var is_face_down = false

    var eff_stats = _get_effective_hand_stats(best_card)
    var eff_atk = eff_stats.atk
    var eff_def = eff_stats.def


    if is_defense and is_face_down:
        var slot_owner_is_player = false

        if EffectManager.swords_of_revealing_light_active:


            var swords_owner_is_player = EffectManager.swords_of_revealing_light_owner_is_player

            if swords_owner_is_player:
                print("IA: Jogador tem Swords ativa, não posso colocar face-down")
                is_face_down = false

                if eff_atk > eff_def:
                    is_defense = false


    if best_card.id == KURIBOH_ID:
        is_defense = true
        is_face_down = false
    elif eff_atk < highest_player_atk and highest_player_atk > 0:

        var can_beat_with_bonus = false
        for p_slot in player_slots:
            if p_slot.is_occupied:
                var effective_atk = _get_ai_effective_atk(best_card, p_slot.stored_card_data)
                var target_atk = duel_manager.get_effective_atk(p_slot.stored_card_data, best_card)
                if effective_atk > target_atk:
                    can_beat_with_bonus = true
                    break

        if can_beat_with_bonus:

            is_defense = false
            is_face_down = false
            print("IA: Monstro mais fraco mas bônus (guardian/Metalmorph) dá vantagem! Modo ataque.")
        else:
            var best_def_monster = _get_best_def_monster(can_use_exodia)
            if best_def_monster and _get_effective_hand_stats(best_def_monster.card).def > eff_def:
                best_card = best_def_monster.card
                indices_to_discard = [best_def_monster.index]
                was_fusion = false
                visual_fusion_frame = false

            is_defense = true
            is_face_down = true
    elif eff_atk == highest_player_atk and highest_player_atk > 0:

        if eff_def < highest_player_atk:


            if randf() <= 0.25:
                is_defense = false
                is_face_down = false
                print("IA: ATK igual, DEF fraca. Kamikaze! Modo ataque.")
            else:
                is_defense = false
                is_face_down = false
                print("IA: ATK igual, DEF fraca. Modo ataque (defesa seria pior).")
        else:

            is_defense = true
            is_face_down = true


    if best_card.id in SUMMON_FACE_UP_IDS:
        is_defense = false
        is_face_down = false

    if can_use_exodia and best_card.id in EXODIA_IDS:
        is_defense = true
        is_face_down = true


    var slot_data = _choose_enemy_slot_with_flags(best_card, can_fusion, highest_player_atk, was_fusion, visual_fusion_frame, is_defense, is_face_down)


    var chosen_slot = slot_data.slot
    var previous_best_card = best_card
    best_card = slot_data.card if slot_data.has("card") else best_card
    was_fusion = slot_data.was_fusion
    visual_fusion_frame = slot_data.visual_fusion_frame
    is_defense = slot_data.is_defense
    is_face_down = slot_data.is_face_down


    var had_hand_fusion = original_fusion_cards.size() > 0


    if was_fusion and best_card != previous_best_card and original_fusion_cards.size() == 0:

        original_fusion_cards.append(previous_best_card)

    if not chosen_slot:
        return false


    var should_play_failed_fusion = false
    var hand_fusion_materials_to_graveyard: Array[CardData] = []
    var field_fusion_happened = was_fusion and best_card != previous_best_card

    if chosen_slot.is_occupied and chosen_slot.stored_card_data:
        var field_card_for_animation = chosen_slot.stored_card_data

        if field_fusion_happened:

            if had_hand_fusion:

                print("[IA DEBUG] Hand fusion + field fusion detected!")
                print("  Original cards: ", original_fusion_cards.size())

                hand_fusion_materials_to_graveyard = original_fusion_cards.duplicate()
                print("  Materials saved: ", hand_fusion_materials_to_graveyard.size())

                var hand_result = previous_best_card
                print("  Hand result: ", hand_result.name if hand_result else "NULL")
                original_fusion_cards = [hand_result, field_card_for_animation]
            else:

                original_fusion_cards.insert(0, field_card_for_animation)
            duel_manager.send_to_graveyard(chosen_slot.stored_card_data, false, true)
        else:

            if had_hand_fusion:

                hand_fusion_materials_to_graveyard = original_fusion_cards.duplicate()

            should_play_failed_fusion = true
            original_fusion_cards = [field_card_for_animation, best_card]
            duel_manager.send_to_graveyard(chosen_slot.stored_card_data, false, true)
            was_fusion = false
            visual_fusion_frame = false
            is_face_down = false



    print("[IA DEBUG] Checking hand fusion animations. Materials count: ", hand_fusion_materials_to_graveyard.size(), " had_hand_fusion: ", had_hand_fusion)
    if had_hand_fusion and hand_fusion_materials_to_graveyard.size() >= 2:

        print("[IA DEBUG] Playing hand fusion animations (2+ cards)!")

        var current_card = hand_fusion_materials_to_graveyard[0]

        for i in range(1, hand_fusion_materials_to_graveyard.size()):
            var next_card = hand_fusion_materials_to_graveyard[i]


            var result_card: CardData
            if i == hand_fusion_materials_to_graveyard.size() - 1:

                result_card = previous_best_card
            else:

                var fusion_result = FusionDatabase.try_fusion([current_card, next_card])
                if fusion_result:
                    result_card = fusion_result
                    intermediate_fusion_results.append(result_card)
                else:
                    if duel_manager._is_monster(current_card) and next_card.type == "Equip":
                        result_card = current_card.get_copy()
                        duel_manager._apply_equip_bonus(result_card, next_card.id, false)
                    elif current_card.type == "Equip" and duel_manager._is_monster(next_card):
                        result_card = next_card.get_copy()
                        duel_manager._apply_equip_bonus(result_card, current_card.id, false)
                    else:
                        result_card = next_card


            await duel_manager._play_fusion_cutscene(current_card, next_card, result_card, true)
            current_card = result_card
    elif had_hand_fusion and hand_fusion_materials_to_graveyard.size() == 1:

        print("[IA DEBUG] Playing hand fusion animation (1 card edge case)!")
        var material = hand_fusion_materials_to_graveyard[0]
        await duel_manager._play_fusion_cutscene(material, previous_best_card, previous_best_card, true)


    if was_fusion and original_fusion_cards.size() >= 2:

        var current_card = original_fusion_cards[0]

        for i in range(1, original_fusion_cards.size()):
            var next_card = original_fusion_cards[i]


            var result_card: CardData
            var is_fusion_valid = false

            if i == original_fusion_cards.size() - 1:

                result_card = best_card
                is_fusion_valid = true
            else:

                var fusion_result = FusionDatabase.try_fusion([current_card, next_card])
                if fusion_result:
                    is_fusion_valid = true
                    result_card = fusion_result

                    intermediate_fusion_results.append(result_card)
                else:

                    if duel_manager._is_monster(current_card) and next_card.type == "Equip":
                        is_fusion_valid = true
                        result_card = current_card.get_copy()
                        duel_manager._apply_equip_bonus(result_card, next_card.id, false)
                    elif current_card.type == "Equip" and duel_manager._is_monster(next_card):
                        is_fusion_valid = true
                        result_card = next_card.get_copy()
                        duel_manager._apply_equip_bonus(result_card, current_card.id, false)
                    else:
                        is_fusion_valid = false
                        result_card = next_card


            await duel_manager._play_fusion_cutscene(current_card, next_card, result_card, is_fusion_valid)


            current_card = result_card
    elif should_play_failed_fusion and original_fusion_cards.size() >= 2:

        var card_a = original_fusion_cards[0]
        var card_b = original_fusion_cards[1]
        await duel_manager._play_fusion_cutscene(card_a, card_b, card_b, false)




    if was_fusion and original_fusion_cards.size() >= 2:

        var has_equip = false
        for oc in original_fusion_cards:
            if oc.type == "Equip":
                has_equip = true
                break

        if has_equip and not duel_manager.reverse_trap_active_enemy:
            duel_manager._check_and_activate_reverse_trap(false)

            if duel_manager.reverse_trap_active_enemy:

                var recalc_card = null
                for oc in original_fusion_cards:
                    if recalc_card == null:
                        recalc_card = oc.get_copy()
                    else:
                        var fused = FusionDatabase.try_fusion([recalc_card, oc])
                        if fused:
                            recalc_card = fused.get_copy()
                        else:

                            if duel_manager._is_monster(recalc_card) and oc.type == "Equip":
                                var eq_copy = recalc_card.get_copy()
                                duel_manager._apply_equip_bonus(eq_copy, oc.id, false)
                                recalc_card = eq_copy
                            elif recalc_card.type == "Equip" and duel_manager._is_monster(oc):
                                var eq_copy = oc.get_copy()
                                duel_manager._apply_equip_bonus(eq_copy, recalc_card.id, false)
                                recalc_card = eq_copy
                            else:
                                recalc_card = oc

                if recalc_card:
                    best_card = recalc_card
                    print("Reverse Trap: Recalculado best_card da IA com bônus invertidos!")


    var discarded_cards = {}
    for idx in indices_to_discard:
        if enemy_hand[idx]:
            discarded_cards[idx] = enemy_hand[idx]


    for idx in indices_to_discard:
        enemy_hand[idx] = null

    duel_manager.update_enemy_hand_ui()



    var force_face_up = should_play_failed_fusion or was_fusion
    await duel_manager.spawn_card_on_field(
        best_card, 
        chosen_slot, 
        is_defense, 
        false, 
        visual_fusion_frame, 
        force_face_up
    )




    if was_fusion and hand_fusion_materials_to_graveyard.size() == 0:
        var card_kept_for_field = false

        for idx in indices_to_discard:
            if discarded_cards.has(idx):
                var card = discarded_cards[idx]



                if not card_kept_for_field and card.id == best_card.id:
                    card_kept_for_field = true
                    print("  -> Preservando ", card.name, " para o campo (não descarta)")
                    continue

                duel_manager.send_to_graveyard(card, false)



    for material in hand_fusion_materials_to_graveyard:
        if material.id != best_card.id:
            duel_manager.send_to_graveyard(material, false)


    for intermediate in intermediate_fusion_results:
        duel_manager.send_to_graveyard(intermediate, false)

    await duel_manager.get_tree().create_timer(0.25).timeout
    return true

func _force_play_random_magic() -> void :


    var best_idx = -1
    for i in range(enemy_hand.size()):
        if enemy_hand[i] and (enemy_hand[i].type == "Magic" or enemy_hand[i].type == "Trap" or enemy_hand[i].type == "Equip"):
            best_idx = i
            break

    if best_idx != -1:
        var card = enemy_hand[best_idx]
        var slot = await duel_manager._get_free_spell_slot(false, true)
        if slot:
            print("IA: Forçando carta face-down no field: ", card.name)

            enemy_hand[best_idx] = null
            duel_manager.update_enemy_hand_ui()
            await duel_manager.spawn_card_on_field(card, slot, true, false, false, false)

func _choose_enemy_slot_with_flags(best_card: CardData, can_fusion: bool, highest_player_atk: int, was_fusion: bool, visual_fusion_frame: bool, is_defense: bool, is_face_down: bool) -> Dictionary:
    var chosen_slot = null


    if can_fusion and not was_fusion:
        var field_fusion = _try_field_fusion(best_card)
        if field_fusion and not field_fusion.is_empty():

            chosen_slot = field_fusion.slot
            best_card = field_fusion.card
            was_fusion = true
            visual_fusion_frame = true

            if best_card.atk > highest_player_atk:
                is_defense = false
                is_face_down = false

            return {
                "slot": chosen_slot, 
                "card": best_card, 
                "was_fusion": was_fusion, 
                "visual_fusion_frame": visual_fusion_frame, 
                "is_defense": is_defense, 
                "is_face_down": is_face_down
            }


    for i in range(enemy_slots.size() - 1, -1, -1):
        if not enemy_slots[i].is_occupied:
            chosen_slot = enemy_slots[i]
            break


    if not chosen_slot:
        var lowest_stat = 99999
        var weak_idx = 0

        for i in range(enemy_slots.size()):
            var c = enemy_slots[i].stored_card_data
            if c.atk < lowest_stat:
                lowest_stat = c.atk
                weak_idx = i

        chosen_slot = enemy_slots[weak_idx]

        was_fusion = false
        visual_fusion_frame = false

    return {
        "slot": chosen_slot, 
        "was_fusion": was_fusion, 
        "visual_fusion_frame": visual_fusion_frame, 
        "is_defense": is_defense, 
        "is_face_down": is_face_down
    }


func _try_hand_fusion(can_use_exodia: bool) -> Dictionary:

    var axe_index = -1
    var best_monster_for_axe = null
    var best_monster_atk = -1
    var best_monster_index = -1


    for i in range(enemy_hand.size()):
        if enemy_hand[i] and enemy_hand[i].id == EQUIP_AXE_OF_DESPAIR:
            axe_index = i
            break


    if axe_index != -1:
        for i in range(enemy_hand.size()):
            if i == axe_index: continue
            var card = enemy_hand[i]
            if card and duel_manager._is_monster(card) and card.atk > best_monster_atk:
                best_monster_atk = card.atk
                best_monster_for_axe = card
                best_monster_index = i


        if best_monster_for_axe:
            var fused_monster = _try_equip_as_fusion(best_monster_for_axe, enemy_hand[axe_index])
            return {
                "card": fused_monster, 
                "indices": [axe_index, best_monster_index], 
                "was_fusion": true, 
                "visual_frame": false
            }


    var megamorph_index = -1
    var best_monster_for_megamorph = null
    var best_monster_mega_atk = -1
    var best_monster_mega_index = -1


    for i in range(enemy_hand.size()):
        if enemy_hand[i] and enemy_hand[i].id == EQUIP_MEGAMORPH:
            megamorph_index = i
            break


    if megamorph_index != -1:
        for i in range(enemy_hand.size()):
            if i == megamorph_index: continue
            var card = enemy_hand[i]
            if card and duel_manager._is_monster(card) and card.atk > best_monster_mega_atk:
                best_monster_mega_atk = card.atk
                best_monster_for_megamorph = card
                best_monster_mega_index = i


        if best_monster_for_megamorph:
            var fused_monster = _try_equip_as_fusion(best_monster_for_megamorph, enemy_hand[megamorph_index])
            return {
                "card": fused_monster, 
                "indices": [megamorph_index, best_monster_mega_index], 
                "was_fusion": true, 
                "visual_frame": false
            }


    var metalmorph_index = -1
    var best_monster_for_metalmorph = null
    var best_monster_metal_atk = -1
    var best_monster_metal_index = -1


    for i in range(enemy_hand.size()):
        if enemy_hand[i] and enemy_hand[i].id == EQUIP_METALMORPH:
            metalmorph_index = i
            break


    if metalmorph_index != -1:
        for i in range(enemy_hand.size()):
            if i == metalmorph_index: continue
            var card = enemy_hand[i]
            if card and duel_manager._is_monster(card) and card.atk > best_monster_metal_atk:
                best_monster_metal_atk = card.atk
                best_monster_for_metalmorph = card
                best_monster_metal_index = i


        if best_monster_for_metalmorph:
            var fused_monster = _try_equip_as_fusion(best_monster_for_metalmorph, enemy_hand[metalmorph_index])
            return {
                "card": fused_monster, 
                "indices": [metalmorph_index, best_monster_metal_index], 
                "was_fusion": true, 
                "visual_frame": false
            }

    var best_pure_fusion = {}

    for i in range(enemy_hand.size()):
        if not enemy_hand[i] or ( not can_use_exodia and enemy_hand[i].id in EXODIA_IDS):
            continue

        for j in range(i + 1, enemy_hand.size()):
            if not enemy_hand[j] or ( not can_use_exodia and enemy_hand[j].id in EXODIA_IDS):
                continue

            var current_best = {}
            var f1 = FusionDatabase.try_fusion([enemy_hand[i], enemy_hand[j]])

            if f1:

                if f1.atk >= enemy_hand[i].atk and f1.atk >= enemy_hand[j].atk:
                    var visual_frame = true
                    if f1.id == enemy_hand[i].id or f1.id == enemy_hand[j].id:
                        visual_frame = false

                    current_best = {
                        "card": f1, 
                        "indices": [i, j], 
                        "was_fusion": true, 
                        "visual_frame": visual_frame
                    }


                var difficulty = get_current_difficulty()
                var triple = _try_triple_fusion(f1, i, j, can_use_exodia)

                if triple:
                    current_best = triple
                    if difficulty in ["Medium", "Hard"]:
                        var quadruple = _try_quadruple_fusion(triple.card, triple.indices, can_use_exodia)
                        if quadruple:
                            current_best = quadruple
                            if difficulty == "Hard":
                                var quintuple = _try_quintuple_fusion(quadruple.card, quadruple.indices, can_use_exodia)
                                if quintuple:
                                    current_best = quintuple


            if not current_best.is_empty():
                if best_pure_fusion.is_empty() or current_best.card.atk > best_pure_fusion.card.atk:
                    best_pure_fusion = current_best






    if not best_pure_fusion.is_empty():

        var final_card = best_pure_fusion.card
        var final_indices = best_pure_fusion.indices

        for e in range(enemy_hand.size()):
            if e in final_indices: continue
            var potential_equip = enemy_hand[e]
            if potential_equip and potential_equip.type == "Equip":
                var buffed = _try_equip_as_fusion(final_card, potential_equip)
                if buffed:

                    print("IA: Acoplando Equipamento ", potential_equip.name, " ao final da sequência de fusão!")
                    best_pure_fusion.card = buffed
                    best_pure_fusion.indices.append(e)
                    best_pure_fusion.visual_frame = false
                    break

        return best_pure_fusion


    var equip_fallback = _try_equip_only(false)
    if not equip_fallback.is_empty():
        return equip_fallback

    return {}

func _try_equip_as_fusion(c1: CardData, c2: CardData):
    if duel_manager._is_monster(c1) and c2.type == "Equip" and duel_manager._is_valid_equip_target(c1, c2.id):
        var result = c1.get_copy()
        duel_manager._apply_equip_bonus(result, c2.id, false, true)
        return result
    elif c1.type == "Equip" and duel_manager._is_monster(c2) and duel_manager._is_valid_equip_target(c2, c1.id):
        var result = c2.get_copy()
        duel_manager._apply_equip_bonus(result, c1.id, false, true)
        return result
    return null


func _try_equip_only(can_use_exodia: bool) -> Dictionary:
    var best_result = {}
    var best_atk = -1

    for i in range(enemy_hand.size()):
        var card_i = enemy_hand[i]
        if not card_i: continue
        if not can_use_exodia and card_i.id in EXODIA_IDS: continue

        for j in range(i + 1, enemy_hand.size()):
            var card_j = enemy_hand[j]
            if not card_j: continue
            if not can_use_exodia and card_j.id in EXODIA_IDS: continue

            var eq = _try_equip_as_fusion(card_i, card_j)
            if eq and eq.atk > best_atk:
                best_atk = eq.atk
                best_result = {
                    "card": eq, 
                    "indices": [i, j], 
                    "was_fusion": true, 
                    "visual_frame": false
                }

    return best_result

func _try_triple_fusion(fusion_base: CardData, i_index: int, j_index: int, can_use_exodia: bool) -> Dictionary:
    for k in range(j_index + 1, enemy_hand.size()):
        if not enemy_hand[k] or ( not can_use_exodia and enemy_hand[k].id in EXODIA_IDS):
            continue

        var f2 = FusionDatabase.try_fusion([fusion_base, enemy_hand[k]])
        if f2 and f2.atk > fusion_base.atk:
            return {
                "card": f2, 
                "indices": [i_index, j_index, k], 
                "was_fusion": true, 
                "visual_frame": true
            }

    return {}

func _try_quadruple_fusion(fusion_base: CardData, base_indices: Array, can_use_exodia: bool) -> Dictionary:
    var last_index = base_indices[base_indices.size() - 1]
    for k in range(last_index + 1, enemy_hand.size()):
        if not enemy_hand[k] or ( not can_use_exodia and enemy_hand[k].id in EXODIA_IDS):
            continue
        if k in base_indices:
            continue

        var f3 = FusionDatabase.try_fusion([fusion_base, enemy_hand[k]])
        if f3 and f3.atk > fusion_base.atk:
            var new_indices = base_indices.duplicate()
            new_indices.append(k)
            return {
                "card": f3, 
                "indices": new_indices, 
                "was_fusion": true, 
                "visual_frame": true
            }

    return {}

func _try_quintuple_fusion(fusion_base: CardData, base_indices: Array, can_use_exodia: bool) -> Dictionary:
    var last_index = base_indices[base_indices.size() - 1]
    for k in range(last_index + 1, enemy_hand.size()):
        if not enemy_hand[k] or ( not can_use_exodia and enemy_hand[k].id in EXODIA_IDS):
            continue
        if k in base_indices:
            continue

        var f4 = FusionDatabase.try_fusion([fusion_base, enemy_hand[k]])
        if f4 and f4.atk > fusion_base.atk:
            var new_indices = base_indices.duplicate()
            new_indices.append(k)
            return {
                "card": f4, 
                "indices": new_indices, 
                "was_fusion": true, 
                "visual_frame": true
            }

    return {}


func _can_use_exodia_pieces() -> bool:
    var other_monsters_count = 0
    for card in enemy_hand:
        if card and not card.id in EXODIA_IDS and duel_manager._is_monster(card):
            other_monsters_count += 1
    return other_monsters_count == 0

func _get_effective_hand_stats(card: CardData) -> Dictionary:
    var eff_atk = card.atk
    var eff_def = card.def

    if card.id == 803:
        var count = 0
        for g_card in duel_manager.enemy_graveyard:
            if g_card.id == 803 or g_card.id == 24:
                count += 1
        if count >= 1:
            eff_atk = count * 1000
    elif card.id == 801:
        var count = 0
        for g_card in duel_manager.enemy_graveyard:
            if duel_manager._is_monster(g_card):
                count += 1
        if count >= 1:
            eff_atk = count * 300
    elif card.id == 775:
        var count = 0
        for g_card in duel_manager.enemy_graveyard:
            if g_card.type == "Rock":
                count += 1
        if count >= 1:
            eff_atk = count * 700
            eff_def = count * 700

    return {"atk": eff_atk, "def": eff_def}

func _get_best_hand_monster(can_use_exodia: bool) -> Dictionary:
    var highest_atk = -1
    var best_idx = -1

    for i in range(enemy_hand.size()):
        var card = enemy_hand[i]
        if not card or ( not can_use_exodia and card.id in EXODIA_IDS):
            continue


        if not duel_manager._is_monster(card):
            continue

        var eff_atk = _get_effective_hand_stats(card).atk
        if eff_atk > highest_atk:
            highest_atk = eff_atk
            best_idx = i

    if best_idx != -1:
        return {"card": enemy_hand[best_idx], "index": best_idx}

    return {}

func _get_best_def_monster(can_use_exodia: bool) -> Dictionary:
    var best_def_val = -1
    var best_def_idx = -1

    for i in range(enemy_hand.size()):
        var c = enemy_hand[i]
        if not c or ( not can_use_exodia and c.id in EXODIA_IDS):
            continue

        var eff_def = _get_effective_hand_stats(c).def
        if eff_def > best_def_val:
            best_def_val = eff_def
            best_def_idx = i

    if best_def_idx != -1:
        return {"card": enemy_hand[best_def_idx], "index": best_def_idx}

    return {}

func _get_highest_player_atk() -> int:
    var highest = 0
    for p_slot in player_slots:
        if p_slot.is_occupied and p_slot.stored_card_data.atk > highest:
            highest = p_slot.stored_card_data.atk
    return highest

func _has_any_monster_on_field() -> bool:
    for slot in enemy_slots:
        if slot.is_occupied:
            return true
    return false

func _get_player_slot_highest_atk() -> Node:
    var highest = -1
    var target_slot = null

    for p_slot in player_slots:
        if p_slot.is_occupied:
            var atk = p_slot.stored_card_data.atk
            if atk > highest:
                highest = atk
                target_slot = p_slot
    return target_slot


func _choose_enemy_slot(best_card: CardData, can_fusion: bool, highest_player_atk: int, was_fusion: bool, visual_fusion_frame: bool, is_defense: bool, is_face_down: bool) -> Node:
    var chosen_slot = null


    if can_fusion and not was_fusion:
        var field_fusion = _try_field_fusion(best_card)
        if field_fusion and not field_fusion.is_empty():

            chosen_slot = field_fusion.slot
            best_card = field_fusion.card
            was_fusion = true
            visual_fusion_frame = true

            if best_card.atk > highest_player_atk:
                is_defense = false
                is_face_down = false



            return chosen_slot


    for i in range(enemy_slots.size() - 1, -1, -1):
        if not enemy_slots[i].is_occupied:
            chosen_slot = enemy_slots[i]
            break


    if not chosen_slot:
        var lowest_stat = 99999
        var weak_idx = 0

        for i in range(enemy_slots.size()):
            var c = enemy_slots[i].stored_card_data
            if c.atk < lowest_stat:
                lowest_stat = c.atk
                weak_idx = i

        chosen_slot = enemy_slots[weak_idx]

        was_fusion = false
        visual_fusion_frame = false

    return chosen_slot

func _try_field_fusion(hand_card: CardData) -> Dictionary:
    var best_fusion_card: CardData = null
    var target_slot_idx = -1
    var best_fusion_atk = -1

    for i in range(enemy_slots.size()):
        if not enemy_slots[i].is_occupied:
            continue

        var field_card = enemy_slots[i].stored_card_data
        var fusion_result = FusionDatabase.try_fusion([field_card, hand_card])

        if fusion_result and fusion_result.atk > best_fusion_atk and fusion_result.atk > field_card.atk:
            best_fusion_atk = fusion_result.atk
            best_fusion_card = fusion_result
            target_slot_idx = i

    if best_fusion_card:
        return {"card": best_fusion_card, "slot": enemy_slots[target_slot_idx]}

    return {}


func _perform_battle_phase() -> void :
    print("Iniciando fase de batalha da IA")
    if EffectManager.swords_of_revealing_light_active and EffectManager.swords_of_revealing_light_owner_is_player:
        print("IA: Não pode atacar! Jogador ativou Swords of Revealing Light")
        return


    var attacked_this_turn = []


    var highest_player_atk = _get_highest_player_atk()
    print("IA: Maior ATK do jogador identificado: ", highest_player_atk)


    var attack_round = 0

    while attack_round < 5:
        attack_round += 1
        print("IA: Rodada de ataque ", attack_round)


        highest_player_atk = _get_highest_player_atk()


        var available_attackers = []

        for i in range(enemy_slots.size()):
            var e_slot = enemy_slots[i]
            if not e_slot.is_occupied:
                continue


            if e_slot in attacked_this_turn:
                continue

            var my_card = e_slot.stored_card_data
            var my_visual = e_slot.spawn_point.get_child(0)

            if not my_visual:
                continue

            if my_card.id == 551:
                if duel_manager.enemy_lp < 5000:
                    print("  -> Dark Elf ignorada: LP da IA baixo (", duel_manager.enemy_lp, " < 5000)")
                    continue


            var can_attack = false
            var needs_position_change = false


            if my_visual.rotation_degrees == 180:
                can_attack = true


            elif my_visual.rotation_degrees == -90 or duel_manager._has_card_back(my_visual):

                var player_still_has_monsters = false
                for p_slot in player_slots:
                    if p_slot.is_occupied:
                        player_still_has_monsters = true
                        break

                if not player_still_has_monsters and my_card.atk > 0:

                    can_attack = true
                    needs_position_change = true
                else:

                    var attack_analysis = _analyze_attack_potential(my_card, e_slot)
                    if attack_analysis.should_attack:
                        can_attack = true
                        needs_position_change = true

            if can_attack:
                var my_priority = _calculate_attacker_priority(my_card)



                if my_card.id == 399:
                    var target_slot = _get_player_slot_highest_atk()
                    if target_slot:
                        var target_card = target_slot.stored_card_data


                        var damage_to_take = 0
                        var target_visual = target_slot.spawn_point.get_child(0)

                        var is_target_attack_pos = false
                        if target_visual:
                             if target_visual.has_method("is_face_down"):
                                 is_target_attack_pos = not target_visual.is_face_down() and (target_visual.rotation_degrees == 0 or target_visual.rotation_degrees == 180)
                             else:
                                 is_target_attack_pos = (target_visual.rotation_degrees == 0 or target_visual.rotation_degrees == 180)

                        if is_target_attack_pos:
                            if target_card.atk > my_card.atk:
                                damage_to_take = target_card.atk - my_card.atk


                        if (duel_manager.enemy_lp - damage_to_take) >= 1000:
                            print("IA: Man-Eater Bug (399) detectado! Atacando monstro mais forte (Kamikaze seguro)")
                            my_priority = 999999
                            needs_position_change = true


                available_attackers.append({
                    "slot": e_slot, 
                    "card": my_card, 
                    "visual": my_visual, 
                    "needs_position_change": needs_position_change, 
                    "priority": _calculate_attacker_priority(my_card), 
                    "index": i
                })


        if available_attackers.size() == 0:
            print("IA: Nenhum atacante disponível na rodada ", attack_round)
            break


        available_attackers.sort_custom( func(a, b): return a.priority < b.priority)

        print("IA: Atacantes disponíveis nesta rodada: ", available_attackers.size())
        for attacker in available_attackers:
            print("  - ", attacker.card.name, " ATK:", attacker.card.atk, " Prioridade:", attacker.priority)


        var best_attacker = available_attackers[0]
        var e_slot = best_attacker.slot
        var my_card = best_attacker.card
        var my_visual = best_attacker.visual


        var direct_attacker = null

        for attacker in available_attackers:
            if attacker.card.id in duel_manager.DIRECT_ATTACK_MONSTER_IDS:
                direct_attacker = attacker
                break


        if direct_attacker:
            print("IA: Monstro de ataque direto encontrado (", direct_attacker.card.name, ")! Usando ataque direto...")

            var da_slot = direct_attacker.slot
            var da_visual = da_slot.spawn_point.get_child(0)

            if da_visual and da_visual.rotation_degrees != 180:

                var was_face_down = duel_manager._has_card_back(da_visual) if duel_manager.has_method("_has_card_back") else false
                duel_manager.reveal_enemy_card_in_slot(da_slot)
                if was_face_down and da_slot.stored_card_data:
                    EventBus.monster_summoned.emit(da_slot, da_slot.stored_card_data, false)



                var tween = duel_manager.create_tween()
                tween.set_trans(Tween.TRANS_QUAD)
                tween.set_ease(Tween.EASE_OUT)
                tween.tween_property(da_visual, "rotation_degrees", -180, 0.2)
                tween.finished.connect( func(): da_visual.rotation_degrees = 180)
                duel_manager._play_cardrotation_sound()

                await duel_manager.get_tree().create_timer(0.3).timeout


            await duel_manager.execute_battle(da_slot, null)

            if duel_manager.game_over:
                print("IA: Jogo acabou após ataque direto, interrompendo.")
                break


            if not da_slot.is_occupied or not is_instance_valid(da_visual):
                print("IA: Atacante destruído após ataque direto.")
            else:
                attacked_this_turn.append(da_slot)


            if EffectManager.can_monster_attack_again(da_slot, direct_attacker.card):
                print("  -> ", direct_attacker.card.name, " pode atacar novamente!")
                attacked_this_turn.erase(da_slot)

            continue

        print("IA: Melhor atacante desta rodada: ", my_card.name, " (Slot: ", best_attacker.index, ")")


        if best_attacker.needs_position_change:
            print("  -> Mudando de defesa para ataque")
            var was_face_down = duel_manager._has_card_back(my_visual) if duel_manager.has_method("_has_card_back") else false
            duel_manager.reveal_enemy_card_in_slot(e_slot)
            if was_face_down and my_card:
                EventBus.monster_summoned.emit(e_slot, my_card, false)

            var tween = duel_manager.create_tween()
            tween.set_trans(Tween.TRANS_QUAD)
            tween.set_ease(Tween.EASE_OUT)
            tween.tween_property(my_visual, "rotation_degrees", -180, 0.2)
            tween.finished.connect( func(): my_visual.rotation_degrees = 180)
            duel_manager._play_cardrotation_sound()

            await duel_manager.get_tree().create_timer(0.3).timeout


        var best_target = null
        var best_priority = -9999


        if my_card.id == 399 and best_attacker.priority >= 999999:
             var target_slot = _get_player_slot_highest_atk()
             if target_slot:
                 best_target = target_slot
                 best_priority = 9999999
                 print("IA: Man-Eater Bug travando mira no monstro mais forte: ", target_slot.stored_card_data.name)




        var player_has_monsters = false


        for p_slot in player_slots:
            if p_slot.is_occupied:
                player_has_monsters = true
                var p_card = p_slot.stored_card_data


                if p_card.id == KURIBOH_ID:
                    var p_visual = p_slot.spawn_point.get_child(0)
                    var is_kuriboh_face_up = true
                    if p_visual.has_method("is_face_down"):
                        is_kuriboh_face_up = not p_visual.is_face_down
                    else:
                        is_kuriboh_face_up = (p_visual.rotation_degrees == 0 or p_visual.rotation_degrees == 180)

                    if is_kuriboh_face_up:
                        print("IA: Kuriboh encontrado!")
                        var kuriboh_is_defense = (p_visual.rotation_degrees != 0 and p_visual.rotation_degrees != 180)
                        var my_final_atk = _get_ai_effective_atk(my_card, p_card)

                        if kuriboh_is_defense:
                            var kuriboh_def = duel_manager.get_effective_def(p_card, my_card)
                            if my_final_atk > kuriboh_def:
                                var priority = 99999 + (my_final_atk - kuriboh_def)
                                if priority > best_priority:
                                    best_priority = priority
                                    best_target = p_slot
                            else:
                                print("  -> Não posso destruir Kuriboh em defesa")
                                continue
                        else:
                            var kuriboh_atk = duel_manager.get_effective_atk(p_card, my_card)
                            if my_final_atk > kuriboh_atk:
                                var priority = 99999 + (my_final_atk - kuriboh_atk)
                                if priority > best_priority:
                                    best_priority = priority
                                    best_target = p_slot
                            else:
                                print("  -> Não posso destruir Kuriboh em ataque")
                                continue


                var priority = _calculate_target_priority(my_card, p_slot)
                if priority > best_priority:
                    best_priority = priority
                    best_target = p_slot


        if best_target and best_priority > 0:

            if not best_target.is_occupied or not best_target.stored_card_data:
                print("IA: Alvo desapareceu antes do ataque! Abortando rodada para este monstro.")
                attacked_this_turn.append(e_slot)
                continue

            print("IA: Atacando ", best_target.stored_card_data.name, " com ", my_card.name)
            await duel_manager.execute_battle(e_slot, best_target)


            print("IA DEBUG: Após execute_battle, is_processing_trap = ", duel_manager.get("is_processing_trap"), ", lock = ", duel_manager.get("additional_processing_lock"))


            var is_waiting = true
            var wait_count = 0
            while is_waiting and wait_count < 15:
                var trapped = duel_manager.is_processing_trap or duel_manager.additional_processing_lock > 0
                var effect_busy = duel_manager.get("_is_processing_action") == true
                var battle_busy = duel_manager.get("is_resolving_battle") == true

                if not (trapped or effect_busy or battle_busy):
                    is_waiting = false
                else:
                    print("IA DEBUG: Aguardando (trap:%s, effect:%s, battle:%s) - Tentativa %d" % [trapped, effect_busy, battle_busy, wait_count])
                    await duel_manager.get_tree().create_timer(0.4).timeout
                    wait_count += 1


            await duel_manager.get_tree().process_frame
            await duel_manager.get_tree().process_frame

            print("IA DEBUG: Campo estabilizado após ataque.")


            if not e_slot.is_occupied or not is_instance_valid(my_visual):
                print("IA: Atacante foi destruído durante a resolução da batalha ou traps.")
                continue

            if duel_manager.game_over:
                print("IA: Jogo acabou após ataque, interrompendo.")
                break

            attacked_this_turn.append(e_slot)
            await duel_manager.get_tree().create_timer(0.5).timeout


            if EffectManager.can_monster_attack_again(e_slot, my_card):
                print("  -> ", my_card.name, " pode atacar novamente! Removendo da lista de atacados.")
                attacked_this_turn.erase(e_slot)

            else:
                print("  -> ", my_card.name, " atacou e não atacará mais neste turno")


            var still_has_monsters = false
            for p_slot in player_slots:
                if p_slot.is_occupied:
                    still_has_monsters = true
                    break

            if not still_has_monsters:
                print("IA: Todos monstros destruídos!")


                continue


        elif not player_has_monsters:
            if my_visual.rotation_degrees != 180:
                print("  -> Mudando de defesa para ataque direto")
                var was_face_down = duel_manager._has_card_back(my_visual) if duel_manager.has_method("_has_card_back") else false
                duel_manager.reveal_enemy_card_in_slot(e_slot)
                if was_face_down and my_card:
                    EventBus.monster_summoned.emit(e_slot, my_card, false)

                var tween = duel_manager.create_tween()
                tween.set_trans(Tween.TRANS_QUAD)
                tween.set_ease(Tween.EASE_OUT)
                tween.tween_property(my_visual, "rotation_degrees", -180, 0.2)
                tween.finished.connect( func(): my_visual.rotation_degrees = 180)
                duel_manager._play_cardrotation_sound()
                await duel_manager.get_tree().create_timer(0.3).timeout

            print("IA: Ataque direto com ", my_card.name)
            await duel_manager.execute_battle(e_slot, null)


            print("IA DEBUG: Após ataque direto, is_processing_trap = ", duel_manager.get("is_processing_trap"), ", lock = ", duel_manager.get("additional_processing_lock"))

            var is_waiting = true
            var wait_count = 0
            while is_waiting and wait_count < 15:
                var trapped = duel_manager.is_processing_trap or duel_manager.additional_processing_lock > 0
                var effect_busy = duel_manager.get("_is_processing_action") == true
                var battle_busy = duel_manager.get("is_resolving_battle") == true

                if not (trapped or effect_busy or battle_busy):
                    is_waiting = false
                else:
                    print("IA DEBUG: Aguardando ataque direto (trap:%s, effect:%s, battle:%s) - Tentativa %d" % [trapped, effect_busy, battle_busy, wait_count])
                    await duel_manager.get_tree().create_timer(0.4).timeout
                    wait_count += 1

            await duel_manager.get_tree().process_frame
            print("IA DEBUG: Campo estabilizado após ataque direto.")


            if not e_slot.is_occupied or not is_instance_valid(my_visual):
                print("IA: Atacante destruído após ataque direto.")
                continue

            if duel_manager.game_over:
                print("IA: Jogo acabou após ataque direto, interrompendo.")
                break

            attacked_this_turn.append(e_slot)
            await duel_manager.get_tree().create_timer(0.5).timeout
            print("  -> ", my_card.name, " fez ataque direto")


            if EffectManager.can_monster_attack_again(e_slot, my_card):
                print("  -> ", my_card.name, " (Multi-Attack) pode atacar diretamente novamente! Removendo da lista de atacados.")
                attacked_this_turn.erase(e_slot)


        else:
            print("IA: ", my_card.name, " não encontrou alvo bom, marcando como 'não atacará'")

            attacked_this_turn.append(e_slot)


            if is_instance_valid(my_visual) and my_visual.rotation_degrees == 180 and best_priority <= 0:

                var is_def_better = my_card.def > my_card.atk


                var current_highest_p_atk = 0
                for p_slot in player_slots:
                    if p_slot.is_occupied:
                        var p_eff_atk = duel_manager.get_effective_atk(p_slot.stored_card_data, my_card)
                        if p_eff_atk > current_highest_p_atk: current_highest_p_atk = p_eff_atk

                var defense_is_weak = (current_highest_p_atk > 0 and my_card.def < current_highest_p_atk and my_card.atk >= current_highest_p_atk)

                if not defense_is_weak and (is_def_better or current_highest_p_atk > my_card.atk):
                    print("  -> Voltando para defesa (Evitar dano ou DEF melhor)")

                    var tween = duel_manager.create_tween()
                    tween.set_trans(Tween.TRANS_QUAD)
                    tween.set_ease(Tween.EASE_OUT)
                    tween.tween_property(my_visual, "rotation_degrees", 270, 0.2)
                    tween.finished.connect( func(): my_visual.rotation_degrees = -90)
                    duel_manager._play_cardrotation_sound()

                    await duel_manager.get_tree().create_timer(0.3).timeout
                else:
                    if defense_is_weak:
                        print("  -> Mantendo em ataque! Defesa (", my_card.def, ") é muito fraca contra adversário (", current_highest_p_atk, ").")


    print("IA: Ajustando posição defensiva...")
    for i in range(enemy_slots.size()):
        var e_slot = enemy_slots[i]
        if not e_slot.is_occupied:
            continue


        if e_slot in attacked_this_turn:
            continue

        var my_card = e_slot.stored_card_data
        var my_visual = e_slot.spawn_point.get_child(0)

        if not my_visual:
            continue


        var can_be_destroyed = false
        for p_slot in player_slots:
            if p_slot.is_occupied:
                var p_card = p_slot.stored_card_data

                var player_effective_atk = duel_manager.get_effective_atk(p_card, my_card)
                if player_effective_atk > my_card.atk:
                    can_be_destroyed = true
                    break

        if can_be_destroyed:
            if my_visual.rotation_degrees == 180:
                print("IA: Colocando ", my_card.name, " em defesa (jogador pode destruir com guardian star)")

                var tween = duel_manager.create_tween()
                tween.set_trans(Tween.TRANS_QUAD)
                tween.set_ease(Tween.EASE_OUT)
                tween.tween_property(my_visual, "rotation_degrees", 270, 0.2)
                tween.finished.connect( func(): my_visual.rotation_degrees = -90)
                duel_manager._play_cardrotation_sound()

                await duel_manager.get_tree().create_timer(0.5).timeout

    print("Fase de batalha concluída. Total de cartas que atacaram: ", attacked_this_turn.size())

func _analyze_attack_potential(my_card: CardData, my_slot) -> Dictionary:
    var best_priority = -9999
    var should_attack = false
    var reason = ""


    for p_slot in player_slots:
        if not p_slot.is_occupied:
            continue

        var priority = _calculate_target_priority(my_card, p_slot)

        if priority > best_priority:
            best_priority = priority


    if best_priority > 1000:
        should_attack = true
        reason = "Alvo fácil de destruir"
    elif best_priority == 800:
        if randf() <= 0.25:
            should_attack = true
            reason = "Kamikaze (25% chance)"
        else:

            should_attack = false
            reason = "Evitou kamikaze"
    elif best_priority > 500:
        should_attack = true
        reason = "Vantagem clara"
    elif best_priority > 100 and my_card.atk > my_card.def:
        should_attack = true
        reason = "ATK melhor que DEF"
    elif best_priority > 0 and randf() < 0.5:
        should_attack = true
        reason = "Oportunidade razoável"
    else:
        should_attack = false
        reason = "Melhor manter defesa"


    if not should_attack:
        var highest_player_atk = 0
        for p_slot in player_slots:
            if p_slot.is_occupied:
                var p_card = p_slot.stored_card_data
                var p_eff_atk = duel_manager.get_effective_atk(p_card, my_card)
                if p_eff_atk > highest_player_atk:
                    highest_player_atk = p_eff_atk

        if highest_player_atk > 0 and my_card.def < highest_player_atk and my_card.atk >= highest_player_atk:

            should_attack = true
            reason = "Defesa muito fraca, assumindo postura de ataque"


    var player_has_monsters = false
    for p_slot in player_slots:
        if p_slot.is_occupied:
            player_has_monsters = true
            break

    if not player_has_monsters and my_card.atk > 0:
        should_attack = true
        reason = "Ataque direto possível"


    if my_card.id in duel_manager.DIRECT_ATTACK_MONSTER_IDS:
        should_attack = true
        reason = "Habilidade de Ataque Direto"

    return {"should_attack": should_attack, "reason": reason, "priority": best_priority}

func _calculate_attacker_priority(card: CardData) -> int:

    var priority = card.atk


    if card.atk > 1500:
        priority += 1000
    elif card.atk > 1000:
        priority += 500


    if card.atk < 1000:
        priority -= 300

    return priority

func _calculate_target_priority(attacker: CardData, target_slot) -> int:
    var p_card = target_slot.stored_card_data
    var p_visual = target_slot.spawn_point.get_child(0)


    if not p_card or not p_visual:
        return -9999


    if p_card.id == KURIBOH_ID:

        var is_kuriboh_face_up = true
        if p_visual.has_method("is_face_down"):
            is_kuriboh_face_up = not p_visual.is_face_down
        else:

            is_kuriboh_face_up = (p_visual.rotation_degrees == 0 or p_visual.rotation_degrees == 180)

        if is_kuriboh_face_up:
            print("  -> Kuriboh virado para cima detectado na prioridade")
            var kuriboh_is_defense = (p_visual.rotation_degrees != 0 and p_visual.rotation_degrees != 180)
            var my_final_atk = _get_ai_effective_atk(attacker, p_card)

            if kuriboh_is_defense:
                var kuriboh_def = duel_manager.get_effective_def(p_card, attacker)
                if my_final_atk > kuriboh_def:

                    return 99999 + (my_final_atk - kuriboh_def)
                else:

                    return -99999
            else:
                var kuriboh_atk = duel_manager.get_effective_atk(p_card, attacker)
                if my_final_atk > kuriboh_atk:

                    return 99999 + (my_final_atk - kuriboh_atk)
                else:

                    return -99999



    if attacker.id == 410:
        if p_card.attribute.to_lower() == "dark":
            return 99999


    if attacker.id == 288:
        if p_card.attribute.to_lower() == "light":
            return 99999


    if attacker.id == 478:
        if p_card.attribute.to_lower() == "wind":
            return 99999


    if attacker.id == 399:
        return 99999


    var is_face_down = (p_visual.rotation_degrees != 0 and duel_manager._has_card_back(p_visual))

    if is_face_down:

        if randf() > 0.7:
            return -9999


        var my_atk = _get_ai_effective_atk(attacker, p_card)
        var blind_priority = 100 + my_atk

        if duel_manager.get_guardian_bonus(attacker, p_card) > 0:
            blind_priority += 500

        return blind_priority
    else:
        var p_is_defense = (p_visual.rotation_degrees != 0)
        var my_final_atk = _get_ai_effective_atk(attacker, p_card)

        var target_power = 0
        if p_is_defense:
            target_power = duel_manager.get_effective_def(p_card, attacker)
        else:
            target_power = duel_manager.get_effective_atk(p_card, attacker)

        if my_final_atk > target_power:
            var priority = 0
            if not p_is_defense:


                priority = 5000 + (my_final_atk - target_power)
            else:
                priority = 500 + p_card.atk

            return priority

    return -9999

func _calculate_hidden_target_priority(attacker: CardData) -> int:

    var base_priority = 500

    if attacker.atk > 2000:
        base_priority += 500
    if attacker.atk < 1500:
        base_priority -= 300

    return base_priority

func _calculate_visible_target_priority(attacker: CardData, target_card: CardData, target_visual) -> int:
    var my_final_atk = _get_ai_effective_atk(attacker, target_card)
    var target_is_defense = (target_visual.rotation_degrees != 0 and target_visual.rotation_degrees != 180)

    var target_power = 0
    if target_is_defense:
        target_power = duel_manager.get_effective_def(target_card, attacker)
    else:
        target_power = duel_manager.get_effective_atk(target_card, attacker)


    if my_final_atk > target_power:
        var priority = 0
        var diff = my_final_atk - target_power

        if not target_is_defense:

            priority = 5000 + (diff * 20)

            if target_power < 1000:
                priority += 1000
            elif target_power < 1500:
                priority += 500
        else:

            priority = 1000 + (diff * 10)


        if duel_manager.get_guardian_bonus(attacker, target_card) > 0:
            priority += 300

        return priority
    elif my_final_atk == target_power:
        if not target_is_defense:
            return 800
        else:
            return 400
    else:
        var danger_level = target_power - my_final_atk

        if not target_is_defense:
            return -2000 - (danger_level * 10)
        else:
            return -500 - danger_level

func _check_field_state() -> Dictionary:
    var state = {
        "player_monsters": 0, 
        "player_hidden": 0, 
        "enemy_attackers": 0
    }


    for p_slot in player_slots:
        if p_slot.is_occupied:
            state.player_monsters += 1
            var visual = p_slot.spawn_point.get_child(0)
            var is_face_down = (visual.rotation_degrees != 0 and duel_manager._has_card_back(visual))
            if is_face_down:
                state.player_hidden += 1


    for e_slot in enemy_slots:
        if e_slot.is_occupied:
            var visual = e_slot.spawn_point.get_child(0)
            if visual and visual.rotation_degrees == 180:
                state.enemy_attackers += 1

    return state

func _set_attack_mode(slot):
    var visual = slot.spawn_point.get_child(0)
    if visual.rotation_degrees != 180:
        visual.rotation_degrees = 180
        duel_manager.reveal_enemy_card_in_slot(slot)
        duel_manager._play_cardrotation_sound()


func _get_ai_effective_atk(attacker: CardData, target: CardData) -> int:
    var atk = duel_manager.get_effective_atk(attacker, target)


    if attacker.id == 367:
        atk += 100


    if attacker in duel_manager.metalmorph_equipped_monsters and target:
        var metalmorph_bonus = int(target.atk / 2.0)
        atk += metalmorph_bonus

    return atk
