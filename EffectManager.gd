extends Node


var duel_manager: Node = null
var effect_video_layer: CanvasLayer = null
var audio_player: AudioStreamPlayer = null


var _last_discard_time: int = 0
var _card_discard_delay_offset: float = 0.0


const LORD_OF_D_ID = 728
const EXODIA_IDS = [17, 18, 19, 20, 21]


const EFFECT_SPARKS = 343
const EFFECT_MOOYAN_CURRY = 338
const EFFECT_RAIGEKI = 337
const EFFECT_STOP_DEFENSE = 320
const EFFECT_DARK_HOLE = 336
const EFFECT_RED_MEDICINE = 339
const EFFECT_GOBLIN_REMEDY = 340
const EFFECT_SOUL_OF_THE_PURE = 341
const EFFECT_DIAN_KETO = 342
const EFFECT_HINOTAMA = 344
const EFFECT_FINAL_FLAME = 345
const EFFECT_OOKAZI = 346
const EFFECT_TREMENDOUS_FIRE = 347
const EFFECT_SWORDS_OF_REVEALING_LIGHT = 348
const EFFECT_DARK_PIERCING_LIGHT = 350
const WARLION_RITUAL_ID = 673
const COMMENCEMENT_DANCE_ID = 676
const HAMBURGER_RECIPE_ID = 677
const ZERA_RITUAL_ID = 671
const POLYMERIZATION_ID = 665
const BLACK_LUSTER_RITUAL_ID = 670
const BEASTLY_MIRROR_RITUAL_ID = 674
const REMOVE_TRAP_ID = 667
const REVIVAL_OF_DOKURORIDER_ID = 699
const NOVOX_PRAYER_ID = 679
const DE_SPELL_ID = 655
const EFFECT_FISSURE = 678
const EFFECT_POT_OF_GREED = 680
const EFFECT_GRAVEDIGGER_GHOUL = 691
const EFFECT_WARRIOR_ELIMINATION = 653
const EFFECT_ETERNAL_REST = 656
const EFFECT_ERADICATING_AEROSOL = 662
const EFFECT_BREATH_OF_LIGHT = 663
const EFFECT_ETERNAL_DRAUGHT = 664
const EFFECT_HARPIES_FEATHER_DUSTER = 672
const TURTLE_OATH_ID = 692
const EFFECT_MONSTER_REBORN = 693
const RESURECTION_OF_CHAKRA_ID = 694
const GARMA_SWORD_OATH_ID = 697
const CHANGE_OF_HEART_ID = 698
const FORTRESS_WHALE_OATH_ID = 700
const BLACK_MAGIC_RITUAL_ID = 721
const JAVELIN_BEETLE_PACT_ID = 696
const EFFECT_ANCIENT_TELESCOPE = 726
const EFFECT_FLUTE_OF_SUMMONING_DRAGON = 730
const EFFECT_CARD_DESTRUCTION = 732
const EFFECT_LAST_WILL = 733
const STERN_MYSTIC_ID = 734
const EFFECT_BLUE_MEDICINE = 737
const EFFECT_RAIMEI = 739
const EFFECT_SOUL_RELEASE = 746
const BARREL_DRAGON_ID = 747
const EFFECT_TRIBUTE_TO_THE_DOOMED = 748
const EFFECT_SHARE_THE_PAIN = 750
const EFFECT_SHIELD_AND_SWORD = 751
const EFFECT_HEAVY_STORM = 753
const EFFECT_UNION_ATTACK = 765
const SPHERE_KURIBOH_ID = 766
const EFFECT_ORDER_TO_CHARGE = 767
const EFFECT_INSECT_IMITATION = 791
const EFFECT_TWISTER = 804
const EFFECT_BOOK_OF_LIFE = 805
const BLOWBACK_DRAGON_DRAGON_ID = 793
const TWIN_BARREL_DRAGON_ID = 794
const HEAVY_MECH_SUPPORT_PLATFORM_ID = 795


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
const EQUIP_PHOTON_BOOSTER = 757
const EQUIP_SWORD_DEEP_SEATED = 752
const EQUIP_GRAVITY_AXE_GRARL = 777
const EQUIP_RARE_METALMORPH = 796


const EFFECT_FIELD_FOREST = 330
const EFFECT_WASTELAND = 331
const EFFECT_MOUNTAIN = 332
const EFFECT_SOGEN = 333
const EFFECT_UMI = 334
const EFFECT_YAMI = 335
const EFFECT_FIELD_GAIA_POWER = 745
const EFFECT_FIELD_SANCTUARY = 756
const EFFECT_FIELD_JURASSIC_WORLD = 776


const KURIBOH_ID = 58
const MUKA_MUKA_ID = 516
const JINZO_7_ID = 422
const ARMED_NINJA_ID = 469
const AMEBA_ID = 484
const MONSTER_EYE_ID = 402
const TIME_WIZARD_ID = 16
const GRIGGLE_ID = 547
const SANGAN_ID = 48
const MASK_OF_DARKNESS_ID = 102
const SWAMP_BATTLEGUARD_ID = 12
const LAVA_BATTLEGUARD_ID = 554
const DRAGON_PIPER_ID = 40
const CASTLE_OF_DARK_ILLUSIONS_ID = 83
const REAPER_OF_CARDS_ID = 84
const CATAPULT_TURTLE_ID = 89
const CRASS_CLOWN_ID = 95
const PUMPKING_THE_KING_OF_GHOSTS_ID = 99
const DREAM_CLOWN_ID = 120
const TAINTED_WISDOM_ID = 162
const MYSTERIOUS_PUPPETEER_ID = 166
const BIG_EYE_ID = 171
const PENGUIN_KNIGHT_ID = 199
const TRAP_MASTER_ID = 224
const WODAN_THE_RESIDENT_OF_THE_FOREST_ID = 235
const PRINCESS_OF_TSURUGI_ID = 266
const SHADOW_GHOUL_ID = 368
const SHADOW_WALL_ID = 369
const CANNON_SOLDIER_ID = 512
const SANGA_OF_THE_THUNDER_ID = 371
const KAZEIJIN_ID = 372
const SUIJIN_ID = 373
const GATE_GUARDIAN_ID = 374
const BLUE_EYES_TWIN_BURST_DRAGON_ID = 675
const SINISTER_SERPENT_ID = 475
const MILUS_RADIANT_ID = 527
const PATROL_ROBO_ID = 580
const HOURGLASS_OF_COURAGE_ID = 616
const HOURGLASS_OF_LIFE_ID = 229
const THE_IMMORTAL_OF_THUNDER_ID = 462
const INVADER_OF_THE_THRONE_ID = 641
const THUNDER_DRAGON_ID = 425
const HARPIES_PET_DRAGON_ID = 386
const HARPIE_LADY_ID = 62
const COCKROACH_KNIGHT_ID = 479
const MAGICIAN_OF_FAITH_ID = 428
const BLAST_JUGGLER_ID = 417
const DARK_ELF_ID = 551
const CYBER_STEIN_ID = 420
const GODDESS_OF_WHIM_ID = 429
const ELECTRIC_SNAKE_ID = 463
const INSECT_SOLDIERS_OF_THE_SKY_ID = 478
const MAHA_VAILO_ID = 493
const YADO_KARU_ID = 497
const DRAGON_SEEKER_ID = 500
const GALE_DOGRA_ID = 506
const SKELENGEL_ID = 540
const MUSHROOM_MAN_2_ID = 553
const NEEDLE_WORM_ID = 562
const WITCH_OF_THE_BLACK_FOREST_ID = 574
const WEATHER_REPORT_ID = 583
const GREENKAPPA_ID = 586
const MORPHING_JAR_ID = 591
const PENGUIN_SOLDIER_ID = 602
const BLADEFLY_ID = 609
const ELECTRIC_LIZARD_ID = 610
const STEEL_SCORPION_ID = 394
const MACHINE_KING_ID = 407
const WITCHS_APPRENTICE_ID = 628
const HIROS_SHADOW_SCOUT_ID = 611
const LITTLE_CHIMERA_ID = 598
const STAR_BOY_ID = 524
const HOSHININGEN_ID = 492
const NEEDLE_BALL_ID = 490
const MINAR_ID = 534
const BLUE_EYES_STARLORD_DRAGON_ID = 99999
const NIMBLE_MOMONGA_ID = 743
const HARVEST_ANGEL_ID = 759
const MELTIEL_ID = 760
const ZERADIAS_ID = 761
const BOUNTIFUL_ARTEMIS_ID = 762
const DARK_MAGICIAN_GIRL_ID = 763
const GUARDIAN_SPHINX_ID = 768
const ROCK_SPIRIT_ID = 769
const GUARDIAN_STATUE_ID = 774
const MEGAROCK_DRAGON_ID = 775
const BLACK_BRACHIOS_ID = 780
const DESTROYERSAURUS_ID = 781
const BLACK_PTERA_ID = 783
const SUPER_ANCIENT_DINOBEAST_ID = 784
const BEETRON_ID = 786
const BLAZEWING_BUTTERFLY_ID = 787
const KISETAI_ID = 789
const SKULL_MARK_LADYBUG_ID = 790
const SAMURAI_SKULL_ID = 798
const GOZUKI_ID = 799
const ZOMBIE_MASTER_ID = 800
const CHAOS_NECROMANCER_ID = 801
const KING_OF_THE_SKULL_SERVANTS_ID = 803
const SKULL_SERVANT_ID = 24


const SPARKS_DAMAGE = 200
const MOOYAN_CURRY_HEAL = 200
const DARK_ENERGY_BONUS = 300
const LEGENDARY_SWORD_BONUS = 300
const DARK_DESTRUCTION_ATK_BONUS = 400
const DARK_DESTRUCTION_DEF_PENALTY = -200
const AXE_OF_DESPAIR_BONUS = 1000
const LASER_CANNON_ARMOR_BONUS = 300
const INSECT_ARMOR_LASER_CANNON_BONUS = 700
const ELFS_LIGHT_ATK_BONUS = 400
const ELFS_LIGHT_DEF_PENALTY = -200
const BEAST_FANGS_BONUS = 300
const STEEL_SHELL_ATK_BONUS = 400
const STEEL_SHELL_DEF_PENALTY = -200
const VILE_GERMS_BONUS = 300
const BLACK_PENDANT_ATK_BONUS = 500
const BLACK_PENDANT_DESTRUCTION_DAMAGE = 500
const SILVER_BOW_ARROW_BONUS = 300
const HORN_OF_LIGHT_DEF_BONUS = 800
const HORN_OF_THE_UNICORN_BONUS = 700
const DRAGON_TREASURE_BONUS = 300
const ELECTRO_WHIP_BONUS = 300
const CYBER_SHIELD_ATK_BONUS = 500
const MYSTICAL_MOON_BONUS = 300
const MALEVOLENT_NUZZLER_BONUS = 700
const VIOLET_CRYSTAL_BONUS = 300
const BOOK_OF_SECRET_ARTS_BONUS = 300
const INVIGORATION_ATK_BONUS = 400
const INVIGORATION_DEF_PENALTY = -200
const MACHINE_CONVERSION_FACTORY_BONUS = 300
const RAISE_BODY_HEAT_BONUS = 300
const FOLLOW_WIND_BONUS = 300
const POWER_OF_KAISHIN_BONUS = 300
const FOREST_BONUS = 200
const WASTELAND_BONUS = 200
const MOUNTAIN_BONUS = 200
const SOGEN_BONUS = 200
const UMI_BONUS = 200
const UMI_PENALTY = -200
const YAMI_BONUS = 200
const YAMI_PENALTY = -200
const RED_MEDICINE_HEAL = 500
const GOBLIN_REMEDY_HEAL = 600
const SOUL_OF_THE_PURE_HEAL = 800
const DIAN_KETO_HEAL = 1000
const HINOTAMA_DAMAGE = 500
const FINAL_FLAME_DAMAGE = 600
const OOKAZI_DAMAGE = 800
const TREMENDOUS_FIRE_DAMAGE = 1000
const TREMENDOUS_FIRE_PENALTY_DAMAGE = 500
const MUKA_MUKA_BONUS_PER_CARD = 200
const AMEBA_DAMAGE = 1000
const MONSTER_EYE_DAMAGE = 500
const GRIGGLE_HEAL = 500
const SANGAN_BONUS_PER_WEAK_MONSTER = 100
const MASK_BONUS_PER_FIEND = 100
const SWAMP_LAVA_BONUS = 500
const CASTLE_OF_DARKNESS_ZOMBIE_BONUS = 500
const CATAPULT_TURTLE_DAMAGE = 500
const CRASS_CLOWN_MAX_ATK = 1000
const DREAM_CLOWN_MAX_ATK = 1000
const PUMPKING_ZOMBIE_BONUS = 200
const MYSTERIOUS_PUPPETEER_HEAL_PER_MONSTER = 500
const WODAN_PLANT_BONUS = 100
const PRINCESS_OF_TSURUGI_DAMAGE = 500
const SHADOW_GHOUL_BONUS = 100
const SHADOW_WALL_BONUS = 100
const CANNON_SOLDIER_DAMAGE = 500
const GATE_GUARDIAN_FULL_BONUS = 500
const SINISTER_SERPENT_BONUS_PER_COPY = 100
const MILUS_RADIANT_EARTH_BONUS = 500
const MILUS_RADIANT_WIND_PENALTY = -400
const BLAST_JUGGLER_MAX_ATK = 1000
const BLAST_JUGGLER_MAX_TARGETS = 2
const DARK_ELF_LP_COST = 1000
const CYBER_STEIN_FUSION_BONUS = 200
const HIROS_SHADOW_SCOUT_MILL_COUNT = 3
const LITTLE_CHIMERA_FIRE_BONUS = 500
const LITTLE_CHIMERA_WATER_PENALTY = -400
const STAR_BOY_WATER_BONUS = 500
const STAR_BOY_FIRE_PENALTY = -400
const HOSHININGEN_LIGHT_BONUS = 500
const HOSHININGEN_DARK_PENALTY = -400
const SALAMANDRA_ATK_BONUS = 700
const NEEDLE_BALL_DAMAGE = 1000
const MINAR_DAMAGE = 1000
const BLUE_MEDICINE_HEAL = 400
const RAIMEI_DAMAGE = 300
const NIMBLE_MOMONGA_HEAL = 1000
const PHOTON_BOOSTER_ATK_BONUS = 2000
const JURASSIC_WORLD_BONUS = 300
const GRAVITY_AXE_GRARL_BONUS = 500
const KISETAI_HEAL = 1000
const SKULL_MARK_LADYBUG_DAMAGE = 1000
const CHAOS_NECROMANCER_ATK_PER_GRAVE_CARD = 300
const KING_OF_THE_SKULL_SERVANTS_ATK_PER_TARGET = 1000
const TWISTER_LP_COST = 500


const FOREST_BUFFED_TYPES = ["beast-warrior", "insect", "plant", "beast"]
const WASTELAND_BUFFED_TYPES = ["dinosaur", "zombie", "rock"]
const MOUNTAIN_BUFFED_TYPES = ["dragon", "winged-beast", "thunder"]
const SOGEN_BUFFED_TYPES = ["beast-warrior", "warrior"]
const UMI_BUFFED_TYPES = ["fish", "sea serpent", "thunder", "aqua"]
const UMI_DEBUFFED_TYPES = ["pyro", "machine"]
const YAMI_BUFFED_TYPES = ["fiend", "spellcaster"]
const YAMI_DEBUFFED_TYPES = ["fairy"]
const JURASSIC_WORLD_BUFFED_TYPES = ["dinosaur"]

const GAIA_POWER_BUFFED_ATTRIBUTES = ["earth"]
const SANCTUARY_BUFFED_ATTRIBUTES = ["light"]

const POWER_OF_KAISHIN_TYPES = ["aqua"]
const FOLLOW_WIND_TYPES = ["winged-beast"]
const RAISE_BODY_HEAT_TYPES = ["dinosaur"]
const MACHINE_CONVERSION_FACTORY_TYPES = ["machine"]
const LEGENDARY_SWORD_TYPES = ["warrior"]
const LASER_CANNON_ARMOR_TYPES = ["insect"]
const INSECT_ARMOR_LASER_CANNON_TYPES = ["insect"]
const BEAST_FANGS_TYPES = ["beast"]
const VILE_GERMS_TYPES = ["plant"]
const MYSTICAL_MOON_TYPES = ["beast-warrior"]
const SILVER_BOW_ARROW_TYPES = ["fairy"]
const DRAGON_TREASURE_TYPES = ["dragon"]
const ELECTRO_WHIP_TYPES = ["thunder"]
const VIOLET_CRYSTAL_TYPES = ["zombie"]
const BOOK_OF_SECRET_ARTS_TYPES = ["spellcaster"]

const DARK_DESTRUCTION_ATTRIBUTE = ["dark"]
const ELFS_LIGHT_ATTRIBUTE = ["light"]
const STEEL_SHELL_ATTRIBUTE = ["water"]
const INVIGORATION_ATTRIBUTES = ["earth"]
const SALAMANDRA_ATTRIBUTES = ["fire"]
const GUST_FAN_ATTRIBUTES = ["wind"]

const CYBER_SHIELD_VALID_IDS = [62, 63]
const MAGICAL_LABYRINTH_VALID_IDS = [366]

const ELEGANT_EGOTIST_VALID_IDS = [62]
const HARPY_LADY_ID = 62
const REQUIRED_CARDS_WARLION_RITUAL = [201, 403, 483]
const SUMMONED_CARD_WARLION_RITUAL_ID = 356
const REQUIRED_CARDS_COMMENCEMENT_DANCE = [249, 395, 511]
const SUMMONED_CARD_COMMENCEMENT_DANCE_ID = 701
const REQUIRED_CARDS_HAMBURGER_RECIPE = [14, 295, 547]
const SUMMONED_CARD_HAMBURGER_RECIPE_ID = 702
const REQUIRED_CARDS_ZERA_RITUAL = [85, 298, 377]
const SUMMONED_CARD_ZERA_RITUAL_ID = 360
const REQUIRED_CARDS_BLACK_LUSTER_RITUAL = [27, 38, 58]
const SUMMONED_CARD_BLACK_LUSTER_RITUAL_ID = 364
const REQUIRED_CARDS_BEASTLY_MIRROR_RITUAL = [186, 261, 595]
const SUMMONED_CARD_BEASTLY_MIRROR_RITUAL_ID = 365
const REQUIRED_CARDS_REVIVAL_OF_DOKURORIDER = [146, 479, 485]
const SUMMONED_CARD_REVIVAL_OF_DOKURORIDER_ID = 719
const REQUIRED_CARDS_NOVOX_PRAYER = [160, 161, 535]
const SUMMONED_CARD_NOVOX_PRAYER_ID = 704
const REQUIRED_CARDS_TURTLE_OATH = [89, 449, 451]
const SUMMONED_CARD_TURTLE_OATH_ID = 710
const REQUIRED_CARDS_RESURRECTION_OF_CHAKRA = [178, 296, 288]
const SUMMONED_CARD_RESURRECTION_OF_CHAKRA_ID = 709
const REQUIRED_CARDS_GARMA_SWORD_OATH = [239, 378, 621]
const SUMMONED_CARD_GARMA_SWORD_OATH_ID = 716
const REQUIRED_CARDS_FORTRESS_WHALE_OATH = [436, 441, 542]
const SUMMONED_CARD_FORTRESS_WHALE_OATH_ID = 718
const REQUIRED_CARDS_BLACK_MAGIC_RITUAL = [7, 35, 417]
const SUMMONED_CARD_BLACK_MAGIC_RITUAL_ID = 722
const REQUIRED_CARDS_JAVELIN_BEETLE = [52, 480, 533]
const SUMMONED_CARD_JAVELIN_BEETLE_PACT_ID = 717

const SWORDS_OF_REVEALING_LIGHT_TURNS = 4

var swords_player_active: bool = false
var swords_player_turns_remaining: int = 0
var swords_player_turn_counter: int = 0
var swords_enemy_active: bool = false
var swords_enemy_turns_remaining: int = 0
var swords_enemy_turn_counter: int = 0

var swords_of_revealing_light_active: bool:
    get: return swords_player_active or swords_enemy_active
var swords_of_revealing_light_owner_is_player: bool:
    get: return swords_player_active
var swords_effects_nodes: Array = []

var robbin_goblin_active_player: bool = false
var robbin_goblin_active_enemy: bool = false

var active_field_id: int = 0

func reset_swords_of_revealing_light():
    swords_player_active = false
    swords_player_turns_remaining = 0
    swords_player_turn_counter = 0

    swords_enemy_active = false
    swords_enemy_turns_remaining = 0
    swords_enemy_turn_counter = 0

    for node in swords_effects_nodes:
        if is_instance_valid(node):
            node.queue_free()
    swords_effects_nodes.clear()


func check_hand_effects(is_player: bool, hand_list: Array) -> bool:
    if _check_exodia_condition(hand_list):
        _trigger_exodia_win(is_player)
        return true
    return false

func _check_exodia_condition(hand_list: Array) -> bool:
    var ids_in_hand = _extract_card_ids(hand_list)

    for part_id in EXODIA_IDS:
        if not part_id in ids_in_hand:
            return false

    return true

func _extract_card_ids(hand_list: Array) -> Array:
    var ids = []

    for item in hand_list:
        var card_id = _get_card_id(item)
        if card_id != -1:
            ids.append(card_id)

    return ids

func _get_card_id(item) -> int:
    if item is CardData:
        return item.id
    elif item != null and item.has_method("get_card_data"):
        return item.my_card_data.id
    elif item != null and "id" in item:
        return item.id
    return -1

func _trigger_exodia_win(is_player: bool):
    print("EXODIA OBLITERATE! Vencedor: ", "Jogador" if is_player else "Inimigo")

    if duel_manager:
        duel_manager.set_process_input(false)


    if effect_video_layer:
        var video_path = "res://assets/videos/exodia.ogv"
        await effect_video_layer.play_effect_video(video_path)


    if duel_manager:
        if is_player:
            duel_manager.game_over_win("EXODIA OBLITERATE")
        else:
            duel_manager.game_over_loss("EXODIA OBLITERATE")


func resolve_effect(card_data: CardData, is_player_owner: bool):
    if not card_data:
        return

    print("EffectManager: Resolvendo efeito de ", card_data.name)

    match card_data.id:
        EFFECT_SPARKS:
            await _effect_sparks(is_player_owner)
        EFFECT_MOOYAN_CURRY:
            await _effect_mooyan_curry(is_player_owner)
        EFFECT_RAIGEKI:
            await _effect_raigeki(is_player_owner)
        EFFECT_FIELD_FOREST:
            await _effect_field_forest(is_player_owner)
        EFFECT_STOP_DEFENSE:
            await _effect_stop_defense(is_player_owner)
        EFFECT_WASTELAND:
            await _effect_wasteland(is_player_owner)
        EFFECT_MOUNTAIN:
            await _effect_mountain(is_player_owner)
        EFFECT_SOGEN:
            await _effect_sogen(is_player_owner)
        EFFECT_UMI:
            await _effect_umi(is_player_owner)
        EFFECT_INSECT_IMITATION:
            await _effect_insect_imitation(is_player_owner)
        EFFECT_TWISTER:
            await _effect_twister(is_player_owner)
        EFFECT_BOOK_OF_LIFE:
            await _effect_book_of_life(is_player_owner)
        EFFECT_YAMI:
            await _effect_yami(is_player_owner)
        EFFECT_DARK_HOLE:
            await _effect_dark_hole(is_player_owner)
        EFFECT_RED_MEDICINE:
            await _effect_red_medicine(is_player_owner)
        EFFECT_GOBLIN_REMEDY:
            await _effect_goblin_remedy(is_player_owner)
        EFFECT_SOUL_OF_THE_PURE:
            await _effect_soul_of_the_pure(is_player_owner)
        EFFECT_DIAN_KETO:
            await _effect_dian_keto(is_player_owner)
        EFFECT_HINOTAMA:
            await _effect_hinotama(is_player_owner)
        EFFECT_FINAL_FLAME:
            await _effect_final_flame(is_player_owner)
        EFFECT_OOKAZI:
            await _effect_ookazi(is_player_owner)
        EFFECT_TREMENDOUS_FIRE:
            await _effect_tremendous_fire(is_player_owner)
        EFFECT_SWORDS_OF_REVEALING_LIGHT:
            await _effect_swords_of_revealing_light(is_player_owner)
        EFFECT_DARK_PIERCING_LIGHT:
            await _effect_dark_piercing_light(is_player_owner)
        COMMENCEMENT_DANCE_ID:
            await _effect_commencement_dance(is_player_owner)
        HAMBURGER_RECIPE_ID:
            await _effect_hamburger_recipe(is_player_owner)
        WARLION_RITUAL_ID:
            await _effect_warlion_ritual(is_player_owner)
        ZERA_RITUAL_ID:
            await _effect_zera_ritual(is_player_owner)
        POLYMERIZATION_ID:
            await _effect_polymerization(is_player_owner)
        BLACK_LUSTER_RITUAL_ID:
            await _effect_black_luster_ritual(is_player_owner)
        BEASTLY_MIRROR_RITUAL_ID:
            await _effect_beastly_mirror_ritual(is_player_owner)
        REMOVE_TRAP_ID:
            await _effect_remove_trap(is_player_owner)
        EFFECT_FISSURE:
            await _effect_fissure(is_player_owner)
        EFFECT_POT_OF_GREED:
            await _effect_pot_of_greed(is_player_owner)
        EFFECT_WARRIOR_ELIMINATION:
            await _effect_warrior_elimination(is_player_owner)
        EFFECT_ETERNAL_REST:
            await _effect_eternal_rest(is_player_owner)
        EFFECT_ERADICATING_AEROSOL:
            await _effect_eradicating_aerosol(is_player_owner)
        EFFECT_BREATH_OF_LIGHT:
            await _effect_breath_of_light(is_player_owner)
        EFFECT_ETERNAL_DRAUGHT:
            await _effect_eternal_draught(is_player_owner)
        EFFECT_HARPIES_FEATHER_DUSTER:
            await _effect_harpies_feather_duster(is_player_owner)
        EFFECT_GRAVEDIGGER_GHOUL:
            await _effect_gravedigger_ghoul(is_player_owner)
        REVIVAL_OF_DOKURORIDER_ID:
            await _effect_revival_of_dokurorider(is_player_owner)
        NOVOX_PRAYER_ID:
            await _effect_novox_prayer(is_player_owner)
        DE_SPELL_ID:
            await _effect_de_spell(is_player_owner)
        TURTLE_OATH_ID:
            await _effect_turtle_oath(is_player_owner)
        EFFECT_MONSTER_REBORN:
            await _effect_monster_reborn(is_player_owner)
        CHANGE_OF_HEART_ID:
            await _effect_change_of_heart(is_player_owner)
        RESURECTION_OF_CHAKRA_ID:
            await _effect_resurrection_of_chakra(is_player_owner)
        GARMA_SWORD_OATH_ID:
            await _effect_garma_sword_oath(is_player_owner)
        FORTRESS_WHALE_OATH_ID:
            await _effect_fortress_whale_oath(is_player_owner)
        BLACK_MAGIC_RITUAL_ID:
            await _effect_black_magic_ritual(is_player_owner)
        JAVELIN_BEETLE_PACT_ID:
            await _effect_javelin_beetle_pact(is_player_owner)
        EFFECT_ANCIENT_TELESCOPE:
            await _effect_ancient_telescope(is_player_owner)
        EFFECT_FLUTE_OF_SUMMONING_DRAGON:
            await _effect_flute_of_summoning_dragon(is_player_owner)
        EFFECT_CARD_DESTRUCTION:
            await _effect_card_destruction(is_player_owner)
        EFFECT_LAST_WILL:
            await _effect_last_will(is_player_owner)
        EFFECT_BLUE_MEDICINE:
            await _effect_blue_medicine(is_player_owner)
        EFFECT_RAIMEI:
            await _effect_raimei(is_player_owner)
        EFFECT_SOUL_RELEASE:
            await _effect_soul_release(is_player_owner)
        EFFECT_TRIBUTE_TO_THE_DOOMED:
            await _effect_tribute_to_the_doomed(is_player_owner)
        EFFECT_SHARE_THE_PAIN:
            await _effect_share_the_pain(is_player_owner)
        EFFECT_SHIELD_AND_SWORD:
            await _effect_shield_and_sword(is_player_owner)
        EFFECT_HEAVY_STORM:
            await _effect_heavy_storm(is_player_owner)
        EFFECT_UNION_ATTACK:
            await _effect_union_attack(is_player_owner)
        EFFECT_FIELD_GAIA_POWER:
            await _effect_gaia_power(is_player_owner)
        EFFECT_FIELD_SANCTUARY:
            await _effect_sanctuary(is_player_owner)
        EFFECT_ORDER_TO_CHARGE:
            await _effect_order_to_charge(is_player_owner)
        EFFECT_FIELD_JURASSIC_WORLD:
            await _effect_field_jurassic_world(is_player_owner)
        _:
            print("Efeito nÃ£o implementado para ID: ", card_data.id)

func apply_monster_effect_on_summon(card_data: CardData, is_player_owner: bool, slot):
    if not card_data or not duel_manager:
        return

    print("EffectManager: Aplicando efeito de monstro: ", card_data.name)

    match card_data.id:
        MAHA_VAILO_ID:
            await _apply_maha_vailo_effect(card_data, is_player_owner, slot)
        YADO_KARU_ID:
            await _apply_yado_karu_effect(card_data, is_player_owner, slot)
        DRAGON_SEEKER_ID:
            await _apply_dragon_seeker_effect(card_data, is_player_owner, slot)
        GALE_DOGRA_ID:
            await _apply_gale_dogra_effect(card_data, is_player_owner, slot)
        SKELENGEL_ID:
            await _apply_skelengel_effect(card_data, is_player_owner, slot)
        MUSHROOM_MAN_2_ID:
            await _apply_mushroom_man_2_effect(card_data, is_player_owner, slot)
        NEEDLE_WORM_ID:
            await _apply_needle_worm_effect(card_data, is_player_owner, slot)
        WEATHER_REPORT_ID:
            await _apply_weather_report_effect(card_data, is_player_owner, slot)
        GREENKAPPA_ID:
            await _apply_greenkappa_effect(card_data, is_player_owner, slot)
        BLADEFLY_ID:
            await _apply_bladefly_effect(card_data, is_player_owner, slot)
        WITCHS_APPRENTICE_ID:
            await _apply_witchs_apprentice_effect(card_data, is_player_owner, slot)
        STEEL_SCORPION_ID:
            await _apply_steel_scorpion_effect(card_data, is_player_owner, slot)
        GODDESS_OF_WHIM_ID:
            await _apply_goddess_of_whim_effect(card_data, is_player_owner, slot)
        ELECTRIC_SNAKE_ID:
            await _apply_electric_snake_effect(card_data, is_player_owner, slot)
        MORPHING_JAR_ID:
            await _apply_morphing_jar_effect(card_data, is_player_owner, slot)
        PENGUIN_SOLDIER_ID:
            await _apply_penguin_soldier_effect(card_data, is_player_owner, slot)
        MUKA_MUKA_ID:
            await _apply_muka_muka_effect(card_data, is_player_owner, slot)
        ARMED_NINJA_ID:
            await _apply_armed_ninja_effect(card_data, is_player_owner, slot)
        STERN_MYSTIC_ID:
            await _apply_stern_mystic_effect(card_data, is_player_owner, slot)
        BARREL_DRAGON_ID:
            await _apply_barrel_dragon_effect(card_data, is_player_owner, slot)
        REAPER_OF_CARDS_ID:
            await _apply_reaper_of_cards_effect(card_data, is_player_owner, slot)
        TIME_WIZARD_ID:
            await _apply_time_wizard_effect(card_data, is_player_owner, slot)
        SANGAN_ID:
            await _apply_sangan_effect(card_data, is_player_owner, slot)
        MASK_OF_DARKNESS_ID:
            await _apply_mask_of_darkness_effect(card_data, is_player_owner, slot)
        SWAMP_BATTLEGUARD_ID:
            await _apply_swamp_battleguard_effect(card_data, is_player_owner, slot)
        LAVA_BATTLEGUARD_ID:
            await _apply_lava_battleguard_effect(card_data, is_player_owner, slot)
        DRAGON_PIPER_ID:
            await _apply_dragon_piper_effect(card_data, is_player_owner, slot)
        CASTLE_OF_DARK_ILLUSIONS_ID:
            await _apply_castle_of_dark_illusions_effect(card_data, is_player_owner, slot)
        CRASS_CLOWN_ID:
            await _apply_crass_clown_effect(card_data, is_player_owner, slot)
        DREAM_CLOWN_ID:
            await _apply_dream_clown_effect(card_data, is_player_owner, slot)
        PUMPKING_THE_KING_OF_GHOSTS_ID:
            await _apply_pumpking_effect(card_data, is_player_owner, slot)
        TAINTED_WISDOM_ID:
            await _apply_tainted_wisdom_effect(card_data, is_player_owner, slot)
        MYSTERIOUS_PUPPETEER_ID:
            await _apply_mysterious_puppeteer_effect(card_data, is_player_owner, slot)
        BIG_EYE_ID:
            await _apply_big_eye_effect(card_data, is_player_owner, slot)
        LORD_OF_D_ID:
            await _apply_lord_of_d_effect(card_data, is_player_owner, slot)
        TRAP_MASTER_ID:
            await _apply_trap_master_effect(card_data, is_player_owner, slot)
        WODAN_THE_RESIDENT_OF_THE_FOREST_ID:
            await _apply_wodan_effect(card_data, is_player_owner, slot)
        PRINCESS_OF_TSURUGI_ID:
            await _apply_princess_of_tsurugi_effect(card_data, is_player_owner, slot)
        SHADOW_GHOUL_ID:
            await _apply_shadow_ghoul_effect(card_data, is_player_owner, slot)
        SHADOW_WALL_ID:
            await _apply_shadow_wall_effect(card_data, is_player_owner, slot)
        CANNON_SOLDIER_ID:
            await _apply_cannon_soldier_effect(card_data, is_player_owner, slot)
        BLUE_EYES_STARLORD_DRAGON_ID:
            await _apply_blue_eyes_starlord_dragon_effect(card_data, is_player_owner, slot)
        SANGA_OF_THE_THUNDER_ID:
            await _apply_sanga_of_the_thunder_effect(card_data, is_player_owner, slot)
        KAZEIJIN_ID:
            await _apply_kazejin_effect(card_data, is_player_owner, slot)
        SUIJIN_ID:
            await _apply_suijin_effect(card_data, is_player_owner, slot)
        GATE_GUARDIAN_ID:
            await _apply_gate_guardian_effect(card_data, is_player_owner, slot)
        SINISTER_SERPENT_ID:
            await _apply_sinister_serpent_effect(card_data, is_player_owner, slot)
        MILUS_RADIANT_ID:
            await _apply_milus_radiant_effect(card_data, is_player_owner, slot)
        PATROL_ROBO_ID:
            await _apply_patrol_robo_effect(card_data, is_player_owner, slot)
        MAGICIAN_OF_FAITH_ID:
            await _apply_magician_of_faith_effect(card_data, is_player_owner, slot)
        CYBER_STEIN_ID:
            await _apply_cyber_stein_effect(card_data, is_player_owner, slot)
        HIROS_SHADOW_SCOUT_ID:
            await _apply_hiros_shadow_scout_effect(card_data, is_player_owner, slot)
        LITTLE_CHIMERA_ID:
            await _apply_little_chimera_effect(card_data, is_player_owner, slot)
        STAR_BOY_ID:
            await _apply_star_boy_effect(card_data, is_player_owner, slot)
        HOSHININGEN_ID:
            await _apply_hoshiningen_effect(card_data, is_player_owner, slot)
        HOURGLASS_OF_COURAGE_ID:
            await _apply_hourglass_of_courage_effect(card_data, is_player_owner, slot)
        THE_IMMORTAL_OF_THUNDER_ID:
            await _apply_immortal_of_thunder_summon_effect(card_data, is_player_owner, slot)
        INVADER_OF_THE_THRONE_ID:
            await _apply_invader_of_throne_effect(card_data, is_player_owner, slot)
        THUNDER_DRAGON_ID:
            await _apply_thunder_dragon_effect(card_data, is_player_owner, slot)
        HARPIES_PET_DRAGON_ID:
            await _apply_harpies_pet_dragon_effect(card_data, is_player_owner, slot)
        MACHINE_KING_ID:
            await _apply_machine_king_effect(card_data, is_player_owner, slot)
        MELTIEL_ID:
            await _apply_meltiel_effect(card_data, is_player_owner, slot)
        ZERADIAS_ID:
            await _apply_zeradias_effect(card_data, is_player_owner, slot)
        BOUNTIFUL_ARTEMIS_ID:
            await _apply_bountiful_artemis_effect(card_data, is_player_owner, slot)
        DARK_MAGICIAN_GIRL_ID:
            await _apply_dark_magician_girl_effect(card_data, is_player_owner, slot)
        GUARDIAN_SPHINX_ID:
            await _apply_guardian_sphinx_effect(card_data, is_player_owner, slot)
        ROCK_SPIRIT_ID:
            await _apply_rock_spirit_effect(card_data, is_player_owner, slot)
        GUARDIAN_STATUE_ID:
            await _apply_guardian_statue_effect(card_data, is_player_owner, slot)
        MEGAROCK_DRAGON_ID:
            await _apply_megarock_dragon_effect(card_data, is_player_owner, slot)
        BLACK_BRACHIOS_ID:
            await _apply_black_brachios_effect(card_data, is_player_owner, slot)
        DESTROYERSAURUS_ID:
            await _apply_destroyersaurus_effect(card_data, is_player_owner, slot)
        SUPER_ANCIENT_DINOBEAST_ID:
            await _apply_super_ancient_dinobeast_effect(card_data, is_player_owner, slot)
        BEETRON_ID:
            await _apply_beetron_effect(card_data, is_player_owner, slot)
        BLAZEWING_BUTTERFLY_ID:
            await _apply_blazewing_butterfly_effect(card_data, is_player_owner, slot)
        BLOWBACK_DRAGON_DRAGON_ID:
            await _apply_blowback_dragon_effect(card_data, is_player_owner, slot)
        TWIN_BARREL_DRAGON_ID:
            await _apply_twin_barrel_dragon_effect(card_data, is_player_owner, slot)
        HEAVY_MECH_SUPPORT_PLATFORM_ID:
            await _apply_heavy_mech_support_platform_effect(card_data, is_player_owner, slot)
        SAMURAI_SKULL_ID:
            await _apply_samurai_skull_effect(card_data, is_player_owner, slot)
        GOZUKI_ID:
            await _apply_gozuki_effect(card_data, is_player_owner, slot)
        ZOMBIE_MASTER_ID:
            await _apply_zombie_master_effect(card_data, is_player_owner, slot)
        CHAOS_NECROMANCER_ID:
            await _apply_chaos_necromancer_effect(card_data, is_player_owner, slot)
        KING_OF_THE_SKULL_SERVANTS_ID:
            await _apply_king_of_the_skull_servants_effect(card_data, is_player_owner, slot)

        _:
            pass

func has_on_summon_effect(card_id: int) -> bool:
    match card_id:
        MAHA_VAILO_ID, YADO_KARU_ID, DRAGON_SEEKER_ID, GALE_DOGRA_ID, SKELENGEL_ID, \
MUSHROOM_MAN_2_ID, NEEDLE_WORM_ID, WEATHER_REPORT_ID, GREENKAPPA_ID, BLADEFLY_ID, \
WITCHS_APPRENTICE_ID, STEEL_SCORPION_ID, GODDESS_OF_WHIM_ID, ELECTRIC_SNAKE_ID, \
MORPHING_JAR_ID, PENGUIN_SOLDIER_ID, MUKA_MUKA_ID, ARMED_NINJA_ID, STERN_MYSTIC_ID, \
BARREL_DRAGON_ID, REAPER_OF_CARDS_ID, TIME_WIZARD_ID, SANGAN_ID, MASK_OF_DARKNESS_ID, \
SWAMP_BATTLEGUARD_ID, LAVA_BATTLEGUARD_ID, DRAGON_PIPER_ID, CASTLE_OF_DARK_ILLUSIONS_ID, \
CRASS_CLOWN_ID, DREAM_CLOWN_ID, PUMPKING_THE_KING_OF_GHOSTS_ID, TAINTED_WISDOM_ID, \
MYSTERIOUS_PUPPETEER_ID, BIG_EYE_ID, LORD_OF_D_ID, TRAP_MASTER_ID, \
WODAN_THE_RESIDENT_OF_THE_FOREST_ID, PRINCESS_OF_TSURUGI_ID, SHADOW_GHOUL_ID, \
SHADOW_WALL_ID, CANNON_SOLDIER_ID, BLUE_EYES_STARLORD_DRAGON_ID, SANGA_OF_THE_THUNDER_ID, \
KAZEIJIN_ID, SUIJIN_ID, GATE_GUARDIAN_ID, SINISTER_SERPENT_ID, MILUS_RADIANT_ID, \
PATROL_ROBO_ID, MAGICIAN_OF_FAITH_ID, CYBER_STEIN_ID, HIROS_SHADOW_SCOUT_ID, \
LITTLE_CHIMERA_ID, STAR_BOY_ID, HOSHININGEN_ID, HOURGLASS_OF_COURAGE_ID, \
THE_IMMORTAL_OF_THUNDER_ID, INVADER_OF_THE_THRONE_ID, THUNDER_DRAGON_ID, \
HARPIES_PET_DRAGON_ID, MACHINE_KING_ID, MELTIEL_ID, ZERADIAS_ID, BOUNTIFUL_ARTEMIS_ID, \
DARK_MAGICIAN_GIRL_ID, GUARDIAN_SPHINX_ID, ROCK_SPIRIT_ID, GUARDIAN_STATUE_ID, \
MEGAROCK_DRAGON_ID, BLACK_BRACHIOS_ID, DESTROYERSAURUS_ID, SUPER_ANCIENT_DINOBEAST_ID, \
BEETRON_ID, BLAZEWING_BUTTERFLY_ID, BLOWBACK_DRAGON_DRAGON_ID, TWIN_BARREL_DRAGON_ID, \
HEAVY_MECH_SUPPORT_PLATFORM_ID, SAMURAI_SKULL_ID, GOZUKI_ID, ZOMBIE_MASTER_ID, \
CHAOS_NECROMANCER_ID, KING_OF_THE_SKULL_SERVANTS_ID:
            return true
    return false

func apply_monster_effect_on_attack(attacker_card_data: CardData, attacker_is_player_owner: bool, attacker_slot):
    if not attacker_card_data or not duel_manager:
        return

    print("EffectManager: Aplicando efeito de ataque de monstro: ", attacker_card_data.name)

    match attacker_card_data.id:
        CATAPULT_TURTLE_ID:
            await _apply_catapult_turtle_effect(attacker_card_data, attacker_is_player_owner, attacker_slot)
        DARK_ELF_ID:
            await _apply_dark_elf_effect(attacker_card_data, attacker_is_player_owner, attacker_slot)

        _:
            pass

func _is_card_face_up(slot, _is_player_owner: bool) -> bool:
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if not card_visual:
        return false


    if card_visual.has_method("is_face_down"):
        return not card_visual.is_face_down()
    elif duel_manager.has_method("_has_card_back"):
        return not duel_manager._has_card_back(card_visual)

    return false


func get_temporary_attack_bonus(attacker_card: CardData, defender_card: CardData) -> int:
    var bonus = 0
    if not attacker_card or not defender_card:
        return 0

    match attacker_card.id:
        INSECT_SOLDIERS_OF_THE_SKY_ID:
            if defender_card.attribute == "Wind":
                print("Insect Soldiers of the Sky ganham +1000 ATK contra monstros de atributo WIND!")
                bonus += 1000

    return bonus


func apply_monster_effect_on_attacked(defender_card_data: CardData, defender_is_player_owner: bool, defender_slot, attacker_card_data: CardData, attacker_slot):
    if not defender_card_data or not attacker_card_data or not duel_manager:
        return

    match defender_card_data.id:
        ELECTRIC_LIZARD_ID:
            await _apply_electric_lizard_effect(defender_card_data, defender_is_player_owner, defender_slot, attacker_card_data, attacker_slot)

func apply_monster_effect_on_destruction(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool = true, slot = null):
    if not card_data or not duel_manager:
        return

    match card_data.id:
        AMEBA_ID:
            await _apply_ameba_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        THE_IMMORTAL_OF_THUNDER_ID:
            await _apply_immortal_of_thunder_destruction_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        MONSTER_EYE_ID:
            await _apply_monster_eye_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        GRIGGLE_ID:
            await _apply_griggle_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        SWAMP_BATTLEGUARD_ID, LAVA_BATTLEGUARD_ID:
            await update_battleguards_bonus(is_player_owner)
        PENGUIN_KNIGHT_ID:
            await _apply_penguin_knight_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        COCKROACH_KNIGHT_ID:
            await _apply_cockroach_knight_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        BLAST_JUGGLER_ID:
            await _apply_blast_juggler_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        501:
            await _apply_man_eater_bug_effect(is_player_owner)
        NEEDLE_BALL_ID:
            await _apply_needle_ball_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        MINAR_ID:
            await _apply_minar_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        WITCH_OF_THE_BLACK_FOREST_ID:
            await _apply_witch_of_the_black_forest_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        NIMBLE_MOMONGA_ID:
            await _apply_nimble_momonga_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        HARVEST_ANGEL_ID:
            await _apply_harvest_angel_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        BLACK_PTERA_ID:
            await _apply_black_ptera_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        KISETAI_ID:
            await _apply_kisetai_effect(card_data, is_player_owner, destroyed_by_battle, slot)
        SKULL_MARK_LADYBUG_ID:
            await _apply_skull_mark_ladybug_effect(card_data, is_player_owner, destroyed_by_battle, slot)


func _apply_magic_activation_glow(card_visual):
    duel_manager._apply_magic_activation_glow(card_visual)

func destroy_card(slot_node):
    await get_tree().create_timer(0.5).timeout
    await duel_manager._destroy_card(slot_node)
    await get_tree().create_timer(0.5).timeout


func _effect_sparks(is_player_owner: bool):
    print("Aplicando Sparks: %d de dano." % SPARKS_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= SPARKS_DAMAGE
    else:
        duel_manager.player_lp -= SPARKS_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_raimei(is_player_owner: bool):
    print("Aplicando Raimei: %d de dano." % RAIMEI_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= RAIMEI_DAMAGE
    else:
        duel_manager.player_lp -= RAIMEI_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_hinotama(is_player_owner: bool):
    print("Aplicando Hinotama: %d de dano." % HINOTAMA_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= HINOTAMA_DAMAGE
    else:
        duel_manager.player_lp -= HINOTAMA_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_final_flame(is_player_owner: bool):
    print("Aplicando Final Flame: %d de dano." % FINAL_FLAME_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= FINAL_FLAME_DAMAGE
    else:
        duel_manager.player_lp -= FINAL_FLAME_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_ookazi(is_player_owner: bool):
    print("Aplicando Ookazi: %d de dano." % OOKAZI_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= OOKAZI_DAMAGE
    else:
        duel_manager.player_lp -= OOKAZI_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_tremendous_fire(is_player_owner: bool):
    print("Aplicando Tremendous Fire: %d de dano." % TREMENDOUS_FIRE_DAMAGE)

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.enemy_lp -= TREMENDOUS_FIRE_DAMAGE
        duel_manager.player_lp -= TREMENDOUS_FIRE_PENALTY_DAMAGE
    else:
        duel_manager.player_lp -= TREMENDOUS_FIRE_DAMAGE
        duel_manager.enemy_lp -= TREMENDOUS_FIRE_PENALTY_DAMAGE

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_mooyan_curry(is_player_owner: bool):
    print("Aplicando Mooyan Curry: +%d LP." % MOOYAN_CURRY_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, MOOYAN_CURRY_HEAL)

func _effect_stop_defense(is_player_owner: bool):
    print("EffectManager: Ativando Stop Defense")

    if not duel_manager:
        print("Erro: duel_manager nÃ£o referenciado")
        return


    var activating_player = is_player_owner


    var target_is_player = not activating_player

    print("Stop Defense: Ativado por ", "Jogador" if activating_player else "Inimigo")
    print("Stop Defense: Alvo Ã© ", "Jogador" if target_is_player else "Inimigo")


    duel_manager.start_stop_defense_targeting(target_is_player)

func _effect_dark_hole(_is_player_owner: bool):
    print("Dark Hole ativada! Destruindo TODAS as cartas do campo.")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return


    await duel_manager.execute_dark_hole_effect()

func _effect_red_medicine(is_player_owner: bool):
    print("Aplicando Red Medicine: +%d LP." % RED_MEDICINE_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, RED_MEDICINE_HEAL)

func _effect_goblin_remedy(is_player_owner: bool):
    print("Aplicando Goblin Remedy: +%d LP." % GOBLIN_REMEDY_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, GOBLIN_REMEDY_HEAL)

func _effect_soul_of_the_pure(is_player_owner: bool):
    print("Aplicando Soul of the Pure: +%d LP." % SOUL_OF_THE_PURE_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, SOUL_OF_THE_PURE_HEAL)

func _effect_dian_keto(is_player_owner: bool):
    print("Aplicando Dian Keto: +%d LP." % DIAN_KETO_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, DIAN_KETO_HEAL)

func _effect_blue_medicine(is_player_owner: bool):
    print("Aplicando Blue Medicine: +%d LP." % BLUE_MEDICINE_HEAL)

    if not duel_manager:
        return

    await duel_manager.heal_lp(is_player_owner, BLUE_MEDICINE_HEAL)

func _apply_muka_muka_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("EffectManager: Aplicando efeito do Muka Muka!")

    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual and not is_face_up:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


    if is_face_up:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var hand_count = 0

    if is_player_owner:

        if duel_manager.has_method("get_player_hand_count"):
            hand_count = duel_manager.get_player_hand_count()
        else:

            for card in duel_manager.player_hand:
                if card != null:
                    hand_count += 1
    else:

        if duel_manager.has_method("get_enemy_hand_count"):
            hand_count = duel_manager.get_enemy_hand_count()
        else:

            for card in duel_manager.enemy_hand:
                if card != null:
                    hand_count += 1


    var bonus = hand_count * MUKA_MUKA_BONUS_PER_CARD
    print("Muka Muka: ", hand_count, " cartas na mÃ£o â†’ +", bonus, " ATK/DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:

            if card_visual.has_method("animate_stats_bonus"):
                card_visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Muka Muka: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

func _apply_armed_ninja_effect(_card_data: CardData, is_player_owner: bool, slot):

    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual and not is_face_up:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


    if is_face_up:
        await duel_manager._apply_magic_activation_glow(card_visual)

    if not is_face_up:
        print("Armed Ninja: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Armed Ninja: Efeito ativado - DestrÃ³i carta mÃ¡gica/armadilha aleatÃ³ria")

    if not duel_manager:
        return


    var opponent_is_player = not is_player_owner


    duel_manager.destroy_random_opponent_spell(opponent_is_player, is_player_owner)

func _apply_trap_master_effect(_card_data: CardData, is_player_owner: bool, slot):

    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    if card_visual and not is_face_up:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Trap Master: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Trap Master: Efeito ativado - DestrÃ³i carta mÃ¡gica/armadilha aleatÃ³ria")

    if not duel_manager:
        return


    var opponent_is_player = not is_player_owner


    duel_manager.destroy_random_opponent_spell(opponent_is_player, is_player_owner)

func _apply_reaper_of_cards_effect(_card_data: CardData, is_player_owner: bool, slot):

    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    if card_visual and not is_face_up:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Reaper of Cards: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Reaper of Cards: Efeito ativado - DestrÃ³i carta mÃ¡gica/armadilha aleatÃ³ria")

    if not duel_manager:
        return


    var opponent_is_player = not is_player_owner


    duel_manager.destroy_random_opponent_spell(opponent_is_player, is_player_owner)

func _apply_ameba_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Ameba: Efeito ativado - Causa 1000 de dano ao oponente")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= AMEBA_DAMAGE
        print("Ameba da IA causa ", AMEBA_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= AMEBA_DAMAGE
        print("Ameba do Jogador causa ", AMEBA_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_monster_eye_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Monster Eye: Efeito ativado - Causa 500 de dano ao oponente")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= MONSTER_EYE_DAMAGE
        print("Ameba da IA causa ", MONSTER_EYE_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= MONSTER_EYE_DAMAGE
        print("Ameba do Jogador causa ", MONSTER_EYE_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_needle_ball_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Needle Ball: Efeito ativado - Causa 1000 de dano ao oponente")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= NEEDLE_BALL_DAMAGE
        print("Needle Ball da IA causa ", NEEDLE_BALL_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= NEEDLE_BALL_DAMAGE
        print("Needle Ball do Jogador causa ", NEEDLE_BALL_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_skull_mark_ladybug_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Skull Mark Ladybug: Efeito ativado - Causa 1000 de dano ao oponente")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= SKULL_MARK_LADYBUG_DAMAGE
        print("Needle Ball da IA causa ", SKULL_MARK_LADYBUG_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= SKULL_MARK_LADYBUG_DAMAGE
        print("Needle Ball do Jogador causa ", SKULL_MARK_LADYBUG_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_minar_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Minar: Efeito ativado - Causa 1000 de dano ao oponente")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= MINAR_DAMAGE
        print("Minar da IA causa ", MINAR_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= MINAR_DAMAGE
        print("Minar do Jogador causa ", MINAR_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_griggle_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Griggle: Efeito ativado - Cura 500 pontos de vida")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var healer_is_player = not opponent_is_player
    print("Griggle: Curando ", GRIGGLE_HEAL, " LP de ", "Jogador" if healer_is_player else "IA")
    await duel_manager.heal_lp(healer_is_player, GRIGGLE_HEAL)


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_kisetai_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Kisetai: Efeito ativado - Cura 1000 pontos de vida")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var healer_is_player = not opponent_is_player
    print("Nimble Momonga: Curando ", KISETAI_HEAL, " LP de ", "Jogador" if healer_is_player else "IA")
    await duel_manager.heal_lp(healer_is_player, KISETAI_HEAL)


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_nimble_momonga_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Nimble Momonga: Efeito ativado - Cura 1000 pontos de vida")

    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var healer_is_player = not opponent_is_player
    print("Nimble Momonga: Curando ", NIMBLE_MOMONGA_HEAL, " LP de ", "Jogador" if healer_is_player else "IA")
    await duel_manager.heal_lp(healer_is_player, NIMBLE_MOMONGA_HEAL)


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()


func _apply_penguin_soldier_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Penguin Soldier: Efeito de invocaÃ§Ã£o ativado")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    if self_visual and not is_face_up:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Penguin Soldier: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Penguin Soldier: Efeito ativado - Devolve 2 monstros do oponente para o deck")

    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots
    var face_up_monsters = []


    for opp_slot in opponent_slots:
        if opp_slot.is_occupied:
            var opp_is_face_up = false
            var opp_visual = opp_slot.spawn_point.get_child(0) if opp_slot.spawn_point.get_child_count() > 0 else null
            if opp_visual:
                if opp_visual.has_method("is_face_down"):
                    opp_is_face_up = not opp_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    opp_is_face_up = not duel_manager._has_card_back(opp_visual)

            if opp_is_face_up:
                face_up_monsters.append(opp_slot)

    if face_up_monsters.is_empty():
        print("Penguin Soldier: Oponente nÃ£o tem monstros face-up")
        return


    var cards_to_return = 2
    face_up_monsters.shuffle()

    var actual_return_count = min(cards_to_return, face_up_monsters.size())
    var target_slots = face_up_monsters.slice(0, actual_return_count)


    var opponent_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile

    for target_slot in target_slots:
        var target_card = target_slot.stored_card_data
        print("Penguin Soldier: Devolvendo %s para o deck do oponente" % target_card.name)


        _clear_slot_visually(target_slot)
        opponent_deck.append(target_card.get_original_atk_def())


    opponent_deck.shuffle()
    duel_manager.update_deck_ui()

    print("Penguin Soldier: Efeito concluÃ­do. Monstros devolvidos: %d" % actual_return_count)


func _apply_morphing_jar_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Morphing Jar: Efeito de invocaÃ§Ã£o ativado")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    if self_visual and not is_face_up:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Morphing Jar: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Morphing Jar: Efeito ativado - Ambos os jogadores descartam as mÃ£os e compram 5 cartas")


    var player_hand = duel_manager.player_hand
    var enemy_hand = duel_manager.enemy_hand


    var player_discard = player_hand.duplicate()
    var enemy_discard = enemy_hand.duplicate()

    for card in player_discard:
        player_hand.erase(card)
        duel_manager.send_to_graveyard(card, true, true)

    for card in enemy_discard:
        enemy_hand.erase(card)
        duel_manager.send_to_graveyard(card, false, true)

    duel_manager.update_deck_ui()

    if duel_manager.has_method("update_hand_ui_animated"):
        duel_manager.update_hand_ui_animated(true)
    if duel_manager.has_method("update_enemy_hand_ui_animated"):
        duel_manager.update_enemy_hand_ui_animated(true)

    await get_tree().create_timer(0.5).timeout


    print("Morphing Jar: Comprando 5 cartas para cada jogador")
    for i in range(5):

        var p_card = duel_manager.draw_card_from_deck(true, true)
        if p_card:
            player_hand.append(p_card)


        var e_card = duel_manager.draw_card_from_deck(false, true)
        if e_card:
            enemy_hand.append(e_card)

        await get_tree().create_timer(0.2).timeout


    if duel_manager.has_method("update_hand_ui_animated"):
        duel_manager.update_hand_ui_animated(true)
    if duel_manager.has_method("update_enemy_hand_ui_animated"):
        duel_manager.update_enemy_hand_ui_animated(true)
    duel_manager.update_deck_ui()


func _apply_yado_karu_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Yado Karu: Efeito de invocaÃ§Ã£o ativado")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Yado Karu: Invocado face-down, efeito nÃ£o ativa")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    print("Yado Karu: Efeito ativado - O dono retorna as cartas da mÃ£o para o deck e compra 5")


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var cards_to_return = owner_hand.duplicate()


    for card in cards_to_return:
        owner_hand.erase(card)
        owner_deck.append(card)


    owner_deck.shuffle()
    duel_manager.update_deck_ui()

    if is_player_owner:
        if duel_manager.has_method("update_hand_ui_animated"):
            duel_manager.update_hand_ui_animated(true)
    else:
        if duel_manager.has_method("update_enemy_hand_ui_animated"):
            duel_manager.update_enemy_hand_ui_animated(true)

    await get_tree().create_timer(0.5).timeout


    print("Yado Karu: Comprando 5 cartas")
    for i in range(5):
        var draw_card = duel_manager.draw_card_from_deck(is_player_owner, true)
        if draw_card:
            owner_hand.append(draw_card)
        await get_tree().create_timer(0.2).timeout


    if is_player_owner:
        if duel_manager.has_method("update_hand_ui_animated"):
            duel_manager.update_hand_ui_animated(true)
    else:
        if duel_manager.has_method("update_enemy_hand_ui_animated"):
            duel_manager.update_enemy_hand_ui_animated(true)
    duel_manager.update_deck_ui()


func _apply_dragon_seeker_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Dragon Seeker: Efeito de invocaÃ§Ã£o ativado. Buscando DragÃ£o inimigo...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Dragon Seeker: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var enemy_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots
    var valid_targets = []

    for opp_slot in enemy_slots:
        if opp_slot.is_occupied:
            var opp_card = opp_slot.stored_card_data
            if opp_card and opp_card.type == "Dragon":
                var opp_is_face_up = false
                var opp_visual = opp_slot.spawn_point.get_child(0) if opp_slot.spawn_point.get_child_count() > 0 else null

                if opp_visual:
                    if opp_visual.has_method("is_face_down"):
                        opp_is_face_up = not opp_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        opp_is_face_up = not duel_manager._has_card_back(opp_visual)

                if opp_is_face_up:
                    valid_targets.append(opp_slot)

    if valid_targets.is_empty():
        print("Dragon Seeker: Nenhum dragÃ£o inimigo face-up encontrado.")
        return


    valid_targets.shuffle()
    var target_slot = valid_targets[0]
    var target_card = target_slot.stored_card_data

    print("Dragon Seeker: Encontrou e destruiu ", target_card.name, "!")


    var target_visual = target_slot.spawn_point.get_child(0) if target_slot.spawn_point.get_child_count() > 0 else null
    if target_visual:
        await duel_manager._apply_magic_activation_glow(target_visual)


    var is_opponent_owner = not is_player_owner
    duel_manager.send_to_graveyard(target_card, is_opponent_owner)
    _clear_slot_visually(target_slot)


func _apply_gale_dogra_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Gale Dogra: Efeito de invocaÃ§Ã£o ativado. Buscando monstro Fusion no deck inimigo...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Gale Dogra: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var enemy_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile
    var fusion_card_to_send = null


    for card in enemy_deck:
        if card.category == CardData.CardCategory.FUSION_MONSTER:
            fusion_card_to_send = card
            break

    if fusion_card_to_send:
        print("Gale Dogra: Encontrou e enviou %s para o cemitÃ©rio!" % fusion_card_to_send.name)

        enemy_deck.erase(fusion_card_to_send)


        var is_opponent_owner = not is_player_owner
        duel_manager.send_to_graveyard(fusion_card_to_send, is_opponent_owner, true)


        enemy_deck.shuffle()
        duel_manager.update_deck_ui()
    else:
        print("Gale Dogra: Nenhum monstro Fusion encontrado no deck inimigo.")


func _apply_skelengel_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Skelengel: Efeito de invocaÃ§Ã£o ativado. Buscando monstro level 4 ou menor no cemitÃ©rio aliado...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Skelengel: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var owner_gy = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile
    var gy_visual = duel_manager.player_gy_visual if is_player_owner else duel_manager.enemy_gy_visual

    var valid_indices = []


    for i in range(owner_gy.size()):
        var card = owner_gy[i]

        if int(card.category) <= 7 and card.level <= 4:
            valid_indices.append(i)

    if valid_indices.size() > 0:

        valid_indices.shuffle()
        var index_to_return = valid_indices[0]
        var card_to_return = owner_gy[index_to_return]

        print("Skelengel: Monstro aleatÃ³rio encontrado (%s). Retornando ao deck." % card_to_return.name)


        owner_gy.remove_at(index_to_return)
        if gy_visual and gy_visual.has_method("update_graveyard"):
            gy_visual.update_graveyard(owner_gy)


        owner_deck.append(card_to_return)
        owner_deck.shuffle()
        duel_manager.update_deck_ui()
    else:
        print("Skelengel: Nenhum monstro Level 4 ou menor encontrado no cemitÃ©rio aliado.")


func _apply_samurai_skull_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Samurai Skull: Efeito ativado - Enviar Zombie de Level 4 ou menor do deck aliado para o cemitÃ©rio")

    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Samurai Skull: Invocado/colocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile
    var selected_card = null

    for deck_card in owner_deck:
        if not deck_card:
            continue
        var card_type = str(deck_card.type).to_lower()
        if "zombie" in card_type and deck_card.level <= 4:
            selected_card = deck_card
            break

    if not selected_card:
        print("Samurai Skull: Nenhum Zombie de Level 4 ou menor encontrado no deck do dono.")
        return

    owner_deck.erase(selected_card)
    owner_deck.shuffle()
    duel_manager.send_to_graveyard(selected_card, is_player_owner, true)
    duel_manager.update_deck_ui()
    print("Samurai Skull: Enviou ", selected_card.name, " para o cemitÃ©rio.")


func _apply_gozuki_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Gozuki: Efeito ativado - Enviar Zombie de Level 4 ou menor do deck aliado para o cemitÃ©rio")

    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Gozuki: Invocado/colocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile
    var selected_card = null

    for deck_card in owner_deck:
        if not deck_card:
            continue
        var card_type = str(deck_card.type).to_lower()
        if "zombie" in card_type and deck_card.level <= 4:
            selected_card = deck_card
            break

    if not selected_card:
        print("Gozuki: Nenhum Zombie de Level 4 ou menor encontrado no deck do dono.")
        return

    owner_deck.erase(selected_card)
    owner_deck.shuffle()
    duel_manager.send_to_graveyard(selected_card, is_player_owner, true)
    duel_manager.update_deck_ui()
    print("Gozuki: Enviou ", selected_card.name, " para o cemitÃ©rio.")


func _apply_zombie_master_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Zombie Master: Efeito ativado - Special Summon Zombie Level 4 ou menor do cemitÃ©rio")

    if not duel_manager or not slot:
        return


    if not _is_card_face_up(slot, is_player_owner):
        print("Zombie Master: Invocado/colocado face-down. Efeito nÃ£o ativa.")
        return


    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var candidates = []
    for gy_card in owner_graveyard:
        if not gy_card:
            continue
        var card_type = str(gy_card.type).to_lower()
        if "zombie" in card_type and gy_card.level <= 4:
            candidates.append(gy_card)

    if candidates.is_empty():
        print("Zombie Master: Nenhum Zombie de Level 4 ou menor encontrado no cemitÃ©rio do dono.")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null
    for owner_slot in owner_slots:
        if not owner_slot.is_occupied:
            empty_slot = owner_slot
            break

    if not empty_slot:
        print("Zombie Master: Nenhum slot vazio para invocar.")
        return


    candidates.shuffle()
    var target_card = candidates[0]
    var new_card_data = target_card.get_copy()
    owner_graveyard.erase(target_card)

    if is_player_owner:
        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
    else:
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)

    if duel_manager.has_method("spawn_card_on_field"):
        await duel_manager.spawn_card_on_field(
            new_card_data, 
            empty_slot, 
            false, 
            is_player_owner, 
            false, 
            true
        )

    print("Zombie Master: Invocou ", new_card_data.name, " do cemitÃ©rio em posiÃ§Ã£o de ataque face-up.")


func _apply_chaos_necromancer_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Chaos Necromancer: Efeito ativado - Ganha ATK por cartas no cemitÃ©rio do dono")

    if not duel_manager:
        return


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var bonus_atk = owner_graveyard.size() * CHAOS_NECROMANCER_ATK_PER_GRAVE_CARD

    card_data.atk = bonus_atk
    print("Chaos Necromancer: CemitÃ©rio com ", owner_graveyard.size(), " carta(s) -> ATK = ", card_data.atk)


    if slot and slot.spawn_point.get_child_count() > 0:
        var visual = slot.spawn_point.get_child(0)
        if visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(card_data.atk, card_data.def)


func _apply_king_of_the_skull_servants_effect(card_data: CardData, is_player_owner: bool, slot):
    print("King of the Skull Servants: Efeito ativado - Ganha ATK por IDs 803/24 no cemitÃ©rio do dono")

    if not duel_manager:
        return


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var target_count = 0

    for gy_card in owner_graveyard:
        if gy_card and (gy_card.id == KING_OF_THE_SKULL_SERVANTS_ID or gy_card.id == SKULL_SERVANT_ID):
            target_count += 1

    card_data.atk = target_count * KING_OF_THE_SKULL_SERVANTS_ATK_PER_TARGET
    print("King of the Skull Servants: ", target_count, " alvo(s) no cemitÃ©rio -> ATK = ", card_data.atk)


    if slot and slot.spawn_point.get_child_count() > 0:
        var visual = slot.spawn_point.get_child(0)
        if visual.has_method("animate_stats_bonus"):
            visual.animate_stats_bonus(card_data.atk, card_data.def)


func _apply_mushroom_man_2_effect(card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Mushroom Man #2: Efeito ativado. Contando Mushroom Man (ID 8) virados para cima...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if is_face_up and self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var mushroom_man_count = 0

    for owner_slot in owner_slots:
        if owner_slot.is_occupied:
            var current_card = owner_slot.stored_card_data
            var slot_visual = owner_slot.spawn_point.get_child(0) if owner_slot.spawn_point.get_child_count() > 0 else null

            if current_card.id == 8 and slot_visual:
                var slot_is_face_up = false
                if slot_visual.has_method("is_face_down"):
                    slot_is_face_up = not slot_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    slot_is_face_up = not duel_manager._has_card_back(slot_visual)

                if slot_is_face_up:
                    mushroom_man_count += 1

    if mushroom_man_count > 0:
        print("Mushroom Man #2: Encontrados %d Mushroom Man! Aplicando +%d ATK/DEF." % [mushroom_man_count, mushroom_man_count * 200])
        card_data.atk += mushroom_man_count * 200
        card_data.def += mushroom_man_count * 200

        if self_visual and self_visual.has_method("animate_stats_bonus"):
            self_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Mushroom Man #2: Nenhum Mushroom Man encontrado ao redor.")


func _apply_needle_worm_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Needle Worm: Efeito ativado. Preparando para enviar 5 cartas do deck do oponente ao cemitÃ©rio...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Needle Worm: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var opponent_is_player = not is_player_owner

    for _i in range(5):

        duel_manager.discard_random_card_from_opponent_deck(opponent_is_player, "Needle Worm")

    print("Needle Worm: Efeito concluÃ­do.")


func _effect_warrior_elimination(is_player_owner: bool):
    print("EffectManager: Resolvendo Warrior Elimination")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_WARRIOR_ELIMINATION:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var targets = []

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if duel_manager._is_monster(card):
                var is_face_up = false
                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

                if visual:
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up and card.type.to_lower() == "warrior":
                    targets.append(slot)

    if targets.size() > 0:
        print("Warrior Elimination: Destruindo %d Guerreiros(s) face-up no campo." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Warrior Elimination: Nenhum monstro tipo Warrior face-up encontrado no campo.")


func _effect_eradicating_aerosol(is_player_owner: bool):
    print("EffectManager: Resolvendo Eradicating Aerosol")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_ERADICATING_AEROSOL:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var targets = []

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if duel_manager._is_monster(card):
                var is_face_up = false
                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

                if visual:
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up and card.type.to_lower() == "insect":
                    targets.append(slot)

    if targets.size() > 0:
        print("Eradicating Aerosol: Destruindo %d Inseto(s) face-up no campo." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Eradicating Aerosol: Nenhum monstro tipo Insect face-up encontrado no campo.")


func _effect_breath_of_light(is_player_owner: bool):
    print("EffectManager: Resolvendo Breath of Light")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_BREATH_OF_LIGHT:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var targets = []

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if duel_manager._is_monster(card):
                var is_face_up = false
                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

                if visual:
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up and card.type.to_lower() == "rock":
                    targets.append(slot)

    if targets.size() > 0:
        print("Breath of Light: Destruindo %d Pedra(s) face-up no campo." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Breath of Light: Nenhum monstro tipo Rock face-up encontrado no campo.")


func _effect_eternal_draught(is_player_owner: bool):
    print("EffectManager: Resolvendo Eternal Draught")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_ETERNAL_DRAUGHT:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var targets = []

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if duel_manager._is_monster(card):
                var is_face_up = false
                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

                if visual:
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up and card.type.to_lower() == "fish":
                    targets.append(slot)

    if targets.size() > 0:
        print("Eternal Draught: Destruindo %d Peixe(s) face-up no campo." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Eternal Draught: Nenhum monstro tipo Fish face-up encontrado no campo.")

func _effect_sanctuary(_is_player_owner: bool):
    print("EffectManager: Ativando Sanctuary in the Sky.")

    if duel_manager:
        duel_manager.set_field_type("Sanctuary in the Sky")


func _effect_harpies_feather_duster(is_player_owner: bool):
    print("EffectManager: Resolvendo Harpie's Feather Duster")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_HARPIES_FEATHER_DUSTER:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)


    var opponent_spell_slots = duel_manager.enemy_spell_slots if is_player_owner else duel_manager.player_spell_slots
    var targets = []
    for slot in opponent_spell_slots:
        if slot.is_occupied:
            targets.append(slot)

    if targets.size() > 0:
        print("Harpie's Feather Duster: Destruindo %d carta(s) do oponente." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Harpie's Feather Duster: Oponente nÃ£o tem cartas no spell zone.")


func _effect_eternal_rest(is_player_owner: bool):
    print("EffectManager: Resolvendo Eternal Rest")

    if not duel_manager:
        return

    var magic_slot = null
    var magic_slots = duel_manager.player_spell_slots if is_player_owner else duel_manager.enemy_spell_slots
    for slot in magic_slots:
        if slot.is_occupied and slot.stored_card_data and slot.stored_card_data.id == EFFECT_ETERNAL_REST:
            magic_slot = slot
            break

    if magic_slot and magic_slot.spawn_point.get_child_count() > 0:
        var visual = magic_slot.spawn_point.get_child(0)
        await duel_manager._apply_magic_activation_glow(visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var targets = []

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if duel_manager._is_monster(card):
                var is_face_up = false
                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

                if visual:
                    if visual.has_method("is_face_down"):
                        is_face_up = not visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up:
                    var original_db_card = CardDatabase.get_card(card.id)
                    if original_db_card:

                        if card.atk > original_db_card.atk or card.def > original_db_card.def:
                            targets.append(slot)

    if targets.size() > 0:
        print("Eternal Rest: Destruindo %d monstro(s) face-up buffado(s) no campo." % targets.size())
        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)
    else:
        print("Eternal Rest: Nenhum monstro buffado face-up encontrado no campo.")


func _apply_witch_of_the_black_forest_effect(card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, _slot):
    if not duel_manager:
        return

    print("Witch of the Black Forest: Efeito ativado - Vasculhando cemitÃ©rio por monstros com DEF <= 1500...")

    var owner_gy = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile
    var gy_visual = duel_manager.player_graveyard_node if is_player_owner else duel_manager.enemy_graveyard_node


    var valid_indices = []

    for i in range(owner_gy.size()):
        var card = owner_gy[i]

        if card and duel_manager._is_monster(card):

            if card.def <= 1500:

                if card != card_data:
                    valid_indices.append(i)

    if valid_indices.size() > 0:

        var random_idx = valid_indices[randi() % valid_indices.size()]
        var card_to_return = owner_gy[random_idx]
        print("Witch of the Black Forest: Retornando ", card_to_return.name, " ao deck.")


        owner_gy.remove_at(random_idx)
        if gy_visual and gy_visual.has_method("update_graveyard"):
            gy_visual.update_graveyard(owner_gy)


        owner_deck.append(card_to_return)
        owner_deck.shuffle()
        duel_manager.update_deck_ui()
    else:
        print("Witch of the Black Forest: Nenhum monstro válido com DEF <= 1500 encontrado no cemitÃ©rio aliado (alÃ©m dela mesma).")


func _apply_weather_report_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Weather Report: Efeito ativado. Verificando se o oponente ativou Swords of Revealing Light...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Weather Report: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var opponent_has_swords = swords_enemy_active if is_player_owner else swords_player_active

    if opponent_has_swords:
        print("Weather Report: Swords of Revealing Light do oponente identificada. Encerrando efeito!")

        var is_opponent_swords = not is_player_owner
        _end_swords_effect_for(is_opponent_swords)
    else:
        print("Weather Report: Nenhuma Swords of Revealing Light inimiga em campo.")


func _apply_greenkappa_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Greenkappa: Efeito ativado. Preparando para destruir atÃ© 2 Spell/Traps do oponente...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Greenkappa: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var opponent_spells = duel_manager.enemy_spells if is_player_owner else duel_manager.player_spells


    var occupied_slots = []
    for spell_slot in opponent_spells:
        if spell_slot.is_occupied:
            occupied_slots.append(spell_slot)

    if occupied_slots.size() > 0:

        occupied_slots.shuffle()
        var targets = []

        for i in range(min(2, occupied_slots.size())):
            targets.append(occupied_slots[i])

        print("Greenkappa: Encontrou %d alvo(s) para destruir." % targets.size())

        for target_slot in targets:
            await duel_manager._destroy_card(target_slot)

        print("Greenkappa: Efeito concluÃ­do.")
    else:
        print("Greenkappa: Nenhuma Spell/Trap na zona adversÃ¡ria.")


func _apply_bladefly_effect(_card_data: CardData, _is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Bladefly: Efeito ativado. Reduzindo EARTH e aumentando WIND no campo...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Bladefly: Invocado face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var affected_count = 0

    for field_slot in all_slots:
        if field_slot.is_occupied:
            var target_card = field_slot.stored_card_data
            var target_visual = field_slot.spawn_point.get_child(0) if field_slot.spawn_point.get_child_count() > 0 else null

            if not target_visual:
                continue

            var target_is_face_up = false
            if target_visual.has_method("is_face_down"):
                target_is_face_up = not target_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                target_is_face_up = not duel_manager._has_card_back(target_visual)

            if target_is_face_up:
                var attr = target_card.attribute.to_lower()
                var changed = false

                if attr == "wind":
                    target_card.atk += 500
                    changed = true
                elif attr == "earth":
                    target_card.atk = max(0, target_card.atk - 400)
                    changed = true

                if changed:
                    affected_count += 1
                    if target_visual.has_method("animate_stats_bonus"):
                        target_visual.animate_stats_bonus(target_card.atk, target_card.def)

    print("Bladefly: Efeito concluÃ­do. Monstros afetados: ", affected_count)


func _apply_witchs_apprentice_effect(_card_data: CardData, _is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Witch's Apprentice: Efeito ativado. Reduzindo LIGHT e aumentando DARK no campo...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)

    if not is_face_up:
        print("Witch's Apprentice: Invocada face-down, efeito nÃ£o ativa.")
        return

    if self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var affected_count = 0

    for field_slot in all_slots:
        if field_slot.is_occupied:
            var target_card = field_slot.stored_card_data
            var target_visual = field_slot.spawn_point.get_child(0) if field_slot.spawn_point.get_child_count() > 0 else null

            if not target_visual:
                continue

            var target_is_face_up = false
            if target_visual.has_method("is_face_down"):
                target_is_face_up = not target_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                target_is_face_up = not duel_manager._has_card_back(target_visual)

            if target_is_face_up:
                var attr = target_card.attribute.to_lower()
                var changed = false

                if attr == "dark":
                    target_card.atk += 500
                    changed = true
                elif attr == "light":
                    target_card.atk = max(0, target_card.atk - 400)
                    changed = true

                if changed:
                    affected_count += 1
                    if target_visual.has_method("animate_stats_bonus"):
                        target_visual.animate_stats_bonus(target_card.atk, target_card.def)

    print("Witch's Apprentice: Efeito concluÃ­do. Monstros afetados: ", affected_count)


func _apply_electric_lizard_effect(_defender_card: CardData, _is_player_owner: bool, defender_slot, attacker_card: CardData, attacker_slot):
    print("Electric Lizard: Atacado. Verificando tipo do atacante...")


    if attacker_card.type == "Zombie":
        print("Electric Lizard: Atacante Ã© Zumbi! Reduzindo ATK pela metade.")


        var defender_visual = defender_slot.spawn_point.get_child(0) if defender_slot.spawn_point.get_child_count() > 0 else null
        if defender_visual:
            await duel_manager._apply_magic_activation_glow(defender_visual)


        attacker_card.atk = int(attacker_card.atk / 2.0)


        var attacker_visual = attacker_slot.spawn_point.get_child(0) if attacker_slot.spawn_point.get_child_count() > 0 else null
        if attacker_visual:

            if typeof(attacker_visual) == TYPE_OBJECT and attacker_visual.has_method("show_stat_down"):
                attacker_visual.show_stat_down()

            if typeof(attacker_visual) == TYPE_OBJECT and attacker_visual.has_method("animate_stats_bonus"):

                await get_tree().create_timer(0.3).timeout
                attacker_visual.animate_stats_bonus(attacker_card.atk, attacker_card.def)

        print("Electric Lizard: Novo ATK do Zumbi atacante: ", attacker_card.atk)
    else:
        print("Electric Lizard: Atacante nÃ£o Ã© Zumbi (" + str(attacker_card.type) + "). O efeito nÃ£o ativa.")


func _apply_electric_snake_effect(card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Electric Snake: Invocado. Verificando bÃ´nus por monstros do tipo Thunder...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null


    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)


    if is_face_up and self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var thunder_count = 0

    for owner_slot in owner_slots:
        if not owner_slot.is_occupied:
            continue

        var current_card = owner_slot.stored_card_data
        if not current_card or current_card.type != "Thunder":
            continue





        var iter_visual = owner_slot.spawn_point.get_child(0) if owner_slot.spawn_point.get_child_count() > 0 else null
        var iter_is_face_up = false

        if iter_visual:
            if iter_visual.has_method("is_face_down"):
                iter_is_face_up = not iter_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                iter_is_face_up = not duel_manager._has_card_back(iter_visual)

        if iter_is_face_up:
            thunder_count += 1


    if thunder_count > 0:
        var total_bonus = 200 * thunder_count
        print("Electric Snake: Encontrou %d monstro(s) Thunder face-up. Ganhando +%d ATK/DEF" % [thunder_count, total_bonus])

        card_data.atk += total_bonus
        card_data.def += total_bonus


        if is_face_up and self_visual and self_visual.has_method("animate_stats_bonus"):
            self_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Electric Snake: Nenhum monstro Thunder face-up encontrado para bÃ´nus.")


func _apply_steel_scorpion_effect(card_data: CardData, _is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Steel Scorpion: Invocado. Verificando bÃ´nus por monstros do tipo Machine no campo inteiro...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null


    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)


    if is_face_up and self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var machine_count = 0

    for board_slot in all_slots:
        if not board_slot.is_occupied:
            continue

        var current_card = board_slot.stored_card_data
        if not current_card or current_card.type != "Machine":
            continue



        var iter_visual = board_slot.spawn_point.get_child(0) if board_slot.spawn_point.get_child_count() > 0 else null
        var iter_is_face_up = false

        if iter_visual:
            if iter_visual.has_method("is_face_down"):
                iter_is_face_up = not iter_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                iter_is_face_up = not duel_manager._has_card_back(iter_visual)

        if iter_is_face_up:
            machine_count += 1


    if machine_count > 0:
        var total_bonus = 200 * machine_count
        print("Steel Scorpion: Encontrou %d monstro(s) Machine face-up no campo inteiro. Ganhando +%d ATK/DEF" % [machine_count, total_bonus])

        card_data.atk += total_bonus
        card_data.def += total_bonus


        if is_face_up and self_visual and self_visual.has_method("animate_stats_bonus"):
            self_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Steel Scorpion: Nenhum monstro Machine face-up encontrado para bÃ´nus.")


func _apply_goddess_of_whim_effect(card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Goddess of Whim: Invocada. Verificando ativaÃ§Ã£o...")


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Goddess of Whim: Invocada face-down, efeito da roleta nÃ£o ativa.")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    print("Goddess of Whim: Roldando a roleta!")


    var final_number = await _show_number_roulette(is_player_owner)


    if final_number % 2 == 0:
        print("Goddess of Whim: PAR! ATK dobrado.")
        card_data.atk *= 2
    else:
        print("Goddess of Whim: ÃMPAR! ATK reduzido pela metade.")
        card_data.atk = int(card_data.atk / 2.0)


    if card_visual and card_visual.has_method("animate_stats_bonus"):
        card_visual.animate_stats_bonus(card_data.atk, card_data.def)


func _apply_maha_vailo_effect(card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Maha Vailo: Invocado. Verificando cemitÃ©rio do dono...")


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


    if is_face_up and card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var gy = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var equip_count = 0
    for card in gy:
        if card.type == "Equip" or (card.category == CardData.CardCategory.MAGIC and card.type == "Equip"):
            equip_count += 1

    var bonus = equip_count * 300

    if bonus > 0:
        print("Maha Vailo: Encontrou %d cartas Equip no cemitÃ©rio. Ganha +%d ATK." % [equip_count, bonus])
        card_data.atk += bonus


        if is_face_up and card_visual and card_visual.has_method("animate_stats_bonus"):
            card_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Maha Vailo: Nenhuma carta Equip encontrada no cemitÃ©rio. Nenhum bÃ´nus.")

func _apply_machine_king_effect(card_data: CardData, _is_player_owner: bool, slot):
    if not duel_manager or not slot:
        return

    print("Machine King: Invocado. Verificando bÃ´nus por monstros do tipo Machine no campo inteiro...")


    var is_face_up = false
    var self_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null


    if self_visual:
        if self_visual.has_method("is_face_down"):
            is_face_up = not self_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(self_visual)


    if is_face_up and self_visual:
        await duel_manager._apply_magic_activation_glow(self_visual)


    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var machine_count = 0

    for board_slot in all_slots:
        if not board_slot.is_occupied:
            continue

        var current_card = board_slot.stored_card_data
        if not current_card or current_card.type != "Machine":
            continue

        var iter_visual = board_slot.spawn_point.get_child(0) if board_slot.spawn_point.get_child_count() > 0 else null
        var iter_is_face_up = false

        if iter_visual:
            if iter_visual.has_method("is_face_down"):
                iter_is_face_up = not iter_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                iter_is_face_up = not duel_manager._has_card_back(iter_visual)

        if iter_is_face_up:
            machine_count += 1


    if machine_count > 0:
        var total_bonus = 100 * machine_count
        print("Machine King: Encontrou %d monstro(s) Machine face-up no campo inteiro. Ganhando +%d ATK/DEF" % [machine_count, total_bonus])

        card_data.atk += total_bonus
        card_data.def += total_bonus


        if is_face_up and self_visual and self_visual.has_method("animate_stats_bonus"):
            self_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Machine King: Nenhum monstro Machine face-up encontrado para bÃ´nus.")

func _apply_sangan_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Sangan: Efeito ativado - Ganha bÃ´nus por monstros fracos no deck")

    if not duel_manager:
        return


    var grave_array = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var weak_monster_count = 0
    for card in grave_array:
        if card.category != CardData.CardCategory.MAGIC and card.category != CardData.CardCategory.TRAP:
            if card and card.atk <= 1000:
                weak_monster_count += 1


    var bonus = weak_monster_count * SANGAN_BONUS_PER_WEAK_MONSTER

    print("Sangan: ", weak_monster_count, " monstros fracos no cemitÃ©rio â†’ +", bonus, " ATK/DEF")
    print("Total cartas no cemitÃ©rio: ", grave_array.size())


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data

        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual.has_method("animate_stats_bonus"):
                card_visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Sangan: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

func _apply_mask_of_darkness_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Mask of Darkness: Efeito ativado - Ganha bÃ´nus por Mask of Darkness no deck")

    if not duel_manager:
        return


    var deck_array = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var mask_count = 0
    for card in deck_array:
        if card and _is_mask_of_darkness_monster(card):
            mask_count += 1


    var bonus = mask_count * MASK_BONUS_PER_FIEND

    print("Mask of Darkness: ", mask_count, " monstros Fiend no deck â†’ +", bonus, " ATK/DEF")
    print("Total cartas no deck: ", deck_array.size())


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data

        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual.has_method("animate_stats_bonus"):
                card_visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Mask of Darkness: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

func _is_mask_of_darkness_monster(card: CardData) -> bool:

    if not card:
        return false


    if duel_manager.has_method("_is_monster"):
        if not duel_manager._is_monster(card):
            return false


    return card.id == 102

func _apply_sinister_serpent_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Sinister Serpent: Efeito ativado - Ganha bÃ´nus por Sinister Serpent no deck")

    if not duel_manager:
        return


    var deck_array = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var sinister_serpent_count = 0
    for card in deck_array:
        if card and _is_sinister_serpent_monster(card):
            sinister_serpent_count += 1


    var bonus = sinister_serpent_count * SINISTER_SERPENT_BONUS_PER_COPY

    print("Sinister Serpent: ", sinister_serpent_count, " monstros Sinister Serpent no deck â†’ +", bonus, " ATK/DEF")
    print("Total cartas no deck: ", deck_array.size())


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data

        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)
            if card_visual.has_method("animate_stats_bonus"):
                card_visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Sinister Serpent: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

func _is_sinister_serpent_monster(card: CardData) -> bool:

    if not card:
        return false


    if duel_manager.has_method("_is_monster"):
        if not duel_manager._is_monster(card):
            return false


    return card.id == 475

func _apply_dragon_piper_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Dragon Piper: Efeito ativado - DestrÃ³i DragÃµes do oponente com 1500 ATK ou menos")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Crass Clown: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var opponent_slots = duel_manager.player_slots if opponent_is_player else duel_manager.enemy_slots


    var slots_to_destroy = []


    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var is_dragon = false
            is_dragon = "Dragon" in opponent_card.type or "dragon" in opponent_card.type.to_lower() or "DRAGON" in opponent_card.type

            if is_dragon:

                var is_face_up_opponent = false
                var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else null

                if opponent_visual:
                    if opponent_visual.has_method("is_face_down"):
                        is_face_up_opponent = not opponent_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up_opponent = not duel_manager._has_card_back(opponent_visual)


                if is_face_up_opponent and opponent_card.atk <= 1500:
                    print("  - Encontrado DragÃ£o para destruir: ", opponent_card.name, 
                          " (ATK: ", opponent_card.atk, ", Face-up: ", is_face_up_opponent, ")")
                    slots_to_destroy.append(opponent_slot)


    if slots_to_destroy.size() > 0:
        print("Dragon Piper: Destruindo ", slots_to_destroy.size(), " dragÃ£o(ns) do oponente")

        for target_slot in slots_to_destroy:

            await duel_manager._destroy_card(target_slot)
            await get_tree().create_timer(0.2).timeout

        print("Dragon Piper: Todos os dragÃµes foram destruÃ­dos")
    else:
        print("Dragon Piper: Nenhum dragÃ£o do oponente atende aos critÃ©rios")

func _apply_catapult_turtle_effect(attacker_card_data: CardData, attacker_is_player_owner: bool, attacker_slot):
    print("Catapult Turtle: Efeito ativado - Causa 500 de dano ao oponente ao atacar")

    if not duel_manager:
        return


    var opponent_is_player = not attacker_is_player_owner


    if opponent_is_player:

        duel_manager.player_lp -= CATAPULT_TURTLE_DAMAGE
        print("Catapult Turtle da IA causa ", CATAPULT_TURTLE_DAMAGE, " de dano ao Jogador")
    else:

        duel_manager.enemy_lp -= CATAPULT_TURTLE_DAMAGE
        print("Catapult Turtle do Jogador causa ", CATAPULT_TURTLE_DAMAGE, " de dano Ã  IA")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_crass_clown_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Crass Clown: Efeito ativado - DestrÃ³i monstro aleatÃ³rio do oponente com 1000 ATK ou menos")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Crass Clown: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var opponent_slots = duel_manager.player_slots if opponent_is_player else duel_manager.enemy_slots


    var valid_targets = []


    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var is_opponent_face_up = false
            var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else null

            if opponent_visual:
                if opponent_visual.has_method("is_face_down"):
                    is_opponent_face_up = not opponent_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_opponent_face_up = not duel_manager._has_card_back(opponent_visual)


            if is_opponent_face_up and opponent_card.atk <= CRASS_CLOWN_MAX_ATK:
                print("  - Alvo válido encontrado: ", opponent_card.name, 
                      " (ATK: ", opponent_card.atk, ", Face-up: ", is_opponent_face_up, ")")
                valid_targets.append(opponent_slot)


    if valid_targets.size() == 0:
        print("Crass Clown: Nenhum monstro do oponente atende aos critÃ©rios")
        return


    var random_index = randi() % valid_targets.size()
    var target_slot = valid_targets[random_index]
    var target_card = target_slot.stored_card_data

    print("Crass Clown: Escolhido alvo aleatÃ³rio - ", target_card.name, 
          " (ATK: ", target_card.atk, ")")


    print("Crass Clown: Destruindo ", target_card.name)
    await duel_manager._destroy_card(target_slot)

func _apply_dream_clown_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Dream Clown: Efeito ativado - DestrÃ³i monstro aleatÃ³rio do oponente com 1000 ATK ou menos")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Dream Clown: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    var opponent_slots = duel_manager.player_slots if opponent_is_player else duel_manager.enemy_slots


    var valid_targets = []


    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var is_opponent_face_up = false
            var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else null

            if opponent_visual:
                if opponent_visual.has_method("is_face_down"):
                    is_opponent_face_up = not opponent_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_opponent_face_up = not duel_manager._has_card_back(opponent_visual)


            if is_opponent_face_up and opponent_card.atk <= DREAM_CLOWN_MAX_ATK:
                print("  - Alvo válido encontrado: ", opponent_card.name, 
                      " (ATK: ", opponent_card.atk, ", Face-up: ", is_opponent_face_up, ")")
                valid_targets.append(opponent_slot)


    if valid_targets.size() == 0:
        print("Dream Clown: Nenhum monstro do oponente atende aos critÃ©rios")
        return


    var random_index = randi() % valid_targets.size()
    var target_slot = valid_targets[random_index]
    var target_card = target_slot.stored_card_data

    print("Dream Clown: Escolhido alvo aleatÃ³rio - ", target_card.name, 
          " (ATK: ", target_card.atk, ")")


    print("Dream Clown: Destruindo ", target_card.name)
    await duel_manager._destroy_card(target_slot)

func _apply_tainted_wisdom_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Tainted Wisdom: Efeito ativado - Oponente descarta uma carta aleatÃ³ria da mÃ£o")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Tainted Wisdom: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_is_player = not is_player_owner


    if duel_manager.has_method("discard_random_opponent_card"):
        await duel_manager.discard_random_opponent_card(opponent_is_player)
    else:
        print("ERRO: DuelManager nÃ£o tem mÃ©todo discard_random_opponent_card!")

func _apply_mysterious_puppeteer_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Mysterious Puppeteer: Efeito ativado - Ganha 500 LP por cada monstro que o oponente controla")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Mysterious Puppeteer: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var opponent_monster_count = 0

    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            opponent_monster_count += 1
            print("  - Encontrado monstro do oponente: ", opponent_slot.stored_card_data.name)


    var heal_amount = opponent_monster_count * MYSTERIOUS_PUPPETEER_HEAL_PER_MONSTER

    print("Mysterious Puppeteer: ", opponent_monster_count, " monstro(s) do oponente â†’ +", heal_amount, " LP")


    print("Mysterious Puppeteer: ", "Jogador" if is_player_owner else "IA", " ganha ", heal_amount, " pontos de vida")
    await duel_manager.heal_lp(is_player_owner, heal_amount)


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_big_eye_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Big Eye: Efeito ativado - Revela um monstro aleatÃ³rio do oponente que esteja face-down")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Big Eye: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var face_down_monsters = []

    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else 0

            if opponent_visual:
                var is_opponent_face_down = false


                if opponent_visual.has_method("is_face_down"):
                    is_opponent_face_down = opponent_visual.is_face_down()


                elif duel_manager.has_method("_has_card_back"):
                    is_opponent_face_down = duel_manager._has_card_back(opponent_visual)

                if is_opponent_face_down:
                    face_down_monsters.append(opponent_slot)
                    print("  - Encontrado monstro face-down: ", opponent_card.name)


    if face_down_monsters.size() == 0:
        print("Big Eye: Nenhum monstro face-down do oponente encontrado")
        return


    var random_index = randi() % face_down_monsters.size()
    var target_slot = face_down_monsters[random_index]
    var target_card = target_slot.stored_card_data

    print("Big Eye: Escolhido para revelar - ", target_card.name)


    if is_player_owner:

        if duel_manager.has_method("reveal_enemy_card_in_slot"):
            duel_manager.reveal_enemy_card_in_slot(target_slot)
    else:

        if duel_manager.has_method("reveal_player_card_in_slot"):
            duel_manager.reveal_player_card_in_slot(target_slot)

    print("Big Eye: Monstro revelado com sucesso!")

func _apply_patrol_robo_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Patrol Robo: Efeito ativado - Revela um monstro aleatÃ³rio do oponente que esteja face-down")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Patrol Robo: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var face_down_monsters = []

    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else 0

            if opponent_visual:
                var is_opponent_face_down = false


                if opponent_visual.has_method("is_face_down"):
                    is_opponent_face_down = opponent_visual.is_face_down()


                elif duel_manager.has_method("_has_card_back"):
                    is_opponent_face_down = duel_manager._has_card_back(opponent_visual)

                if is_opponent_face_down:
                    face_down_monsters.append(opponent_slot)
                    print("  - Encontrado monstro face-down: ", opponent_card.name)


    if face_down_monsters.size() == 0:
        print("Patrol RObo: Nenhum monstro face-down do oponente encontrado")
        return


    var random_index = randi() % face_down_monsters.size()
    var target_slot = face_down_monsters[random_index]
    var target_card = target_slot.stored_card_data

    print("Patrol Robo: Escolhido para revelar - ", target_card.name)


    if is_player_owner:

        if duel_manager.has_method("reveal_enemy_card_in_slot"):
            duel_manager.reveal_enemy_card_in_slot(target_slot)
    else:

        if duel_manager.has_method("reveal_player_card_in_slot"):
            duel_manager.reveal_player_card_in_slot(target_slot)

    print("Patrol Robo: Monstro revelado com sucesso!")

func _apply_penguin_knight_effect(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool, slot):
    print("Penguin Knight: Efeito ativado - Metade das cartas do cemitÃ©rio volta para o deck")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile

    print("Penguin Knight: CemitÃ©rio tem ", graveyard.size(), " cartas")


    if graveyard.size() == 0:
        print("Penguin Knight: CemitÃ©rio vazio, efeito nÃ£o aplicado")
        return


    var half_count = floor(graveyard.size() / 2.0)

    if half_count <= 0:
        print("Penguin Knight: Metade calculada Ã© 0 ou negativa")
        return

    print("Penguin Knight: Retornando ", half_count, " cartas para o deck")


    var cards_to_return = []
    for i in range(half_count):
        if i < graveyard.size():
            cards_to_return.append(graveyard[i])


    for i in range(half_count):
        if graveyard.size() > 0:
            graveyard.remove_at(0)


    for card in cards_to_return:
        deck.append(card)
        print("  - Retornando para o deck: ", card.name)


    if is_player_owner:

        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:

        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Penguin Knight: Efeito concluÃ­do! ", half_count, " cartas retornadas ao deck")

func _apply_wodan_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Wodan the Resident of the Forest: Efeito ativado - Ganha +100 ATK por cada monstro Plant face-up no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var plant_count = 0


    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot == slot:
                continue

            var monster_data = owner_slot.stored_card_data


            var is_plant = false
            is_plant = "Plant" in monster_data.type or "plant" in monster_data.type.to_lower() or "PLANT" in monster_data.type

            if is_plant:

                var is_face_up = false
                var monster_visual = owner_slot.spawn_point.get_child(0) if owner_slot.spawn_point.get_child_count() > 0 else null

                if monster_visual:
                    if monster_visual.has_method("is_face_down"):
                        is_face_up = not monster_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(monster_visual)

                if is_face_up:
                    plant_count += 1
                    print("  - Plant face-up do dono: ", monster_data.name)


    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var monster_data = opponent_slot.stored_card_data


            var is_plant = false
            is_plant = "Plant" in monster_data.type or "plant" in monster_data.type.to_lower() or "PLANT" in monster_data.type

            if is_plant:

                var is_face_up = false
                var monster_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else null

                if monster_visual:
                    if monster_visual.has_method("is_face_down"):
                        is_face_up = not monster_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_face_up = not duel_manager._has_card_back(monster_visual)

                if is_face_up:
                    plant_count += 1
                    print("  - Plant face-up do oponente: ", monster_data.name)


    var bonus = plant_count * WODAN_PLANT_BONUS

    print("Wodan: ", plant_count, " Plant(s) face-up no campo â†’ +", bonus, " ATK")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Wodan the Resident of the Forest: Novo ATK = ", monster_data.atk)

func _apply_princess_of_tsurugi_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Princess of Tsurugi: Efeito ativado - Causa 500 de dano por cada Spell Slot ocupado do oponente")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Princess of Tsurugi: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_spell_slots = duel_manager.enemy_spell_slots if is_player_owner else duel_manager.player_spell_slots


    var occupied_spell_count = 0

    for spell_slot in opponent_spell_slots:
        if spell_slot.is_occupied and spell_slot.stored_card_data:
            occupied_spell_count += 1
            print("  - Spell Slot ocupado: ", spell_slot.stored_card_data.name)


    var total_damage = occupied_spell_count * PRINCESS_OF_TSURUGI_DAMAGE

    print("Princess of Tsurugi: ", occupied_spell_count, " Spell Slot(s) ocupado(s) â†’ ", total_damage, " de dano")

    if total_damage <= 0:
        print("Princess of Tsurugi: Nenhum Spell Slot ocupado, sem dano")
        return


    if is_player_owner:

        duel_manager.enemy_lp -= total_damage
        print("Princess of Tsurugi do Jogador causa ", total_damage, " de dano Ã  IA")
    else:

        duel_manager.player_lp -= total_damage
        print("Princess of Tsurugi da IA causa ", total_damage, " de dano ao Jogador")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _effect_polymerization(is_player_owner: bool):
    print("Polymerization: Efeito ativado - Invoca um monstro FUSION aleatÃ³rio do deck")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return


    var FUSION_CATEGORY = CardData.CardCategory.FUSION_MONSTER


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile

    print("Polymerization: Procurando monstros FUSION no deck...")
    print("Tamanho do deck: ", owner_deck.size())


    var fusion_monsters = []
    var fusion_indices = []

    for i in range(owner_deck.size()):
        var card = owner_deck[i]
        if card and card.category == FUSION_CATEGORY:
            fusion_monsters.append(card)
            fusion_indices.append(i)
            print("  - Encontrado monstro FUSION: ", card.name, " (ATK: ", card.atk, ", DEF: ", card.def, ")")


    if fusion_monsters.size() == 0:
        print("Polymerization: Nenhum monstro FUSION encontrado no deck!")
        return


    var random_index = randi() % fusion_monsters.size()
    var selected_fusion = fusion_monsters[random_index]
    var deck_index_to_remove = fusion_indices[random_index]

    print("Polymerization: Selecionado - ", selected_fusion.name)


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if empty_slot == null:
        print("Polymerization: Nenhum slot de monstro vazio disponÃ­vel!")
        return


    owner_deck.remove_at(deck_index_to_remove)
    print("Polymerization: Monstro removido do deck")


    if is_player_owner:
        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:
        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()


    print("Polymerization: Colocando monstro FUSION no campo...")


    if duel_manager.has_method("spawn_card_on_field"):
        await duel_manager.spawn_card_on_field(
            selected_fusion, 
            empty_slot, 
            false, 
            is_player_owner, 
            false, 
            true
        )
        print("Polymerization: Monstro FUSION colocado no campo via spawn_card_on_field")
    else:

        print("ERRO: DuelManager nÃ£o tem mÃ©todo spawn_card_on_field!")
        return

    print("Polymerization: Efeito concluÃ­do com sucesso!")

func _apply_shadow_ghoul_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Shadow Ghoul: Efeito ativado - Ganha +100 ATK por cada carta no cemitÃ©rio do dono")

    if not duel_manager:
        return



    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var graveyard_count = owner_graveyard.size()

    print("Shadow Ghoul: CemitÃ©rio tem ", graveyard_count, " carta(s)")


    var bonus = graveyard_count * SHADOW_GHOUL_BONUS

    print("Shadow Ghoul: ", graveyard_count, " carta(s) no cemitÃ©rio â†’ +", bonus, " ATK")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Shadow Ghoul: Novo ATK = ", monster_data.atk)

func _apply_shadow_wall_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Shadow Wall: Efeito ativado - Ganha +100 DEF por cada carta no cemitÃ©rio do dono")

    if not duel_manager:
        return



    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var graveyard_count = owner_graveyard.size()

    print("Shadow Wall: CemitÃ©rio tem ", graveyard_count, " carta(s)")


    var bonus = graveyard_count * SHADOW_WALL_BONUS

    print("Shadow Wall: ", graveyard_count, " carta(s) no cemitÃ©rio â†’ +", bonus, " DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Shadow Ghoul: Novo DEF = ", monster_data.def)

func _apply_milus_radiant_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Milus Radiant: Efeito ativado - Afeta todos os monstros Earth e Wind no campo")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Milus Radiant: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var all_slots = []
    all_slots.append_array(duel_manager.player_slots)
    all_slots.append_array(duel_manager.enemy_slots)

    var earth_count = 0
    var wind_count = 0


    for target_slot in all_slots:
        if target_slot.is_occupied and target_slot.stored_card_data:



            var monster_data = target_slot.stored_card_data
            var monster_attribute = monster_data.attribute.to_lower() if monster_data.attribute else ""


            if monster_attribute == "earth":
                earth_count += 1
                monster_data.atk += MILUS_RADIANT_EARTH_BONUS
                print("  - +500 ATK para ", monster_data.name, " (Earth)")


            elif monster_attribute == "wind":
                wind_count += 1
                monster_data.atk += MILUS_RADIANT_WIND_PENALTY
                print("  - -400 ATK para ", monster_data.name, " (Wind)")


            if target_slot.spawn_point.get_child_count() > 0:
                var visual = target_slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(monster_data.atk, monster_data.def)

func _apply_blue_eyes_starlord_dragon_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Blue-Eyes Starlord Dragon: Efeito ativado - Invoca um Blue-Eyes White Dragon do deck")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Blue-Eyes Starlord Dragon: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile

    print("Blue-Eyes Starlord Dragon: Procurando Blue-Eyes White Dragon (ID 1) no deck...")


    var target_card_index = -1
    var target_card_data = null

    for i in range(owner_deck.size()):
        var card = owner_deck[i]
        if card and card.id == 1:
            target_card_index = i
            target_card_data = card
            break

    if target_card_index == -1:
        print("Blue-Eyes Starlord Dragon: Nenhum Blue-Eyes White Dragon encontrado no deck!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for s in owner_slots:
        if not s.is_occupied:
            empty_slot = s
            break

    if empty_slot == null:
        print("Blue-Eyes Starlord Dragon: Nenhum slot de monstro vazio disponÃ­vel!")
        return


    owner_deck.remove_at(target_card_index)
    print("Blue-Eyes Starlord Dragon: Carta ID 1 removida do deck")


    if duel_manager.has_method("update_deck_ui"):
        duel_manager.update_deck_ui()


    print("Blue-Eyes Starlord Dragon: Colocando Blue-Eyes White Dragon no campo...")

    if duel_manager.has_method("spawn_card_on_field"):
        await duel_manager.spawn_card_on_field(
            target_card_data, 
            empty_slot, 
            false, 
            is_player_owner, 
            false, 
            true
        )

    print("Blue-Eyes Starlord Dragon: Efeito concluÃ­do com sucesso!")

func _apply_cannon_soldier_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Cannon Soldier: Efeito ativado - Causa 500 de dano ao oponente")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Cannon Soldier: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    if is_player_owner:

        duel_manager.enemy_lp -= CANNON_SOLDIER_DAMAGE
        print("Cannon Soldier do Jogador causa ", CANNON_SOLDIER_DAMAGE, " de dano Ã  IA")
    else:

        duel_manager.player_lp -= CANNON_SOLDIER_DAMAGE
        print("Cannon Soldier da IA causa ", CANNON_SOLDIER_DAMAGE, " de dano ao Jogador")


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

    print("Cannon Soldier: Efeito concluÃ­do!")

func _apply_sanga_of_the_thunder_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Sanga of The Thunder: Efeito ativado - Verifica componentes do Gate Guardian no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var has_kazejin = false
    var has_sujin = false

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot == slot:
                continue

            var monster_data = owner_slot.stored_card_data


            if monster_data.id == 372:
                has_kazejin = true
                print("  - Kazejin (ID 372) encontrado no campo")


            if monster_data.id == 373:
                has_sujin = true
                print("  - Sujin (ID 373) encontrado no campo")


    var atk_bonus = 0
    var def_bonus = 0

    if has_kazejin:
        atk_bonus += 200
        print("Sanga: Tem Kazejin â†’ +200 ATK")

    if has_sujin:
        def_bonus += 200
        print("Sanga: Tem Sujin â†’ +200 DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += atk_bonus
        monster_data.def += def_bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Sanga of The Thunder: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

    print("Sanga of The Thunder: Efeito concluÃ­do")

func _apply_kazejin_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Kazejin: Efeito ativado - Verifica componentes do Gate Guardian no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var has_sanga = false
    var has_sujin = false

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot == slot:
                continue

            var monster_data = owner_slot.stored_card_data


            if monster_data.id == 371:
                has_sanga = true
                print("  - Sanga of the Thunder (ID 371) encontrado no campo")


            if monster_data.id == 373:
                has_sujin = true
                print("  - Sujin (ID 373) encontrado no campo")


    var atk_bonus = 0
    var def_bonus = 0

    if has_sanga:
        atk_bonus += 200
        print("Kazejin: Tem Sanga of the Thunder â†’ +200 ATK")

    if has_sujin:
        def_bonus += 200
        print("Sanga: Tem Sujin â†’ +200 DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += atk_bonus
        monster_data.def += def_bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Kazejin: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

    print("Kazejin: Efeito concluÃ­do")

func _apply_suijin_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Suijin: Efeito ativado - Verifica componentes do Gate Guardian no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var has_sanga = false
    var has_kazejin = false

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot == slot:
                continue

            var monster_data = owner_slot.stored_card_data


            if monster_data.id == 371:
                has_sanga = true
                print("  - Sanga of the Thunder (ID 371) encontrado no campo")


            if monster_data.id == 372:
                has_kazejin = true
                print("  - Suijin (ID 372) encontrado no campo")


    var atk_bonus = 0
    var def_bonus = 0

    if has_sanga:
        atk_bonus += 200
        print("Suijin: Tem Sanga of the Thunder â†’ +200 ATK")

    if has_kazejin:
        def_bonus += 200
        print("Suijin: Tem Kazejin â†’ +200 DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += atk_bonus
        monster_data.def += def_bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Suijin: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

    print("Suijin: Efeito concluÃ­do")

func _apply_gate_guardian_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Gate Guardian: Efeito ativado - Verifica se os 3 componentes estÃ£o no cemitÃ©rio")

    if not duel_manager:
        return



    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var has_sanga = false
    var has_kazejin = false
    var has_sujin = false

    for card_in_grave in owner_graveyard:
        if card_in_grave:

            if card_in_grave.id == 371:
                has_sanga = true
                print("  - Sanga of The Thunder (ID 371) encontrado no cemitÃ©rio")


            if card_in_grave.id == 372:
                has_kazejin = true
                print("  - Kazejin (ID 372) encontrado no cemitÃ©rio")


            if card_in_grave.id == 373:
                has_sujin = true
                print("  - Sujin (ID 373) encontrado no cemitÃ©rio")


    var has_all_components = has_sanga and has_kazejin and has_sujin

    if has_all_components:
        print("Gate Guardian: TODOS os 3 componentes estÃ£o no cemitÃ©rio! Ganha +500 ATK/DEF")


        if slot and slot.stored_card_data:
            var monster_data = slot.stored_card_data


            monster_data.atk += GATE_GUARDIAN_FULL_BONUS
            monster_data.def += GATE_GUARDIAN_FULL_BONUS


            if slot.spawn_point.get_child_count() > 0:
                var visual = slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(monster_data.atk, monster_data.def)

            print("Gate Guardian: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)
    else:

        print("Gate Guardian: Faltam componentes no cemitÃ©rio:")
        if not has_sanga:
            print("  - Sanga of The Thunder (ID 371)")
        if not has_kazejin:
            print("  - Kazejin (ID 372)")
        if not has_sujin:
            print("  - Sujin (ID 373)")
        print("Gate Guardian: Sem bÃ´nus (nÃ£o tem todos os 3 componentes no cemitÃ©rio)")

    print("Gate Guardian: Efeito concluÃ­do")

func _effect_remove_trap(is_player_owner: bool):
    print("Remove Trap: Efeito ativado - DestrÃ³i uma carta aleatÃ³ria nos spell slots do oponente")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return


    var opponent_spell_slots = duel_manager.enemy_spell_slots if is_player_owner else duel_manager.player_spell_slots

    print("Remove Trap: Verificando spell slots do oponente...")


    var occupied_spell_slots = []

    for spell_slot in opponent_spell_slots:
        if spell_slot.is_occupied and spell_slot.stored_card_data:
            occupied_spell_slots.append(spell_slot)
            print("  - Spell Slot ocupado: ", spell_slot.stored_card_data.name)


    if occupied_spell_slots.size() == 0:
        print("Remove Trap: Nenhum spell slot ocupado do oponente encontrado!")
        return


    var random_index = randi() % occupied_spell_slots.size()
    var target_slot = occupied_spell_slots[random_index]
    var target_card = target_slot.stored_card_data

    print("Remove Trap: Selecionado para destruir - ", target_card.name)


    if duel_manager.has_method("_destroy_card"):
        print("Remove Trap: Destruindo carta...")
        await duel_manager._destroy_card(target_slot)
    else:

        print("Remove Trap: Usando fallback para destruir carta")


        if target_slot.spawn_point.get_child_count() > 0:
            for child in target_slot.spawn_point.get_children():
                child.queue_free()


        var opponent_is_player = not is_player_owner
        duel_manager.send_to_graveyard(target_card, opponent_is_player)


        target_slot.is_occupied = false
        target_slot.stored_card_data = null

        if is_player_owner:

            if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
                duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
        else:

            if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
                duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)

    print("Remove Trap: Efeito concluÃ­do com sucesso!")

func _effect_de_spell(is_player_owner: bool):
    print("De-Spell: Efeito ativado - DestrÃ³i uma carta aleatÃ³ria nos spell slots do oponente")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return


    var opponent_spell_slots = duel_manager.enemy_spell_slots if is_player_owner else duel_manager.player_spell_slots

    print("De-Spell: Verificando spell slots do oponente...")


    var occupied_spell_slots = []

    for spell_slot in opponent_spell_slots:
        if spell_slot.is_occupied and spell_slot.stored_card_data:
            occupied_spell_slots.append(spell_slot)
            print("  - Spell Slot ocupado: ", spell_slot.stored_card_data.name)


    if occupied_spell_slots.size() == 0:
        print("De-Spell: Nenhum spell slot ocupado do oponente encontrado!")
        return


    var random_index = randi() % occupied_spell_slots.size()
    var target_slot = occupied_spell_slots[random_index]
    var target_card = target_slot.stored_card_data

    print("De-Spell: Selecionado para destruir - ", target_card.name)


    if duel_manager.has_method("_destroy_card"):
        print("De-Spell: Destruindo carta...")
        await duel_manager._destroy_card(target_slot)
    else:

        print("De-Spell: Usando fallback para destruir carta")


        if target_slot.spawn_point.get_child_count() > 0:
            for child in target_slot.spawn_point.get_children():
                child.queue_free()


        var opponent_is_player = not is_player_owner
        duel_manager.send_to_graveyard(target_card, opponent_is_player)


        target_slot.is_occupied = false
        target_slot.stored_card_data = null

        if is_player_owner:

            if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
                duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
        else:

            if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
                duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)

    print("De-Spell: Efeito concluÃ­do com sucesso!")

func _effect_twister(is_player_owner: bool):
    print("Twister: Efeito ativado - Dono perde 500 LP e destrÃ³i 1 Spell/Trap aleatÃ³ria do oponente")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return


    if is_player_owner:
        duel_manager.player_lp -= TWISTER_LP_COST
        print("Twister: Jogador perde ", TWISTER_LP_COST, " LP")
    else:
        duel_manager.enemy_lp -= TWISTER_LP_COST
        print("Twister: Inimigo perde ", TWISTER_LP_COST, " LP")

    duel_manager.update_lp_ui()


    var opponent_spell_slots = duel_manager.enemy_spell_slots if is_player_owner else duel_manager.player_spell_slots
    var occupied_spell_slots = []

    for spell_slot in opponent_spell_slots:
        if spell_slot.is_occupied and spell_slot.stored_card_data:
            occupied_spell_slots.append(spell_slot)

    if occupied_spell_slots.size() == 0:
        print("Twister: Oponente nÃ£o tem Spell/Trap para destruir.")
        return

    var random_index = randi() % occupied_spell_slots.size()
    var target_slot = occupied_spell_slots[random_index]
    var target_card = target_slot.stored_card_data

    print("Twister: Destruindo ", target_card.name)

    if duel_manager.has_method("_destroy_card"):
        await duel_manager._destroy_card(target_slot)
    else:

        if target_slot.spawn_point.get_child_count() > 0:
            for child in target_slot.spawn_point.get_children():
                child.queue_free()

        var opponent_is_player = not is_player_owner
        duel_manager.send_to_graveyard(target_card, opponent_is_player)
        target_slot.is_occupied = false
        target_slot.stored_card_data = null

        if opponent_is_player:
            if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
                duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
        else:
            if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
                duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)

    print("Twister: Efeito concluÃ­do.")

func _effect_book_of_life(is_player_owner: bool):
    print("Book of Life: Efeito ativado - Revive Zombie aliado e envia 1 monstro do deck oponente ao cemitÃ©rio")

    if not duel_manager:
        return

    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var opponent_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile
    var opponent_is_player = not is_player_owner


    var empty_slot = null
    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Book of Life: Sem slot vazio para invocar. Efeito cancelado.")
        return


    var zombie_candidates = []
    for gy_card in owner_graveyard:
        if gy_card and "zombie" in str(gy_card.type).to_lower():
            zombie_candidates.append(gy_card)

    if zombie_candidates.is_empty():
        print("Book of Life: Nenhum Zombie no cemitÃ©rio do dono. Efeito cancelado.")
        return

    zombie_candidates.shuffle()
    var zombie_target = zombie_candidates[0]
    var revived_card = zombie_target.get_copy()

    owner_graveyard.erase(zombie_target)
    if is_player_owner:
        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
    else:
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)

    await duel_manager.spawn_card_on_field(revived_card, empty_slot, false, is_player_owner, false, true)
    if duel_manager.has_method("play_summon_animation"):
        duel_manager.play_summon_animation(empty_slot)

    print("Book of Life: Reviveu ", revived_card.name)


    var opponent_monsters = []
    for deck_card in opponent_deck:
        if deck_card and int(deck_card.category) <= 7:
            opponent_monsters.append(deck_card)

    if opponent_monsters.is_empty():
        print("Book of Life: Deck do oponente sem monstros para enviar ao cemitÃ©rio.")
        duel_manager.update_deck_ui()
        return

    opponent_monsters.shuffle()
    var deck_target = opponent_monsters[0]
    opponent_deck.erase(deck_target)
    duel_manager.send_to_graveyard(deck_target, opponent_is_player, true)
    duel_manager.update_deck_ui()

    print("Book of Life: Enviou ", deck_target.name, " do deck do oponente para o cemitÃ©rio.")

func _apply_cockroach_knight_effect(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool, slot):
    print("Cockroach Knight: Efeito ativado - Volta para o deck do dono")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile





    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var card_found = false
    var card_index = -1

    for i in range(owner_graveyard.size() - 1, -1, -1):
        var grave_card = owner_graveyard[i]
        if grave_card and grave_card.id == COCKROACH_KNIGHT_ID:
            card_found = true
            card_index = i
            break

    if not card_found:
        print("Cockroach Knight: Carta nÃ£o encontrada no cemitÃ©rio do dono")
        return


    owner_graveyard.remove_at(card_index)
    print("Cockroach Knight: Removido do cemitÃ©rio")


    owner_deck.append(card_data)
    owner_deck.shuffle()
    print("Cockroach Knight: Colocado no final do deck")


    if is_player_owner:

        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:

        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Cockroach Knight: Efeito concluÃ­do! Carta retornada ao deck")

func _apply_black_ptera_effect(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool, slot):
    print("Black Ptera: Efeito ativado - Volta para o deck do dono")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var card_found = false
    var card_index = -1

    for i in range(owner_graveyard.size() - 1, -1, -1):
        var grave_card = owner_graveyard[i]
        if grave_card and grave_card.id == BLACK_PTERA_ID:
            card_found = true
            card_index = i
            break

    if not card_found:
        print("Black Ptera: Carta nÃ£o encontrada no cemitÃ©rio do dono")
        return


    owner_graveyard.remove_at(card_index)
    print("Black Ptera: Removido do cemitÃ©rio")


    owner_deck.append(card_data)
    owner_deck.shuffle()
    print("Black Ptera: Colocado no final do deck")


    if is_player_owner:

        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:

        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Black Ptera: Efeito concluÃ­do! Carta retornada ao deck")


func _apply_harvest_angel_effect(_card_data: CardData, is_player_owner: bool, _destroyed_by_battle: bool, slot):
    print("Harvest Angel of Wisdom: Efeito ativado - Retorna uma Trap do cemitÃ©rio para o deck")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var trap_indices = []
    for i in range(owner_graveyard.size()):
        var grave_card = owner_graveyard[i]
        if grave_card and grave_card.type.to_lower() == "trap":
            trap_indices.append(i)

    if trap_indices.is_empty():
        print("Harvest Angel of Wisdom: Nenhuma Trap encontrada no cemitÃ©rio do dono.")
        return


    trap_indices.shuffle()
    var chosen_index = trap_indices[0]
    var chosen_trap = owner_graveyard[chosen_index]

    print("Harvest Angel of Wisdom: Retornando '%s' ao deck!" % chosen_trap.name)


    owner_graveyard.remove_at(chosen_index)


    owner_deck.append(chosen_trap)
    owner_deck.shuffle()


    if is_player_owner:
        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)
        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Harvest Angel of Wisdom: Efeito concluÃ­do! Trap retornada ao deck e deck embaralhado.")


func _apply_meltiel_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Meltiel, Sage of the Sky: Verificando se Sanctuary in the Sky estÃ¡ ativo...")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if not is_face_up:
                print("Meltiel: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)


    var opp_slots = duel_manager.player_slots if not is_player_owner else duel_manager.enemy_slots


    var valid_targets = []
    for opp_slot in opp_slots:
        if opp_slot.is_occupied:
            valid_targets.append(opp_slot)

    if valid_targets.is_empty():
        print("Meltiel: Nenhum monstro no campo do oponente para destruir.")
        return


    valid_targets.shuffle()
    var target_slot = valid_targets[0]
    var target_card = target_slot.stored_card_data

    print("Meltiel, Sage of the Sky: Destruindo '%s' do oponente!" % target_card.name)

    await get_tree().create_timer(0.3).timeout
    await duel_manager._destroy_card(target_slot)

    print("Meltiel: Efeito concluÃ­do!")


func _apply_guardian_sphinx_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Guardian Sphinx: Efeito ativado - Retorna todos os monstros do oponente ao deck!")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if not is_face_up:
                print("Guardian Sphinx: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var opp_slots = duel_manager.player_slots if not is_player_owner else duel_manager.enemy_slots
    var opp_deck = duel_manager.player_deck_pile if not is_player_owner else duel_manager.enemy_deck_pile

    var returned_count = 0

    for opp_slot in opp_slots:
        if opp_slot.is_occupied and opp_slot.stored_card_data:
            var monster_card = opp_slot.stored_card_data
            print("Guardian Sphinx: Retornando '%s' ao deck do oponente!" % monster_card.name)


            var opp_visual = opp_slot.spawn_point.get_child(0) if opp_slot.spawn_point.get_child_count() > 0 else null
            if opp_visual:
                opp_visual.queue_free()


            opp_slot.is_occupied = false
            opp_slot.stored_card_data = null


            opp_deck.append(monster_card.get_original_atk_def())
            returned_count += 1

    if returned_count > 0:
        opp_deck.shuffle()
        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
        print("Guardian Sphinx: Efeito concluÃ­do! %d monstros retornados ao deck." % returned_count)
    else:
        print("Guardian Sphinx: Nenhum monstro no campo do oponente.")


func _apply_rock_spirit_effect(_card_data: CardData, _is_player_owner: bool, slot):
    print("The Rock Spirit: Efeito ativado - Ganha ATK por monstros Rock no cemitÃ©rio do dono")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_graveyard = duel_manager.player_graveyard if _is_player_owner else duel_manager.enemy_graveyard


    var rock_count = 0
    for grave_card in owner_graveyard:
        if grave_card and grave_card.type.to_lower() == "rock":
            rock_count += 1

    if rock_count == 0:
        print("The Rock Spirit: Nenhum monstro Rock no cemitÃ©rio. Sem bÃ´nus.")
        return

    var bonus = rock_count * 300
    print("The Rock Spirit: %d monstros Rock encontrados. +%d ATK" % [rock_count, bonus])


    if slot and slot.stored_card_data:
        slot.stored_card_data.atk += bonus


        if slot.spawn_point.get_child_count() > 0:
            var vis = slot.spawn_point.get_child(0)
            if vis.has_method("animate_stats_bonus"):
                vis.animate_stats_bonus(slot.stored_card_data.atk, slot.stored_card_data.def)

        print("The Rock Spirit: Novo ATK = %d" % slot.stored_card_data.atk)


func _apply_guardian_statue_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Guardian Statue: Efeito ativado - Retorna um monstro aleatÃ³rio do oponente ao deck!")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if not is_face_up:
                print("Guardian Statue: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var opp_slots = duel_manager.player_slots if not is_player_owner else duel_manager.enemy_slots
    var opp_deck = duel_manager.player_deck_pile if not is_player_owner else duel_manager.enemy_deck_pile


    var occupied_slots = []
    for s in opp_slots:
        if s.is_occupied and s.stored_card_data:
            occupied_slots.append(s)

    if occupied_slots.size() == 0:
        print("Guardian Statue: Nenhum monstro no campo do oponente para retornar.")
        return


    var target_slot = occupied_slots[randi() % occupied_slots.size()]
    var monster_card = target_slot.stored_card_data

    print("Guardian Statue: Retornando '%s' ao deck do oponente!" % monster_card.name)


    var opp_visual = target_slot.spawn_point.get_child(0) if target_slot.spawn_point.get_child_count() > 0 else null
    if opp_visual:
        opp_visual.queue_free()


    target_slot.is_occupied = false
    target_slot.stored_card_data = null


    opp_deck.append(monster_card.get_original_atk_def())
    opp_deck.shuffle()

    if duel_manager.has_method("update_deck_ui"):
        duel_manager.update_deck_ui()

    print("Guardian Statue: Efeito concluÃ­do!")


func _apply_megarock_dragon_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Megarock Dragon: Efeito ativado - Ganha ATK/DEF por monstros Rock no cemitÃ©rio do dono")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var rock_count = 0
    for grave_card in owner_graveyard:
        if grave_card and grave_card.type.to_lower() == "rock":
            rock_count += 1

    if rock_count == 0:
        print("Megarock Dragon: Nenhum monstro Rock no cemitÃ©rio. Sem bÃ´nus.")
        return

    var bonus = rock_count * 700
    print("Megarock Dragon: %d monstros Rock encontrados. +%d ATK/DEF" % [rock_count, bonus])


    if slot and slot.stored_card_data:
        slot.stored_card_data.atk += bonus
        slot.stored_card_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var vis = slot.spawn_point.get_child(0)
            if vis.has_method("animate_stats_bonus"):
                vis.animate_stats_bonus(slot.stored_card_data.atk, slot.stored_card_data.def)

        print("Megarock Dragon: Novo ATK = %d, Nova DEF = %d" % [slot.stored_card_data.atk, slot.stored_card_data.def])


func _apply_black_brachios_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Black Brachios: Efeito ativado!")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_self_face_up = true
            if card_visual.has_method("is_face_down"):
                is_self_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_self_face_up = not duel_manager._has_card_back(card_visual)

            if not is_self_face_up:
                print("Black Brachios: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return
            await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var dino_count = 0
    for s in owner_slots:
        if s.is_occupied and s.stored_card_data and s.stored_card_data.type.to_lower() == "dinosaur":
            var visual = s.spawn_point.get_child(0) if s.spawn_point.get_child_count() > 0 else null
            if visual:
                var is_face_up = true
                if visual.has_method("is_face_down"):
                    is_face_up = not visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up:
                    dino_count += 1

    print("Black Brachios: %d Dinossauros face-up encontrados." % dino_count)
    if dino_count == 0:
        return

    var opp_slots = duel_manager.player_slots if not is_player_owner else duel_manager.enemy_slots
    var opp_deck = duel_manager.player_deck_pile if not is_player_owner else duel_manager.enemy_deck_pile

    var occupied_slots = []
    for s in opp_slots:
        if s.is_occupied and s.stored_card_data:
            occupied_slots.append(s)

    if occupied_slots.size() == 0:
        return

    occupied_slots.shuffle()
    var target_count = min(dino_count, occupied_slots.size())

    for i in range(target_count):
        var target_slot = occupied_slots[i]
        var monster_card = target_slot.stored_card_data


        var opp_visual = target_slot.spawn_point.get_child(0) if target_slot.spawn_point.get_child_count() > 0 else null
        if opp_visual:
            opp_visual.queue_free()


        target_slot.is_occupied = false
        target_slot.stored_card_data = null


        opp_deck.append(monster_card.get_original_atk_def())
        print("Black Brachios: '%s' retornado ao deck." % monster_card.name)

    opp_deck.shuffle()
    if duel_manager.has_method("update_deck_ui"):
        duel_manager.update_deck_ui()


func _apply_destroyersaurus_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Destroyersaurus: Efeito ativado!")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_self_face_up = true
            if card_visual.has_method("is_face_down"):
                is_self_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_self_face_up = not duel_manager._has_card_back(card_visual)

            if not is_self_face_up:
                print("Destroyersaurus: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return
            await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var dino_count = 0
    for s in owner_slots:
        if s.is_occupied and s.stored_card_data and s.stored_card_data.type.to_lower() == "dinosaur":
            var visual = s.spawn_point.get_child(0) if s.spawn_point.get_child_count() > 0 else null
            if visual:
                var is_face_up = true
                if visual.has_method("is_face_down"):
                    is_face_up = not visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(visual)

                if is_face_up:
                    dino_count += 1

    print("Destroyersaurus: %d Dinossauros face-up encontrados." % dino_count)
    if dino_count == 0:
        return

    var opp_slots = duel_manager.player_slots if not is_player_owner else duel_manager.enemy_slots
    var occupied_slots = []
    for s in opp_slots:
        if s.is_occupied and s.stored_card_data:
            occupied_slots.append(s)

    if occupied_slots.size() == 0:
        return

    occupied_slots.shuffle()
    var target_count = min(dino_count, occupied_slots.size())

    for i in range(target_count):
        var target_slot = occupied_slots[i]
        print("Destroyersaurus: Destruindo '%s'!" % target_slot.stored_card_data.name)
        if duel_manager.has_method("_destroy_card"):
            duel_manager._destroy_card(target_slot)


func _apply_super_ancient_dinobeast_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Super-Ancient Dinobeast: Efeito ativado - Ganha ATK/DEF por Dinossauros no cemitÃ©rio")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_self_face_up = true
            if card_visual.has_method("is_face_down"):
                is_self_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_self_face_up = not duel_manager._has_card_back(card_visual)

            if is_self_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var dino_count = 0
    for grave_card in owner_graveyard:
        if grave_card and grave_card.type.to_lower() == "dinosaur":
            dino_count += 1

    if dino_count == 0:
        print("Super-Ancient Dinobeast: Nenhum Dinosaur no cemitÃ©rio. Sem bÃ´nus.")
        return

    var bonus = dino_count * 200
    print("Super-Ancient Dinobeast: %d monstros Dinosaur encontrados. +%d ATK/DEF" % [dino_count, bonus])


    if slot and slot.stored_card_data:
        slot.stored_card_data.atk += bonus
        slot.stored_card_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var vis = slot.spawn_point.get_child(0)
            if vis.has_method("animate_stats_bonus"):
                vis.animate_stats_bonus(slot.stored_card_data.atk, slot.stored_card_data.def)

        print("Super-Ancient Dinobeast: Novo ATK = %d, Nova DEF = %d" % [slot.stored_card_data.atk, slot.stored_card_data.def])


func _apply_beetron_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Beetron: Efeito ativado - Special Summon Insect Level 4 ou menor do cemitÃ©rio")

    if not duel_manager:
        return


    if not _is_card_face_up(slot, is_player_owner):
        print("Beetron: Invocado face-down. Efeito nÃ£o ativa.")
        return


    var card_visual = slot.spawn_point.get_child(0)
    await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard
    var candidates = []

    for card in owner_graveyard:
        if card and card.type.to_lower() == "insect" and card.level <= 4:
            candidates.append(card)

    if candidates.is_empty():
        print("Beetron: Nenhum monstro Insect de Level 4 ou menor encontrado no cemitÃ©rio.")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null
    for s in owner_slots:
        if not s.is_occupied:
            empty_slot = s
            break

    if not empty_slot:
        print("Beetron: Nenhum slot vazio para invocar.")
        return


    candidates.shuffle()
    var target_card = candidates[0]
    var new_card_data = target_card.get_copy()

    print("Beetron: Revivendo '%s' do cemitÃ©rio!" % target_card.name)


    owner_graveyard.erase(target_card)


    if is_player_owner:
        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
    else:
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


    if duel_manager.has_method("spawn_card_on_field"):
        duel_manager.spawn_card_on_field(
            new_card_data, 
            empty_slot, 
            false, 
            is_player_owner
        )

    print("Beetron: Efeito concluÃ­do.")


func _apply_blazewing_butterfly_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Blazewing Butterfly: Efeito ativado - Buff de +400 ATK para todos os Insects")

    if not duel_manager:
        return


    if not _is_card_face_up(slot, is_player_owner):
        print("Blazewing Butterfly: Invocada face-down. Efeito nÃ£o ativa.")
        return


    var card_visual = slot.spawn_point.get_child(0)
    await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var buff_count = 0

    for s in owner_slots:
        if s.is_occupied:
            var target_card = s.stored_card_data
            if target_card and target_card.type.to_lower() == "insect":

                var target_visual = s.spawn_point.get_child(0) if s.spawn_point.get_child_count() > 0 else null
                var is_target_face_up = true
                if target_visual:
                    if target_visual.has_method("is_face_down"):
                        is_target_face_up = not target_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        is_target_face_up = not duel_manager._has_card_back(target_visual)

                if is_target_face_up:
                    print("Blazewing Butterfly: Buffando '%s'!" % target_card.name)
                    target_card.atk += 400
                    buff_count += 1

                    if target_visual and target_visual.has_method("animate_stats_bonus"):
                        target_visual.animate_stats_bonus(target_card.atk, target_card.def)

    print("Blazewing Butterfly: Efeito concluÃ­do - %d monstros buffados." % buff_count)


func _apply_zeradias_effect(_card_data: CardData, is_player_owner: bool, slot):
    print("Zeradias, Herald of Heaven: Efeito ativado - Busca Sanctuary in the Sky no deck")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if not is_face_up:
                print("Zeradias: NÃ£o estÃ¡ face-up, efeito nÃ£o ativa.")
                return

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var found_index = -1
    for i in range(owner_deck.size()):
        if owner_deck[i].id == 756:
            found_index = i
            break

    if found_index == -1:
        print("Zeradias: Nenhum Sanctuary in the Sky encontrado no deck.")
        return


    var sanctuary_card = owner_deck[found_index]
    owner_deck.remove_at(found_index)
    owner_deck.shuffle()

    print("Zeradias: Sanctuary in the Sky encontrado! Colocando no topo do deck...")




    owner_deck.append(sanctuary_card)


    if duel_manager.has_method("update_deck_ui"):
        duel_manager.update_deck_ui()

    print("Zeradias: Efeito concluÃ­do! Sanctuary in the Sky serÃ¡ comprada no prÃ³ximo turno.")


func _apply_bountiful_artemis_effect(_card_data: CardData, _is_player_owner: bool, slot):
    print("Bountiful Artemis: Efeito ativado - Ganha ATK/DEF por Traps nos cemitÃ©rios")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)


    var trap_count = 0

    for grave_card in duel_manager.player_graveyard:
        if grave_card and grave_card.type.to_lower() == "trap":
            trap_count += 1

    for grave_card in duel_manager.enemy_graveyard:
        if grave_card and grave_card.type.to_lower() == "trap":
            trap_count += 1

    if trap_count == 0:
        print("Bountiful Artemis: Nenhuma Trap nos cemitÃ©rios. Sem bÃ´nus.")
        return

    var bonus = trap_count * 200
    print("Bountiful Artemis: %d Traps encontradas. +%d ATK/DEF" % [trap_count, bonus])


    if slot and slot.stored_card_data:
        slot.stored_card_data.atk += bonus
        slot.stored_card_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var vis = slot.spawn_point.get_child(0)
            if vis.has_method("animate_stats_bonus"):
                vis.animate_stats_bonus(slot.stored_card_data.atk, slot.stored_card_data.def)

        print("Bountiful Artemis: Novo ATK = %d, DEF = %d" % [slot.stored_card_data.atk, slot.stored_card_data.def])


func _apply_dark_magician_girl_effect(_card_data: CardData, _is_player_owner: bool, slot):
    print("Dark Magician Girl: Efeito ativado - Ganha ATK por Dark Magician/Dark Sage nos cemitÃ©rios")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                await duel_manager._apply_magic_activation_glow(card_visual)


    var target_count = 0

    for grave_card in duel_manager.player_graveyard:
        if grave_card and (grave_card.id == 35 or grave_card.id == 722):
            target_count += 1

    for grave_card in duel_manager.enemy_graveyard:
        if grave_card and (grave_card.id == 35 or grave_card.id == 722):
            target_count += 1

    if target_count == 0:
        print("Dark Magician Girl: Nenhum Dark Magician/Dark Sage nos cemitÃ©rios. Sem bÃ´nus.")
        return

    var bonus = target_count * 300
    print("Dark Magician Girl: %d Dark Magician/Dark Sage encontrados. +%d ATK" % [target_count, bonus])


    if slot and slot.stored_card_data:
        slot.stored_card_data.atk += bonus


        if slot.spawn_point.get_child_count() > 0:
            var vis = slot.spawn_point.get_child(0)
            if vis.has_method("animate_stats_bonus"):
                vis.animate_stats_bonus(slot.stored_card_data.atk, slot.stored_card_data.def)

        print("Dark Magician Girl: Novo ATK = %d" % slot.stored_card_data.atk)


func _apply_magician_of_faith_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Magician of Faith: Efeito ativado - Retorna uma Spell/Trap aleatÃ³ria do cemitÃ©rio para o deck")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Magician of Faith: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_graveyard = duel_manager.player_graveyard if is_player_owner else duel_manager.enemy_graveyard


    var spell_trap_in_grave = []
    var spell_trap_indices = []

    for i in range(owner_graveyard.size()):
        var grave_card = owner_graveyard[i]
        if grave_card:

            var is_spell = (grave_card.category == CardData.CardCategory.MAGIC)
            var is_trap = (grave_card.category == CardData.CardCategory.TRAP)

            if is_spell or is_trap:
                spell_trap_in_grave.append(grave_card)
                spell_trap_indices.append(i)
                print("  - Spell/Trap encontrada: ", grave_card.name)


    if spell_trap_in_grave.size() == 0:
        print("Magician of Faith: Nenhuma Spell/Trap encontrada no cemitÃ©rio do dono")
        return


    var random_index = randi() % spell_trap_in_grave.size()
    var selected_card = spell_trap_in_grave[random_index]
    var grave_index_to_remove = spell_trap_indices[random_index]

    print("Magician of Faith: Selecionado - ", selected_card.name)


    owner_graveyard.remove_at(grave_index_to_remove)
    print("Magician of Faith: Carta removida do cemitÃ©rio")


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    owner_deck.append(selected_card)
    owner_deck.shuffle()
    print("Magician of Faith: Carta colocada no final do deck")


    if is_player_owner:

        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:

        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Magician of Faith: Efeito concluÃ­do!")

func _apply_blast_juggler_effect(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool, slot):
    print("Blast Juggler: Efeito ativado - DestrÃ³i atÃ© 2 monstros face-up do oponente com 1000 ATK ou menos")

    if not duel_manager:
        return


    if slot:
        var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
        if card_visual:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var valid_targets = []

    for opponent_slot in opponent_slots:
        if opponent_slot.is_occupied and opponent_slot.stored_card_data:
            var opponent_card = opponent_slot.stored_card_data


            var is_face_up = false
            var opponent_visual = opponent_slot.spawn_point.get_child(0) if opponent_slot.spawn_point.get_child_count() > 0 else null

            if opponent_visual:
                if opponent_visual.has_method("is_face_down"):
                    is_face_up = not opponent_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(opponent_visual)


            if is_face_up and opponent_card.atk <= BLAST_JUGGLER_MAX_ATK:
                valid_targets.append(opponent_slot)
                print("  - Alvo válido encontrado: ", opponent_card.name, 
                      " (ATK: ", opponent_card.atk, ", Face-up: ", is_face_up, ")")


    if valid_targets.size() == 0:
        print("Blast Juggler: Nenhum monstro válido do oponente encontrado")
        return


    var targets_to_destroy = min(valid_targets.size(), BLAST_JUGGLER_MAX_TARGETS)

    print("Blast Juggler: Destruindo ", targets_to_destroy, " monstro(s) do oponente")


    valid_targets.shuffle()


    for i in range(targets_to_destroy):
        var target_slot = valid_targets[i]
        var target_card = target_slot.stored_card_data

        print("  - Destruindo: ", target_card.name)
        await duel_manager._destroy_card(target_slot)
        await get_tree().create_timer(0.2).timeout

    print("Blast Juggler: Efeito concluÃ­do!")

func _apply_dark_elf_effect(attacker_card_data: CardData, attacker_is_player_owner: bool, attacker_slot):
    print("Dark Elf: Efeito ativado - Dono perde 1000 LP ao atacar")

    if not duel_manager:
        return


    var card_visual = attacker_slot.spawn_point.get_child(0) if attacker_slot.spawn_point.get_child_count() > 0 else null
    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    if attacker_is_player_owner:

        duel_manager.player_lp -= DARK_ELF_LP_COST
        print("Dark Elf: Jogador perde ", DARK_ELF_LP_COST, " LP")


        if duel_manager.player_lp_label:
            _animate_lp_if_possible(duel_manager.player_lp_label, duel_manager.player_lp)
    else:

        duel_manager.enemy_lp -= DARK_ELF_LP_COST
        print("Dark Elf: IA perde ", DARK_ELF_LP_COST, " LP")


        if duel_manager.enemy_lp_label:
            _animate_lp_if_possible(duel_manager.enemy_lp_label, duel_manager.enemy_lp)


    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_cyber_stein_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Cyber-Stein: Efeito ativado - Ganha +200 ATK/DEF por cada monstro Fusion no deck")

    if not duel_manager:
        return


    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    var is_face_up = false

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


        if is_face_up:
            await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var FUSION_CATEGORY = CardData.CardCategory.FUSION_MONSTER


    var fusion_count = 0

    for deck_card in owner_deck:
        if deck_card and deck_card.category == FUSION_CATEGORY:
            fusion_count += 1
            print("  - Monstro Fusion encontrado: ", deck_card.name)


    var bonus = fusion_count * CYBER_STEIN_FUSION_BONUS

    print("Cyber-Stein: ", fusion_count, " monstro(s) Fusion no deck â†’ +", bonus, " ATK/DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus") and is_face_up:
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Cyber-Stein: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)

func _apply_hiros_shadow_scout_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Hiro's Shadow Scout: Efeito ativado - Coloca 3 cartas aleatÃ³rias do deck do oponente no cemitÃ©rio")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Hiro's Shadow Scout: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile
    var opponent_is_player = not is_player_owner

    print("Hiro's Shadow Scout: Deck do oponente tem ", opponent_deck.size(), " cartas")


    if opponent_deck.size() == 0:
        print("Hiro's Shadow Scout: Deck do oponente estÃ¡ vazio!")
        return


    var cards_to_mill = min(HIROS_SHADOW_SCOUT_MILL_COUNT, opponent_deck.size())

    print("Hiro's Shadow Scout: Enviando ", cards_to_mill, " carta(s) para o cemitÃ©rio")


    var cards_to_send = []
    var indices_to_remove = []


    for i in range(cards_to_mill):
        if opponent_deck.size() == 0:
            break


        var random_index = randi() % opponent_deck.size()
        var selected_card = opponent_deck[random_index]

        cards_to_send.append(selected_card)
        indices_to_remove.append(random_index)
        print("  - Selecionada: ", selected_card.name)


        opponent_deck.remove_at(random_index)


    for card in cards_to_send:

        duel_manager.send_to_graveyard(card, opponent_is_player, true)
        print("  - Enviada para o cemitÃ©rio: ", card.name)
        await get_tree().create_timer(0.1).timeout


    if opponent_is_player:

        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()
    else:

        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


        if duel_manager.has_method("update_deck_ui"):
            duel_manager.update_deck_ui()

    print("Hiro's Shadow Scout: Efeito concluÃ­do! ", cards_to_send.size(), " carta(s) enviada(s) ao cemitÃ©rio")

func _apply_little_chimera_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Little Chimera: Efeito ativado - Afeta todos os monstros FIRE e WATER no campo")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Little Chimera: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var all_slots = []
    all_slots.append_array(duel_manager.player_slots)
    all_slots.append_array(duel_manager.enemy_slots)

    var fire_count = 0
    var water_count = 0


    for target_slot in all_slots:
        if target_slot.is_occupied and target_slot.stored_card_data:



            var monster_data = target_slot.stored_card_data
            var monster_attribute = monster_data.attribute.to_lower() if monster_data.attribute else ""


            if monster_attribute == "fire":
                fire_count += 1
                monster_data.atk += LITTLE_CHIMERA_FIRE_BONUS
                print("  - +500 ATK para ", monster_data.name, " (FIRE)")


            elif monster_attribute == "water":
                water_count += 1
                monster_data.atk += LITTLE_CHIMERA_WATER_PENALTY
                print("  - -400 ATK para ", monster_data.name, " (WATER)")


            if target_slot.spawn_point.get_child_count() > 0:
                var visual = target_slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(monster_data.atk, monster_data.def)

    print("Little Chimera: ", fire_count, " monstro(s) FIRE receberam +500 ATK")
    print("Little Chimera: ", water_count, " monstro(s) WATER receberam -400 ATK")
    print("Little Chimera: Efeito concluÃ­do")

func _apply_star_boy_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Star Boy: Efeito ativado - Afeta todos os monstros FIRE e WATER no campo")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Star Boy: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var all_slots = []
    all_slots.append_array(duel_manager.player_slots)
    all_slots.append_array(duel_manager.enemy_slots)

    var fire_count = 0
    var water_count = 0


    for target_slot in all_slots:
        if target_slot.is_occupied and target_slot.stored_card_data:



            var monster_data = target_slot.stored_card_data
            var monster_attribute = monster_data.attribute.to_lower() if monster_data.attribute else ""


            if monster_attribute == "water":
                water_count += 1
                monster_data.atk += STAR_BOY_WATER_BONUS
                print("  - +500 ATK para ", monster_data.name, " (WATER)")


            elif monster_attribute == "fire":
                fire_count += 1
                monster_data.atk += STAR_BOY_FIRE_PENALTY
                print("  - -400 ATK para ", monster_data.name, " (FIRE)")


            if target_slot.spawn_point.get_child_count() > 0:
                var visual = target_slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(monster_data.atk, monster_data.def)

    print("Star Boy: ", water_count, " monstro(s) WATER receberam +500 ATK")
    print("Star Boy: ", fire_count, " monstro(s) FIRE receberam -400 ATK")
    print("Star Boy: Efeito concluÃ­do")

func _apply_hoshiningen_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Hoshiningen: Efeito ativado - Afeta todos os monstros LIGHT e DARK no campo")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Hoshiningen: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var all_slots = []
    all_slots.append_array(duel_manager.player_slots)
    all_slots.append_array(duel_manager.enemy_slots)

    var light_count = 0
    var dark_count = 0


    for target_slot in all_slots:
        if target_slot.is_occupied and target_slot.stored_card_data:



            var monster_data = target_slot.stored_card_data
            var monster_attribute = monster_data.attribute.to_lower() if monster_data.attribute else ""


            if monster_attribute == "light":
                light_count += 1
                monster_data.atk += HOSHININGEN_LIGHT_BONUS
                print("  - +500 ATK para ", monster_data.name, " (LIGHT)")


            elif monster_attribute == "dark":
                dark_count += 1
                monster_data.atk += HOSHININGEN_DARK_PENALTY
                print("  - -400 ATK para ", monster_data.name, " (DARK)")


            if target_slot.spawn_point.get_child_count() > 0:
                var visual = target_slot.spawn_point.get_child(0)
                if visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(monster_data.atk, monster_data.def)

    print("Hoshiningen: ", light_count, " monstro(s) LIGHT receberam +500 ATK")
    print("Hoshiningen: ", dark_count, " monstro(s) DARK receberam -400 ATK")
    print("Hoshiningen: Efeito concluÃ­do")

func _apply_man_eater_bug_effect(owner_is_player: bool):
    print("Ativando efeito do Man-Eater Bug!")


    var opponent_slots = []
    if owner_is_player:

        opponent_slots = duel_manager.enemy_slots
    else:

        opponent_slots = duel_manager.player_slots


    var best_target = null
    var highest_atk = -1

    for slot in opponent_slots:
        if not slot.is_occupied or not slot.stored_card_data:
            continue

        var card = slot.stored_card_data
        var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

        if not visual:
            continue


        var is_face_up = true
        if visual.has_method("is_face_down"):
            is_face_up = not visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(visual)

        if is_face_up:
            if card.atk > highest_atk:
                highest_atk = card.atk
                best_target = slot


    if best_target and best_target.stored_card_data:
        print("Man-Eater Bug destroi: ", best_target.stored_card_data.name)
        await duel_manager._destroy_card(best_target, false)

func _apply_hourglass_of_courage_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Hourglass of Courage: Efeito ativado - Verifica Hourglass of Life na mÃ£o")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Hourglass of Courage: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand
    var has_hourglass_of_life = false

    for card in owner_hand:
        if card and card.id == HOURGLASS_OF_LIFE_ID:
            has_hourglass_of_life = true
            break

    if has_hourglass_of_life:
        print("Hourglass of Courage: Hourglass of Life encontrado na mÃ£o! Dobrando STATS.")


        var new_atk = card_data.atk * 2
        var new_def = card_data.def * 2

        card_data.atk = new_atk
        card_data.def = new_def


        if slot and slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(new_atk, new_def)
    else:
        print("Hourglass of Courage: Hourglass of Life NÃƒO encontrado na mÃ£o.")

func _apply_immortal_of_thunder_summon_effect(card_data: CardData, is_player_owner: bool, slot):
    print("The Immortal of Thunder: Efeito de invocaÃ§Ã£o ativado")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Immortal of Thunder: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    if is_face_up:
        print("The Immortal of Thunder: Invocado face-up, ganhando 3000 LP")
        await duel_manager.heal_lp(is_player_owner, 3000)
    else:
        print("The Immortal of Thunder: Invocado face-down, sem ganho de LP")

func _apply_immortal_of_thunder_destruction_effect(card_data: CardData, is_player_owner: bool, destroyed_by_battle: bool, slot):
    print("The Immortal of Thunder: Efeito de destruiÃ§Ã£o ativado - Perde 5000 LP")

    if not duel_manager:
        return

    if is_player_owner:
        duel_manager.player_lp -= 5000
    else:
        duel_manager.enemy_lp -= 5000

    duel_manager.update_lp_ui()
    duel_manager.check_game_over()

func _apply_invader_of_throne_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Invader of the Throne: Efeito de invocaÃ§Ã£o ativado")

    if not duel_manager or not slot:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Invader of the Throne: Invocado face-down, efeito nÃ£o ativa")
        return

    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots
    var best_target_slot = null
    var highest_atk = -1

    for op_slot in opponent_slots:
        if not op_slot.is_occupied:
            continue

        var op_visual = op_slot.spawn_point.get_child(0) if op_slot.spawn_point.get_child_count() > 0 else null
        var op_is_face_up = false

        if op_visual:
            if op_visual.has_method("is_face_down"):
                op_is_face_up = not op_visual.is_face_down()
            elif duel_manager.has_method("_has_card_back"):
                op_is_face_up = not duel_manager._has_card_back(op_visual)

        if op_is_face_up:
            if op_slot.stored_card_data.atk > highest_atk:
                highest_atk = op_slot.stored_card_data.atk
                best_target_slot = op_slot

    if not best_target_slot:
        print("Invader of the Throne: Nenhum monstro face-up do oponente para trocar.")
        return

    print("Invader of the Throne: Trocando ATK/DEF com ", best_target_slot.stored_card_data.name)


    var target_card = best_target_slot.stored_card_data

    var temp_atk = card_data.atk
    var temp_def = card_data.def

    card_data.atk = target_card.atk
    card_data.def = target_card.def

    target_card.atk = temp_atk
    target_card.def = temp_def


    if card_visual.has_method("animate_stats_bonus"):
        card_visual.animate_stats_bonus(card_data.atk, card_data.def)


    if best_target_slot.spawn_point.get_child_count() > 0:
        var target_visual = best_target_slot.spawn_point.get_child(0)
        if target_visual.has_method("animate_stats_bonus"):
            target_visual.animate_stats_bonus(target_card.atk, target_card.def)

func _apply_thunder_dragon_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Thunder Dragon: Efeito de invocaÃ§Ã£o ativado")

    if not duel_manager or not slot:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


    if is_face_up and card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile
    var count = 0

    for card in owner_deck:
        if card.id == THUNDER_DRAGON_ID:
            count += 1

    if count > 0:
        var bonus = count * 200
        print("Thunder Dragon: %d cÃ³pias encontradas no deck. BÃ´nus de +%d ATK/DEF" % [count, bonus])

        card_data.atk += bonus
        card_data.def += bonus


        if card_visual and card_visual.has_method("animate_stats_bonus"):
            card_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Thunder Dragon: Nenhuma cÃ³pia no deck. Sem bÃ´nus.")

func _apply_harpies_pet_dragon_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Harpie's Pet Dragon: Efeito de invocaÃ§Ã£o ativado")

    if not duel_manager or not slot:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)


    if is_face_up and card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var count = 0

    for s in owner_slots:
        if not s.is_occupied:
            continue


        if s.stored_card_data.id == HARPIE_LADY_ID:

            var s_visual = s.spawn_point.get_child(0) if s.spawn_point.get_child_count() > 0 else null
            var s_is_face_up = false

            if s_visual:
                if s_visual.has_method("is_face_down"):
                    s_is_face_up = not s_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    s_is_face_up = not duel_manager._has_card_back(s_visual)

            if s_is_face_up:
                count += 1

    if count > 0:
        var bonus = count * 200
        print("Harpie's Pet Dragon: %d Harpie Lady(s) face-up no campo. BÃ´nus de +%d ATK/DEF" % [count, bonus])

        card_data.atk += bonus
        card_data.def += bonus


        if card_visual and card_visual.has_method("animate_stats_bonus"):
            card_visual.animate_stats_bonus(card_data.atk, card_data.def)
    else:
        print("Harpie's Pet Dragon: Nenhuma Harpie Lady face-up no campo. Sem bÃ´nus.")


func _effect_fissure(is_player_owner: bool):
    print("EffectManager: Resolvendo Fissure")
    if not duel_manager:
        return

    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots
    var face_up_monsters = []


    for slot in opponent_slots:
        if slot.is_occupied:
            var is_face_up = false
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

            if card_visual:
                if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                face_up_monsters.append(slot)

    if face_up_monsters.size() == 0:
        print("Fissure: Nenhum monstro face-up do oponente.")
        return


    var min_atk = 999999
    for slot in face_up_monsters:
        var atk = slot.stored_card_data.atk
        if atk < min_atk:
            min_atk = atk


    var candidates = []
    for slot in face_up_monsters:
        if slot.stored_card_data.atk == min_atk:
            candidates.append(slot)


    var target_slot = candidates.pick_random()
    print("Fissure: Destruindo ", target_slot.stored_card_data.name)


    var target_visual = target_slot.spawn_point.get_child(0)
    var is_enemy_target = ( not is_player_owner)


    if duel_manager.has_method("_destroy_card"):
        duel_manager._destroy_card(target_slot)

func _effect_pot_of_greed(is_player_owner: bool):
    print("EffectManager: Resolvendo Pot of Greed")
    if not duel_manager:
        return

    var hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand






    var discard_count = 0
    if hand.size() > 0:


        var temp_hand = []
        for card in hand:
            if card != null and card.category != CardData.CardCategory.MAGIC and card.category != CardData.CardCategory.TRAP:
                temp_hand.append(card)


        temp_hand.sort_custom( func(a, b): return a.atk < b.atk)


        var cards_to_discard = []
        discard_count = min(2, temp_hand.size())

        for i in range(discard_count):
            cards_to_discard.append(temp_hand[i])

        print("Pot of Greed: Descartando %d cartas com menor ATK" % discard_count)


        for card in cards_to_discard:
            if card in hand:
                hand.erase(card)
                duel_manager.send_to_graveyard(card, is_player_owner, true)


        duel_manager.update_deck_ui()


    await get_tree().create_timer(0.5).timeout


    if discard_count > 0:
        print("Pot of Greed: Comprando %d cartas" % discard_count)
        for i in range(discard_count):
            var new_card = duel_manager.draw_card_from_deck(is_player_owner, true)
            if new_card:
                hand.append(new_card)

                await get_tree().create_timer(0.2).timeout
    else:
        print("Pot of Greed: Nenhum monstro descartado, nenhuma carta comprada.")


    if is_player_owner:
        duel_manager.update_hand_ui_animated(true)
    else:
        duel_manager.update_enemy_hand_ui_animated(true)


    duel_manager.update_deck_ui()


func _effect_gravedigger_ghoul(is_player_owner: bool):
    print("EffectManager: Resolvendo Gravedigger Ghoul")
    if not duel_manager:
        return


    var opponent_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile
    var opponent_is_player = not is_player_owner

    print("Gravedigger Ghoul: Deck do oponente tem %d cartas" % opponent_deck.size())

    if opponent_deck.size() == 0:
        print("Gravedigger Ghoul: Deck do oponente vazio.")
        return


    var cards_to_mill = min(2, opponent_deck.size())

    print("Gravedigger Ghoul: Enviando %d cartas aleatÃ³rias para o cemitÃ©rio" % cards_to_mill)

    var cards_to_send = []


    for i in range(cards_to_mill):
        if opponent_deck.size() == 0:
            break

        var random_index = randi() % opponent_deck.size()
        var selected_card = opponent_deck[random_index]

        cards_to_send.append(selected_card)


        opponent_deck.remove_at(random_index)


    for card in cards_to_send:

        duel_manager.send_to_graveyard(card, opponent_is_player, true)
        print("  - Enviada: %s" % card.name)

        await get_tree().create_timer(0.2).timeout


    duel_manager.update_deck_ui()

    if opponent_is_player:
         if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
    else:
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


func _effect_monster_reborn(is_player_owner: bool):
    print("EffectManager: Resolvendo Monster Reborn")
    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Monster Reborn: Nenhum slot vazio para invocar!")
        return


    var best_monster = null
    var best_atk = -1
    var source_gy = null


    for card in duel_manager.player_graveyard:
        if card.category != CardData.CardCategory.MAGIC and card.category != CardData.CardCategory.TRAP:
            if card.atk > best_atk:
                best_atk = card.atk
                best_monster = card
                source_gy = "player"


    for card in duel_manager.enemy_graveyard:
        if card.category != CardData.CardCategory.MAGIC and card.category != CardData.CardCategory.TRAP:
            if card.atk > best_atk:
                best_atk = card.atk
                best_monster = card
                source_gy = "enemy"

    if not best_monster:
        print("Monster Reborn: Nenhum monstro encontrado nos cemitÃ©rios.")
        return

    print("Monster Reborn: Revivendo %s (ATK %d) do cemitÃ©rio %s" % [best_monster.name, best_atk, source_gy])


    var new_card_data = best_monster.get_copy()


    if source_gy == "player":
        duel_manager.player_graveyard.erase(best_monster)
        if duel_manager.player_gy_visual and duel_manager.player_gy_visual.has_method("update_graveyard"):
            duel_manager.player_gy_visual.update_graveyard(duel_manager.player_graveyard)
    else:
        duel_manager.enemy_graveyard.erase(best_monster)
        if duel_manager.enemy_gy_visual and duel_manager.enemy_gy_visual.has_method("update_graveyard"):
            duel_manager.enemy_gy_visual.update_graveyard(duel_manager.enemy_graveyard)


    if duel_manager.has_method("spawn_card_on_field"):


        duel_manager.spawn_card_on_field(
            new_card_data, 
            empty_slot, 
            false, 
            is_player_owner
        )

    print("Monster Reborn: ConcluÃ­do.")


func _effect_insect_imitation(is_player_owner: bool):
    print("EffectManager: Resolvendo Insect Imitation")
    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null
    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Insect Imitation: Nenhum slot vazio para invocar!")
        return


    var strongest_insect = null
    var max_atk = -1

    for slot in owner_slots:
        if slot.is_occupied:
            var card = slot.stored_card_data
            if card and card.type.to_lower() == "insect":

                if _is_card_face_up(slot, is_player_owner):
                    if card.atk > max_atk:
                        max_atk = card.atk
                        strongest_insect = card

    if not strongest_insect:
        print("Insect Imitation: Nenhum monstro Insect face-up encontrado no campo.")
        return

    print("Insect Imitation: Copiando '%s' (ATK %d) e bÃ´nus +1000 pendente" % [strongest_insect.name, strongest_insect.atk])


    var spawn_card_data = strongest_insect.get_copy()


    var final_atk = spawn_card_data.atk + 1000
    var final_def = spawn_card_data.def + 1000


    if duel_manager.has_method("spawn_card_on_field"):

        await duel_manager.spawn_card_on_field(
            spawn_card_data, 
            empty_slot, 
            false, 
            is_player_owner
        )


        spawn_card_data.atk = final_atk
        spawn_card_data.def = final_def

        if empty_slot and empty_slot.spawn_point.get_child_count() > 0:
            var new_visual = empty_slot.spawn_point.get_child(0)
            if new_visual.has_method("animate_stats_bonus"):

                await get_tree().create_timer(0.3).timeout
                new_visual.animate_stats_bonus(final_atk, final_def)

    print("Insect Imitation: Efeito concluÃ­do.")


func _effect_change_of_heart(is_player_owner: bool):
    print("EffectManager: Resolvendo Change of Heart")
    if not duel_manager:
        return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var opp_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var my_candidate_slot = null
    var my_lowest_atk = 99999

    for slot in owner_slots:
        if slot.is_occupied:
            var is_face_up = false
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
            if card_visual:
                if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                var atk = slot.stored_card_data.atk
                if atk < my_lowest_atk:
                    my_lowest_atk = atk
                    my_candidate_slot = slot


    var opp_candidate_slot = null
    var opp_highest_atk = -1

    for slot in opp_slots:
        if slot.is_occupied:
            var is_face_up = false
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
            if card_visual:
                if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                var atk = slot.stored_card_data.atk
                if atk > opp_highest_atk:
                    opp_highest_atk = atk
                    opp_candidate_slot = slot

    if my_candidate_slot and opp_candidate_slot:
        print("Change of Heart: Trocando %s (ATK %d) por %s (ATK %d)" % [my_candidate_slot.stored_card_data.name, my_lowest_atk, opp_candidate_slot.stored_card_data.name, opp_highest_atk])


        var my_card_data = my_candidate_slot.stored_card_data.get_copy()
        var opp_card_data = opp_candidate_slot.stored_card_data.get_copy()


        _clear_slot_visually(my_candidate_slot)
        _clear_slot_visually(opp_candidate_slot)



        if duel_manager.has_method("spawn_card_on_field"):
            duel_manager.spawn_card_on_field(
                opp_card_data, 
                my_candidate_slot, 
                false, 
                is_player_owner
            )


            duel_manager.spawn_card_on_field(
                my_card_data, 
                opp_candidate_slot, 
                false, 
                not is_player_owner
            )

        print("Change of Heart: Troca concluÃ­da.")
    else:
        print("Change of Heart: Falhou. NecessÃ¡rio monstros face-up em ambos os lados.")

func _clear_slot_visually(slot):
    if slot:
        slot.stored_card_data = null
        slot.is_occupied = false
        for child in slot.spawn_point.get_children():
            child.queue_free()



var multi_attack_counts = {}
var multi_attack_limits = {
    675: 2, 
    788: 2, 
}

func can_monster_attack_again(slot, card_data: CardData) -> bool:
    if not card_data or not card_data.id in multi_attack_limits:
        return false

    var slot_id = _get_slot_id(slot)
    var card_attacks = multi_attack_counts.get(slot_id, {})
    var attack_count = card_attacks.get(card_data.id, 0)
    var max_attacks = multi_attack_limits[card_data.id]

    return attack_count < max_attacks

func register_monster_attack(slot, card_data: CardData):
    if not card_data or not card_data.id in multi_attack_limits:
        return

    var slot_id = _get_slot_id(slot)
    if not slot_id in multi_attack_counts:
        multi_attack_counts[slot_id] = {}

    var card_attacks = multi_attack_counts[slot_id]
    var current_count = card_attacks.get(card_data.id, 0)
    card_attacks[card_data.id] = current_count + 1

    var max_attacks = multi_attack_limits[card_data.id]
    print(card_data.name, ": Ataque registrado (", 
          card_attacks[card_data.id], "/", max_attacks, " neste turno)")

func has_monster_reached_attack_limit(slot, card_data: CardData) -> bool:
    if not card_data or not card_data.id in multi_attack_limits:
        return true

    var slot_id = _get_slot_id(slot)
    var card_attacks = multi_attack_counts.get(slot_id, {})
    var attack_count = card_attacks.get(card_data.id, 0)
    var max_attacks = multi_attack_limits[card_data.id]

    return attack_count >= max_attacks

func reset_multi_attack_counts():
    multi_attack_counts.clear()
    print("Contadores de ataque mÃºltiplo resetados")

func can_monster_have_multiple_attacks(card_data: CardData) -> bool:
    return card_data and card_data.id in multi_attack_limits




func _apply_pumpking_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Pumpking the King of Ghosts: Efeito ativado - Ganha +200 ATK/DEF por cada Zombie controlado")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var zombie_count = 0

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot == slot:
                continue

            var monster_data = owner_slot.stored_card_data


            var is_zombie = false
            is_zombie = "Zombie" in monster_data.type or "zombie" in monster_data.type.to_lower() or "ZOMBIE" in monster_data.type

            if is_zombie:
                zombie_count += 1
                print("  - Encontrado Zombie: ", monster_data.name)


    var bonus = zombie_count * PUMPKING_ZOMBIE_BONUS

    print("Pumpking the King of Ghosts: ", zombie_count, " Zombie(s) controlados â†’ +", bonus, " ATK/DEF")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data

        monster_data.atk += bonus
        monster_data.def += bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Pumpking the King of Ghosts: Novo ATK = ", monster_data.atk, ", DEF = ", monster_data.def)


func _apply_castle_of_dark_illusions_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Castle of Dark Illusions: Efeito ativado - Aumentando ATK/DEF de todos os monstros Zombie")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Crass Clown: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    _apply_castle_bonus_to_all_zombies()

func _apply_castle_bonus_to_all_zombies():
    print("Aplicando bÃ´nus do Castle a todos os Zombies no campo...")

    var player_slots = duel_manager.player_slots
    var enemy_slots = duel_manager.enemy_slots

    var all_slots = []
    all_slots.append_array(player_slots)
    all_slots.append_array(enemy_slots)

    var zombies_buffed = 0

    for slot in all_slots:
        if slot.is_occupied and slot.stored_card_data:
            var monster_data = slot.stored_card_data


            var is_zombie = "Zombie" in monster_data.type or "zombie" in monster_data.type.to_lower() or "ZOMBIE" in monster_data.type

            if is_zombie:
                zombies_buffed += 1

                monster_data.atk += CASTLE_OF_DARKNESS_ZOMBIE_BONUS
                monster_data.def += CASTLE_OF_DARKNESS_ZOMBIE_BONUS


                if slot.spawn_point.get_child_count() > 0:
                    var visual = slot.spawn_point.get_child(0)
                    if visual.has_method("animate_stats_bonus"):
                        visual.animate_stats_bonus(monster_data.atk, monster_data.def)

    print("Castle: ", zombies_buffed, " Zombie(s) receberam +500")


func _apply_swamp_battleguard_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Swamp Battleguard: Efeito ativado - Ganha +500 ATK para cada Lava Battleguard no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var lava_count = 0

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot != slot and owner_slot.stored_card_data.id == LAVA_BATTLEGUARD_ID:
                lava_count += 1
                print("  - Encontrado Lava Battleguard no slot")


    var bonus = lava_count * SWAMP_LAVA_BONUS

    print("Swamp Battleguard: ", lava_count, " Lava Battleguard(s) no campo â†’ +", bonus, " ATK")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        var original_card = CardDatabase.get_card(monster_data.id)
        var base_atk = original_card.atk if original_card else monster_data.atk


        monster_data.atk = base_atk + bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Swamp Battleguard: Novo ATK = ", monster_data.atk)

func _apply_lava_battleguard_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Lava Battleguard: Efeito ativado - Ganha +500 ATK para cada Swamp Battleguard no campo")

    if not duel_manager:
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var swamp_count = 0

    for owner_slot in owner_slots:
        if owner_slot.is_occupied and owner_slot.stored_card_data:

            if owner_slot != slot and owner_slot.stored_card_data.id == SWAMP_BATTLEGUARD_ID:
                swamp_count += 1
                print("  - Encontrado Swamp Battleguard no slot")


    var bonus = swamp_count * SWAMP_LAVA_BONUS

    print("Lava Battleguard: ", swamp_count, " Swamp Battleguard(s) no campo â†’ +", bonus, " ATK")


    if slot and slot.stored_card_data:
        var monster_data = slot.stored_card_data


        var original_card = CardDatabase.get_card(monster_data.id)
        var base_atk = original_card.atk if original_card else monster_data.atk


        monster_data.atk = base_atk + bonus


        if slot.spawn_point.get_child_count() > 0:
            var visual = slot.spawn_point.get_child(0)
            if visual.has_method("animate_stats_bonus"):
                visual.animate_stats_bonus(monster_data.atk, monster_data.def)

        print("Lava Battleguard: Novo ATK = ", monster_data.atk)

func update_battleguards_bonus(is_player_owner: bool):
    print("Atualizando bÃ´nus dos Battleguards...")

    if not duel_manager:
        return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    for slot in owner_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card_data = slot.stored_card_data

            if card_data.id == SWAMP_BATTLEGUARD_ID:
                await _apply_swamp_battleguard_effect(card_data, is_player_owner, slot)
            elif card_data.id == LAVA_BATTLEGUARD_ID:
                await _apply_lava_battleguard_effect(card_data, is_player_owner, slot)


func _effect_beastly_mirror_ritual(is_player_owner: bool):
    print("Beastly Mirror Ritual: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_beastly_mirror_ritual(owner_hand):
        print("Beastly Mirror Ritual: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Beastly Mirror Ritual: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_beastly_mirror_ritual(is_player_owner, owner_hand)

    print("Beastly Mirror Ritual: Ritual completo!")

func _has_all_required_cards_beastly_mirror_ritual(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_BEASTLY_MIRROR_RITUAL:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_BEASTLY_MIRROR_RITUAL:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Beastly Mirror Ritual: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_beastly_mirror_ritual(is_player_owner: bool, hand: Array[CardData]):
    print("Beastly Mirror Ritual: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Beastly Mirror Ritual: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Beastly Mirror Ritual: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_BEASTLY_MIRROR_RITUAL:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_beastly_mirror_ritual(is_player_owner)

func _summon_special_card_beastly_mirror_ritual(is_player_owner: bool):
    print("Beastly Mirror Ritual: Invocando carta especial ID ", SUMMONED_CARD_BEASTLY_MIRROR_RITUAL_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_BEASTLY_MIRROR_RITUAL_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_BEASTLY_MIRROR_RITUAL_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Beastly Mirror Ritual: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Beastly Mirror Ritual: Carta especial invocada com sucesso!")


func _effect_black_luster_ritual(is_player_owner: bool):
    print("Black Luster Ritual: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_black_luster_ritual(owner_hand):
        print("Black Luster Ritual: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Black Luster Ritual: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_black_luster_ritual(is_player_owner, owner_hand)

    print("Black Luster Ritual: Ritual completo!")

func _has_all_required_cards_black_luster_ritual(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_BLACK_LUSTER_RITUAL:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_BLACK_LUSTER_RITUAL:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Black Luster Ritual: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_black_luster_ritual(is_player_owner: bool, hand: Array[CardData]):
    print("Black Luster Ritual: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Black Luster Ritual: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Black Luster Ritual: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_BLACK_LUSTER_RITUAL:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_black_luster_ritual(is_player_owner)

func _summon_special_card_black_luster_ritual(is_player_owner: bool):
    print("Black Luster Ritual: Invocando carta especial ID ", SUMMONED_CARD_BLACK_LUSTER_RITUAL_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_BLACK_LUSTER_RITUAL_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_BLACK_LUSTER_RITUAL_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Black Luster Ritual: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Black Luster Ritual: Carta especial invocada com sucesso!")


func _effect_zera_ritual(is_player_owner: bool):
    print("Zera Ritual: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_zera_ritual(owner_hand):
        print("Zera Ritual: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Zera Ritual: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_zera_ritual(is_player_owner, owner_hand)

    print("Zera RItual: Ritual completo!")

func _has_all_required_cards_zera_ritual(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_ZERA_RITUAL:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_ZERA_RITUAL:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Zera Ritual: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_zera_ritual(is_player_owner: bool, hand: Array[CardData]):
    print("Zera Ritual: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Zera Ritual: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Zera Ritual: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_ZERA_RITUAL:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_zera_ritual(is_player_owner)

func _summon_special_card_zera_ritual(is_player_owner: bool):
    print("Zera Ritual: Invocando carta especial ID ", SUMMONED_CARD_ZERA_RITUAL_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_ZERA_RITUAL_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_ZERA_RITUAL_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Zera Ritual: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Zera Ritual: Carta especial invocada com sucesso!")


func _effect_warlion_ritual(is_player_owner: bool):
    print("Warlion Ritual: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_warlion_ritual(owner_hand):
        print("Warlion Ritual: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Warlion Ritual: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_warlion_ritual(is_player_owner, owner_hand)

    print("Warlion Ritual: Ritual completo!")

func _has_all_required_cards_warlion_ritual(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_WARLION_RITUAL:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_WARLION_RITUAL:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Warlion Ritual: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_warlion_ritual(is_player_owner: bool, hand: Array[CardData]):
    print("Warlion Ritual: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Warlion Ritual: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Warlion Ritual: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_WARLION_RITUAL:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_warlion_ritual(is_player_owner)

func _summon_special_card_warlion_ritual(is_player_owner: bool):
    print("Warlion Ritual: Invocando carta especial ID ", SUMMONED_CARD_WARLION_RITUAL_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_WARLION_RITUAL_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_WARLION_RITUAL_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Warlion Ritual: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Warlion Ritual: Carta especial invocada com sucesso!")


func _effect_novox_prayer(is_player_owner: bool):
    print("Novox Prayer: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_novox_prayer(owner_hand):
        print("Novox Prayer: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Novox Prayer: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_novox_prayer(is_player_owner, owner_hand)

    print("Novox Prayer: Ritual completo!")

func _has_all_required_cards_novox_prayer(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_NOVOX_PRAYER:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_NOVOX_PRAYER:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Novox Prayer: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_novox_prayer(is_player_owner: bool, hand: Array[CardData]):
    print("Novox Prayer: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Novox Prayer: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Novox Prayer: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_NOVOX_PRAYER:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_novox_prayer(is_player_owner)

func _summon_special_card_novox_prayer(is_player_owner: bool):
    print("Novox Prayer: Invocando carta especial ID ", SUMMONED_CARD_NOVOX_PRAYER_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_NOVOX_PRAYER_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_NOVOX_PRAYER_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Novox Prayer: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Novox Prayer: Carta especial invocada com sucesso!")


func _effect_commencement_dance(is_player_owner: bool):
    print("Commencement Dance: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_commencement_dance(owner_hand):
        print("Commencement Dance: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Commencement Dance: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_commencement_dance(is_player_owner, owner_hand)




    print("Commencement Dance: Ritual completo!")

func _has_all_required_cards_commencement_dance(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_COMMENCEMENT_DANCE:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_COMMENCEMENT_DANCE:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Commencement Dance: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_commencement_dance(is_player_owner: bool, hand: Array[CardData]):
    print("Commencement Dance: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Commencement Dance: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Commencement Dance: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_COMMENCEMENT_DANCE:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_commencement_dance(is_player_owner)

func _summon_special_card_commencement_dance(is_player_owner: bool):
    print("Commencement Dance: Invocando carta especial ID ", SUMMONED_CARD_COMMENCEMENT_DANCE_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_COMMENCEMENT_DANCE_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_COMMENCEMENT_DANCE_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Commencement Dance: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Commencement Dance: Carta especial invocada com sucesso!")


func _effect_javelin_beetle_pact(is_player_owner: bool):
    print("Javelin Beetle Pact: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_javelin_beetle_pact(owner_hand):
        print("Javelin Beetle Pact: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Javelin Beetle Pact: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_javelin_beetle_pact(is_player_owner, owner_hand)

    print("Javelin Beetle Pact: Ritual completo!")

func _has_all_required_cards_javelin_beetle_pact(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_JAVELIN_BEETLE:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_JAVELIN_BEETLE:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Javelin Beetle Pact: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_javelin_beetle_pact(is_player_owner: bool, hand: Array[CardData]):
    print("Javelin Beetle Pact: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Javelin Beetle Pact: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Javelin Beetle Pact: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_JAVELIN_BEETLE:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_javelin_beetle_pact(is_player_owner)

func _summon_special_card_javelin_beetle_pact(is_player_owner: bool):
    print("Javelin Beetle Pact: Invocando carta especial ID ", SUMMONED_CARD_JAVELIN_BEETLE_PACT_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_JAVELIN_BEETLE_PACT_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_JAVELIN_BEETLE_PACT_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Javelin Beetle Pact: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Javelin Beetle Pact: Carta especial invocada com sucesso!")


func _effect_black_magic_ritual(is_player_owner: bool):
    print("Black Magic Ritual: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_black_magic_ritual(owner_hand):
        print("Black Magic Ritual: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Black Magic Ritual: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_black_magic_ritual(is_player_owner, owner_hand)

    print("Black Magic Ritual: Ritual completo!")

func _has_all_required_cards_black_magic_ritual(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_BLACK_MAGIC_RITUAL:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_BLACK_MAGIC_RITUAL:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Black Magic Ritual: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_black_magic_ritual(is_player_owner: bool, hand: Array[CardData]):
    print("Black Magic Ritual: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Black Magic Ritual: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Black Magic Ritual: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_BLACK_MAGIC_RITUAL:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_black_magic_ritual(is_player_owner)

func _summon_special_card_black_magic_ritual(is_player_owner: bool):
    print("Black Magic Ritual: Invocando carta especial ID ", SUMMONED_CARD_BLACK_MAGIC_RITUAL_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_BLACK_MAGIC_RITUAL_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_BLACK_MAGIC_RITUAL_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Black Magic Ritual: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Black Magic Ritual: Carta especial invocada com sucesso!")


func _effect_fortress_whale_oath(is_player_owner: bool):
    print("Fortress Whale Oath: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_fortress_whale_oath(owner_hand):
        print("Fortress Whale Oath: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Fortress Whale Oath: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_fortress_whale_oath(is_player_owner, owner_hand)

    print("Fortress Whale Oath: Ritual completo!")

func _has_all_required_cards_fortress_whale_oath(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_FORTRESS_WHALE_OATH:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_FORTRESS_WHALE_OATH:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Fortress Whale Oath: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_fortress_whale_oath(is_player_owner: bool, hand: Array[CardData]):
    print("Fortress Whale Oath: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Fortress Whale Oath: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Fortress Whale Oath: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_FORTRESS_WHALE_OATH:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_fortress_whale_oath(is_player_owner)

func _summon_special_card_fortress_whale_oath(is_player_owner: bool):
    print("Fortress Whale Oath: Invocando carta especial ID ", SUMMONED_CARD_FORTRESS_WHALE_OATH_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_FORTRESS_WHALE_OATH_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_FORTRESS_WHALE_OATH_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Fortress Whale Oath: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Fortress Whale Oath: Carta especial invocada com sucesso!")


func _effect_garma_sword_oath(is_player_owner: bool):
    print("Garma Sword Oath: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_garma_sword_oath(owner_hand):
        print("Garma Sword Oath: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Garma Sword Oath: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_garma_sword_oath(is_player_owner, owner_hand)

    print("Garma Sword Oath: Ritual completo!")

func _has_all_required_cards_garma_sword_oath(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_GARMA_SWORD_OATH:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_GARMA_SWORD_OATH:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Garma Sword Oath: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_garma_sword_oath(is_player_owner: bool, hand: Array[CardData]):
    print("Garma Sword Oath: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Garma Sword Oath: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Garma Sword Oath: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_GARMA_SWORD_OATH:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_garma_sword_oath(is_player_owner)

func _summon_special_card_garma_sword_oath(is_player_owner: bool):
    print("Garma Sword Oath: Invocando carta especial ID ", SUMMONED_CARD_GARMA_SWORD_OATH_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_GARMA_SWORD_OATH_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_GARMA_SWORD_OATH_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Garma Sword Oath: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Garma Sword Oath: Carta especial invocada com sucesso!")


func _effect_resurrection_of_chakra(is_player_owner: bool):
    print("Resurrection of Chakra: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_resurrection_of_chakra(owner_hand):
        print("Resurrection of Chakra: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Resurrection of Chakra: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_resurrection_of_chakra(is_player_owner, owner_hand)

    print("Resurrection of Chakra: Ritual completo!")

func _has_all_required_cards_resurrection_of_chakra(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_RESURRECTION_OF_CHAKRA:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_RESURRECTION_OF_CHAKRA:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Resurrection of Chakra: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_resurrection_of_chakra(is_player_owner: bool, hand: Array[CardData]):
    print("Resurrection of Chakra: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Resurrection of Chakra: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Resurrection of Chakra: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_RESURRECTION_OF_CHAKRA:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_resurrection_of_chakra(is_player_owner)

func _summon_special_card_resurrection_of_chakra(is_player_owner: bool):
    print("Resurrection of Chakra: Invocando carta especial ID ", SUMMONED_CARD_RESURRECTION_OF_CHAKRA_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_RESURRECTION_OF_CHAKRA_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_RESURRECTION_OF_CHAKRA_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Resurrection of Chakra: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Resurrection of Chakra: Carta especial invocada com sucesso!")


func _effect_turtle_oath(is_player_owner: bool):
    print("Turtle Oath: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_turtle_oath(owner_hand):
        print("Turtle Oath: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Turtle Oath: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_turtle_oath(is_player_owner, owner_hand)

    print("Turtle Oath: Ritual completo!")

func _has_all_required_cards_turtle_oath(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_TURTLE_OATH:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_TURTLE_OATH:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Turtle Oath: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_turtle_oath(is_player_owner: bool, hand: Array[CardData]):
    print("Turtle Oath: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Turtle Oath: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Turtle Oath: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_TURTLE_OATH:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_turtle_oath(is_player_owner)

func _summon_special_card_turtle_oath(is_player_owner: bool):
    print("Turtle Oath: Invocando carta especial ID ", SUMMONED_CARD_TURTLE_OATH_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_TURTLE_OATH_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_TURTLE_OATH_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Turtle Oath: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Turtle Oath: Carta especial invocada com sucesso!")


func _effect_revival_of_dokurorider(is_player_owner: bool):
    print("Revival of Dokurorider: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_revival_of_dokurorider(owner_hand):
        print("Revival of Dokurorider: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Revival of Dokurorider: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_revival_of_dokurorider(is_player_owner, owner_hand)

    print("Revival of Dokurorider: Ritual completo!")

func _has_all_required_cards_revival_of_dokurorider(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_REVIVAL_OF_DOKURORIDER:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_REVIVAL_OF_DOKURORIDER:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Revival of Dokurorider: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_revival_of_dokurorider(is_player_owner: bool, hand: Array[CardData]):
    print("Revival of Dokurorider: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Revival of Dokurorider: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Revival of Dokurorider: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_REVIVAL_OF_DOKURORIDER:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_revival_of_dokurorider(is_player_owner)

func _summon_special_card_revival_of_dokurorider(is_player_owner: bool):
    print("Revival of Dokurorider: Invocando carta especial ID ", SUMMONED_CARD_REVIVAL_OF_DOKURORIDER_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_REVIVAL_OF_DOKURORIDER_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_REVIVAL_OF_DOKURORIDER_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Revival of Dokurorider: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Revival of Dokurorider: Carta especial invocada com sucesso!")


func _effect_hamburger_recipe(is_player_owner: bool):
    print("Hamburger Recipe: Efeito ativado!")

    if not duel_manager:
        return


    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    if not _has_all_required_cards_hamburger_recipe(owner_hand):
        print("Hamburger Recipe: Cartas necessÃ¡rias nÃ£o encontradas na mÃ£o")
        return

    print("Hamburger Recipe: Cartas necessÃ¡rias encontradas!")


    await _send_required_cards_to_graveyard_hamburger_recipe(is_player_owner, owner_hand)

    print("Hamburger Recipe: Ritual completo!")

func _has_all_required_cards_hamburger_recipe(hand: Array[CardData]) -> bool:

    var found_ids = []

    for card in hand:
        if card and card.id in REQUIRED_CARDS_HAMBURGER_RECIPE:
            if not card.id in found_ids:
                found_ids.append(card.id)


    var has_all = true
    for required_id in REQUIRED_CARDS_HAMBURGER_RECIPE:
        if not required_id in found_ids:
            print("  - Falta carta ID: ", required_id)
            has_all = false

    if has_all:
        print("Hamburger Recipe: Encontrou todas as cartas necessÃ¡rias")
        for id in found_ids:
            print("  - ID ", id, " encontrado")

    return has_all

func _send_required_cards_to_graveyard_hamburger_recipe(is_player_owner: bool, hand: Array[CardData]):
    print("Hamburger Recipe: Enviando cartas para o cemitÃ©rio...")


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var has_empty_slot = false

    for slot in owner_slots:
        if not slot.is_occupied:
            has_empty_slot = true
            break

    if not has_empty_slot:
        print("Hamburger Recipe: Nenhum slot vazio para invocar a carta especial! Cartas NÃƒO serÃ£o enviadas para o cemitÃ©rio.")
        return

    print("Hamburger Recipe: Slot vazio encontrado, enviando cartas para o cemitÃ©rio...")


    var hand_array = hand if hand != null else (duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand)


    for required_id in REQUIRED_CARDS_HAMBURGER_RECIPE:

        var card_index = -1
        var found_card = null

        for i in range(hand_array.size()):
            if hand_array[i] and hand_array[i].id == required_id:
                card_index = i
                found_card = hand_array[i]
                break

        if found_card and card_index != -1:
            print("  - Enviando ", found_card.name, " (ID: ", found_card.id, ") para cemitÃ©rio e removendo da mÃ£o")


            hand_array[card_index] = null


            if duel_manager.has_method("send_to_graveyard"):
                duel_manager.send_to_graveyard(found_card, is_player_owner)


            if is_player_owner:
                duel_manager.update_hand_ui()
            else:
                duel_manager.update_enemy_hand_ui()

            await get_tree().create_timer(0.2).timeout


    await _summon_special_card_hamburger_recipe(is_player_owner)

func _summon_special_card_hamburger_recipe(is_player_owner: bool):
    print("Hamburger Recipe: Invocando carta especial ID ", SUMMONED_CARD_HAMBURGER_RECIPE_ID)


    var special_card = CardDatabase.get_card(SUMMONED_CARD_HAMBURGER_RECIPE_ID)
    if not special_card:
        print("ERRO: Carta especial ID ", SUMMONED_CARD_HAMBURGER_RECIPE_ID, " nÃ£o encontrada!")
        return


    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var empty_slot = null

    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if not empty_slot:
        print("Hamburger Recipe: Nenhum slot vazio para invocar!")
        return


    print("  - Invocando ", special_card.name, " no slot vazio")

    if is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            true


        )

    if not is_player_owner:
        duel_manager.has_method("spawn_card_on_field")

        duel_manager.spawn_card_on_field(
            special_card, 
            empty_slot, 
            false, 
            false


        )

    print("Hamburger Recipe: Carta especial invocada com sucesso!")


func _apply_time_wizard_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Time Wizard: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    var final_number = await _show_number_roulette(is_player_owner)


    if final_number % 2 == 0:
        print("Time Wizard: PAR! Destruindo monstros do OPONENTE")
        await _destroy_opponent_monsters(is_player_owner)
    else:
        print("Time Wizard: ÃMPAR! Destruindo monstros do DONO")
        await _destroy_owner_monsters(is_player_owner)

func _show_number_roulette(_is_player_owner: bool) -> int:
    if not duel_manager:
        return 1

    var numbers = []
    var current_number = 1


    var center_label = Label.new()
    center_label.name = "RouletteNumber"
    center_label.add_theme_font_size_override("font_size", 100)
    center_label.add_theme_color_override("font_color", Color.WHITE)
    center_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    center_label.position = duel_manager.get_viewport().get_visible_rect().size / 2 - Vector2(-130, 135)
    duel_manager.add_child(center_label)
    numbers.append(center_label)


    var final_number = randi() % 10 + 1


    var _spin_time = 2.0
    var number_count = 15

    for i in range(number_count):

        var progress = float(i) / number_count
        var speed = 0.15 * (1.0 - progress * 0.8)


        if i < number_count - 3:
            current_number = randi() % 10 + 1
        else:

            current_number = final_number


        center_label.text = str(current_number)


        var tween = create_tween()
        tween.set_parallel(true)
        tween.tween_property(center_label, "modulate:a", 1.0, speed * 0.3)
        tween.tween_property(center_label, "scale", Vector2(1.3, 1.3), speed * 0.3)

        await get_tree().create_timer(speed * 0.5).timeout

        tween = create_tween()
        tween.tween_property(center_label, "modulate:a", 0.3, speed * 0.3)
        tween.tween_property(center_label, "scale", Vector2(1.0, 1.0), speed * 0.3)

        await get_tree().create_timer(speed * 0.5).timeout


    center_label.text = str(final_number)
    center_label.add_theme_color_override("font_color", 
        Color(0.0, 0.853, 0.455, 1.0) if final_number % 2 == 0 else Color.RED)

    var final_tween = create_tween()
    final_tween.set_parallel(true)
    final_tween.tween_property(center_label, "modulate:a", 1.0, 0.5)
    final_tween.tween_property(center_label, "scale", Vector2(1.5, 1.5), 0.5)

    await get_tree().create_timer(1.0).timeout


    center_label.queue_free()


    return final_number

func _destroy_opponent_monsters(is_player_owner: bool):
    var opponent_is_player = not is_player_owner
    var target_slots = duel_manager.player_slots if opponent_is_player else duel_manager.enemy_slots

    print("Destruindo monstros do ", "Jogador" if opponent_is_player else "IA")

    for slot in target_slots:
        if slot.is_occupied:
            print("Destruindo: ", slot.stored_card_data.name)
            await duel_manager._destroy_card(slot)

func _destroy_owner_monsters(is_player_owner: bool):
    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots

    print("Destruindo monstros do ", "Jogador" if is_player_owner else "IA")


    for slot in owner_slots:
        if slot.is_occupied:
            await duel_manager._destroy_card(slot)


func _effect_dark_piercing_light(is_player_owner: bool):
    print("EffectManager: Ativando Dark-piercing Light!")


    var target_is_player = not is_player_owner

    print("Dark-piercing Light: Ativado por ", "Jogador" if is_player_owner else "Inimigo")
    print("Dark-piercing Light: Alvo Ã© ", "Jogador" if target_is_player else "Inimigo")


    await _reveal_all_face_down_monsters(target_is_player)

    print("Dark-piercing Light: Efeito completo!")

func _reveal_all_face_down_monsters(target_is_player: bool):
    if not duel_manager:
        return

    var target_slots = duel_manager.player_slots if target_is_player else duel_manager.enemy_slots

    var revealed_count = 0

    for slot in target_slots:
        if slot.is_occupied:
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
            if card_visual and _is_card_face_down(card_visual, target_is_player):

                _reveal_single_card(card_visual, target_is_player)
                revealed_count += 1


                await get_tree().create_timer(0.1).timeout

    print("Dark-piercing Light: Reveladas ", revealed_count, " cartas face-down")

func _is_card_face_down(card_visual, _is_player_card: bool) -> bool:


    if card_visual.has_method("is_face_down"):
        return card_visual.is_face_down()


    elif duel_manager.has_method("_has_card_back"):
        return duel_manager._has_card_back(card_visual)

    return false

func _reveal_single_card(card_visual, _is_player_card: bool):


    if card_visual.has_method("set_face_down"):
        card_visual.set_face_down(false)


func _effect_swords_of_revealing_light(is_player_owner: bool):
    print("EffectManager: Ativando Swords of Revealing Light!")

    var was_already_active = false


    if is_player_owner:
        if swords_player_active:
            print("Swords: Jogador jÃ¡ tem Swords ativo, resetando contador.")
            was_already_active = true
        swords_player_active = true
        swords_player_turns_remaining = SWORDS_OF_REVEALING_LIGHT_TURNS
        swords_player_turn_counter = 0
    else:
        if swords_enemy_active:
            print("Swords: Inimigo jÃ¡ tem Swords ativo, resetando contador.")
            was_already_active = true
        swords_enemy_active = true
        swords_enemy_turns_remaining = SWORDS_OF_REVEALING_LIGHT_TURNS
        swords_enemy_turn_counter = 0


    var target_is_player = not is_player_owner

    print("Swords of Revealing Light: Ativado por ", "Jogador" if is_player_owner else "Inimigo")
    print("Swords of Revealing Light: Alvo Ã© ", "Jogador" if target_is_player else "Inimigo")


    _reveal_all_opponent_monsters(target_is_player)


    if not was_already_active:
        await _apply_swords_visual_effect(target_is_player)
    else:

        _play_swords_sound()





func _reveal_all_opponent_monsters(target_is_player: bool):
    if not duel_manager:
        return

    var target_slots = duel_manager.player_slots if target_is_player else duel_manager.enemy_slots

    for slot in target_slots:
        if slot.is_occupied:
            if target_is_player:

                if duel_manager.has_method("reveal_player_card_in_slot"):
                    duel_manager.reveal_player_card_in_slot(slot)
            else:

                if duel_manager.has_method("reveal_enemy_card_in_slot"):
                    duel_manager.reveal_enemy_card_in_slot(slot)

            print("Swords: Revelando carta: ", slot.stored_card_data.name)

func _apply_swords_visual_effect(target_is_player: bool) -> void :
    if not duel_manager:
        return


    await _clear_swords_effects(target_is_player)


    _play_swords_sound()


    var layer_name = "PlayerLightSwords" if target_is_player else "EnemyLightSwords"
    var full_path = "Battlefield/" + layer_name


    var target_layer = duel_manager.get_node(full_path)


    if not target_layer:
        print("ERRO: NÃ£o encontrei a camada: ", full_path)
        return


    target_layer.visible = true
    target_layer.modulate = Color(1, 1, 1, 0)


    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(target_layer, "modulate:a", 1.0, 0.8)


    var original_position = target_layer.position
    target_layer.position = original_position - Vector2(0, 20)

    tween.tween_property(target_layer, "position", original_position, 0.8)

    await tween.finished


    _start_swords_float_animation(target_layer)

    print("Swords of Revealing Light: Efeito aplicado no ", layer_name)

func _start_swords_float_animation(layer: Control):
    if not layer:
        return

    var tween_float = create_tween()
    tween_float.bind_node(layer)
    tween_float.set_loops()


    var original_y = layer.position.y

    tween_float.tween_property(layer, "position:y", original_y - 3, 1.2)
    tween_float.tween_property(layer, "position:y", original_y + 3, 1.2)
    tween_float.tween_property(layer, "position:y", original_y, 1.2)

func _play_swords_sound():
    var sound_path = "res://assets/sounds/sfx/light.wav"
    if ResourceLoader.exists(sound_path):
        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func update_swords_on_player_turn():

    if swords_enemy_active:
        swords_enemy_turn_counter += 1
        print("Swords (jogada pelo inimigo): Turno ", swords_enemy_turn_counter, 
              " de ", SWORDS_OF_REVEALING_LIGHT_TURNS)

        if swords_enemy_turn_counter >= SWORDS_OF_REVEALING_LIGHT_TURNS:
            _end_swords_effect_for(false)
            print("Swords of Revealing Light: Efeito do inimigo terminou")


func update_swords_on_enemy_turn():

    if swords_player_active:
        swords_player_turn_counter += 1
        print("Swords (jogada pelo jogador): Turno ", swords_player_turn_counter, 
              " de ", SWORDS_OF_REVEALING_LIGHT_TURNS)

        if swords_player_turn_counter >= SWORDS_OF_REVEALING_LIGHT_TURNS:
            _end_swords_effect_for(true)
            print("Swords of Revealing Light: Efeito do jogador terminou")

func can_monster_attack(slot_owner_is_player: bool, slot) -> bool:

    if swords_player_active and not slot_owner_is_player:
        print(slot.stored_card_data.name if slot.stored_card_data else "Monstro", 
              " nÃ£o pode atacar devido a Swords of Revealing Light (do jogador)")
        return false


    if swords_enemy_active and slot_owner_is_player:
        print(slot.stored_card_data.name if slot.stored_card_data else "Monstro", 
              " nÃ£o pode atacar devido a Swords of Revealing Light (do inimigo)")
        return false

    return true

func can_place_card_face_down(slot_owner_is_player: bool) -> bool:

    if swords_player_active and not slot_owner_is_player:
        print("Swords of Revealing Light (do jogador) impede cartas face-down")
        return false

    if swords_enemy_active and slot_owner_is_player:
        print("Swords of Revealing Light (do inimigo) impede cartas face-down")
        return false

    return true


func _end_swords_effect_for(is_player_swords: bool):
    if is_player_swords:
        swords_player_active = false
        swords_player_turn_counter = 0

        _clear_swords_effects(false)
    else:
        swords_enemy_active = false
        swords_enemy_turn_counter = 0

        _clear_swords_effects(true)


    if duel_manager and duel_manager.has_method("on_swords_effect_ended"):
        duel_manager.on_swords_effect_ended()


func _end_swords_effect():
    swords_player_active = false
    swords_player_turn_counter = 0
    swords_enemy_active = false
    swords_enemy_turn_counter = 0

    _clear_swords_effects(true)
    _clear_swords_effects(false)

    if duel_manager and duel_manager.has_method("on_swords_effect_ended"):
        duel_manager.on_swords_effect_ended()

func _clear_swords_effects(clear_player_layer: bool = true, clear_both: bool = false):
    if not duel_manager:
        return


    var layers_to_clear = []

    if clear_both or clear_player_layer:
        var player_layer = duel_manager.get_node("Battlefield/PlayerLightSwords")
        if player_layer: layers_to_clear.append(player_layer)

    if clear_both or not clear_player_layer:
        var enemy_layer = duel_manager.get_node("Battlefield/EnemyLightSwords")
        if enemy_layer: layers_to_clear.append(enemy_layer)


    for layer in layers_to_clear:
        if layer and layer.visible:

            var tween = create_tween()
            tween.tween_property(layer, "modulate:a", 0, 0.3)
            await tween.finished


            layer.visible = false

    print("Swords of Revealing Light: Efeitos removidos para alvos")


func _effect_raigeki(is_player_owner: bool):
    print("Aplicando Raigeki: Destruindo todos os monstros do oponente.")

    if not duel_manager:
        return


    var target_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots

    for slot in target_slots:
        if slot.is_occupied:
            await _destroy_card_with_explosion(slot, duel_manager)

    print("Raigeki: Efeito completo!")


func _destroy_card_with_explosion(slot, duel_manager_ref):
    if not slot or not slot.is_occupied:
        return


    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual and is_instance_valid(card_visual):

        var global_pos = card_visual.global_position




        var is_enemy_card = global_pos.y < duel_manager_ref.get_viewport().get_visible_rect().size.y * 0.5


        await _create_card_explosion_with_direction(global_pos, card_visual, is_enemy_card)


        _play_thunder_sound()


        await _animate_card_destruction(card_visual, is_enemy_card)


        await get_tree().create_timer(0.1).timeout


    duel_manager._destroy_card(slot)

func _play_thunder_sound():

    var sound_path = "res://assets/sounds/sfx/thunder.wav"
    if ResourceLoader.exists(sound_path):

        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)

        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()


func _create_card_explosion_with_direction(position: Vector2, card_visual, is_enemy_card: bool):
    if not duel_manager or not is_instance_valid(duel_manager):
        return

    var explosion_count = 10
    var radius = card_visual.size.x * card_visual.scale.x * 0.5

    for i in range(explosion_count):
        var angle = (i * 2 * PI) / explosion_count
        var offset = Vector2(cos(angle), sin(angle)) * radius
        var explosion_pos = position + offset


        _create_directional_explosion_particle(explosion_pos, is_enemy_card)

        await get_tree().create_timer(0.02).timeout


func _create_directional_explosion_particle(position: Vector2, is_enemy_card: bool):
    if not duel_manager or not is_instance_valid(duel_manager):
        return

    var particle = ColorRect.new()
    particle.color = Color(1, 0.7, 0.2)
    particle.size = Vector2(8, 8)
    particle.pivot_offset = particle.size / 2
    particle.position = position - particle.size / 2
    particle.modulate.a = 1.0


    var style = StyleBoxFlat.new()
    style.corner_radius_top_left = 100
    style.corner_radius_top_right = 100
    style.corner_radius_bottom_left = 100
    style.corner_radius_bottom_right = 100
    style.bg_color = particle.color
    particle.add_theme_stylebox_override("panel", style)

    duel_manager.add_child(particle)

    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)




    var direction = Vector2(randf_range(-1, 1), -1 if is_enemy_card else 1).normalized()
    var target_pos = position + (direction * 80)
    tween.tween_property(particle, "position", target_pos, 0.3)
    tween.tween_property(particle, "scale", Vector2.ZERO, 0.3)
    tween.tween_property(particle, "modulate:a", 0, 0.3)


    tween.chain().tween_callback( func():
        particle.queue_free()
    )


func _animate_card_destruction(card_visual, is_enemy_card: bool):
    if not card_visual or not is_instance_valid(card_visual):
        return

    var tween = create_tween()
    tween.set_parallel(true)


    tween.tween_property(card_visual, "modulate", Color(1, 0.3, 0.3), 0.1)
    tween.tween_property(card_visual, "modulate", Color(1, 0.6, 0.2), 0.1).set_delay(0.1)
    tween.tween_property(card_visual, "modulate", Color(1, 0.9, 0.1), 0.1).set_delay(0.2)

    await tween.finished


func _effect_field_forest(_is_player_owner: bool):
    print("EffectManager: Ativando Forest.")

    if duel_manager:
        duel_manager.set_field_type("Forest")

func _effect_wasteland(_is_player_owner: bool):
    print("EffectManager: Ativando Wasteland.")

    if duel_manager:
        duel_manager.set_field_type("Wasteland")

func _effect_mountain(_is_player_owner: bool):
    print("EffectManager: Ativando Mountain.")

    if duel_manager:
        duel_manager.set_field_type("Mountain")

func _effect_sogen(_is_player_owner: bool):
    print("EffectManager: Ativando Sogen.")

    if duel_manager:
        duel_manager.set_field_type("Sogen")

func _effect_umi(_is_player_owner: bool):
    print("EffectManager: Ativando Umi.")

    if duel_manager:
        duel_manager.set_field_type("Umi")

func _effect_yami(_is_player_owner: bool):
    print("EffectManager: Ativando Yami.")

    if duel_manager:
        duel_manager.set_field_type("Yami")

func _effect_gaia_power(_is_player_owner: bool):
    print("EffectManager: Ativando Gaia Power.")

    if duel_manager:
        duel_manager.set_field_type("Gaia Power")

func _effect_field_jurassic_world(_is_player_owner: bool):
    print("EffectManager: Ativando Jurassic World.")

    if duel_manager:
        duel_manager.set_field_type("Jurassic World")


func is_valid_equip_target(monster: CardData, equip_id: int) -> bool:
    if not monster:
        return false

    match equip_id:
        EQUIP_DARK_ENERGY:
            return _is_valid_dark_energy_target(monster)
        EQUIP_LEGENDARY_SWORD:
            return _is_valid_legendary_sword_target(monster)
        EQUIP_SWORD_DARK_DESTRUCTION:
            return _is_valid_dark_destruction_target(monster)
        EQUIP_AXE_OF_DESPAIR:
            return _is_valid_axe_of_despair_target(monster)
        EQUIP_LASER_CANNON_ARMOR:
            return _is_valid_laser_cannon_armor_target(monster)
        EQUIP_INSECT_ARMOR_WITH_LASER_CANNON:
            return _is_valid_insect_armor_laser_cannon_target(monster)
        EQUIP_ELFS_LIGHT:
            return _is_valid_elfs_light_target(monster)
        EQUIP_BEAST_FANGS:
            return _is_valid_beast_fangs_target(monster)
        EQUIP_STEEL_SHELL:
            return _is_valid_steel_shell_target(monster)
        EQUIP_VILE_GERMS:
            return _is_valid_vile_germs_target(monster)
        EQUIP_BLACK_PENDANT:
            return _is_valid_black_pendant_target(monster)
        EQUIP_SILVER_BOW_ARROW:
            return _is_valid_silver_bow_arrow_target(monster)
        EQUIP_HORN_OF_LIGHT:
            return _is_valid_horn_of_light_target(monster)
        EQUIP_HORN_OF_THE_UNICORN:
            return _is_valid_horn_of_the_unicorn_target(monster)
        EQUIP_DRAGON_TREASURE:
            return _is_valid_dragon_treasure_target(monster)
        EQUIP_ELECTRO_WHIP:
            return _is_valid_electro_whip_target(monster)
        EQUIP_CYBER_SHIELD:
            return _is_valid_cyber_shield_target(monster)
        EQUIP_ELEGANT_EGOTIST:
            return _is_valid_elegant_egotist_target(monster)
        EQUIP_MYSTICAL_MOON:
            return _is_valid_mystical_moon_target(monster)
        EQUIP_MALEVOLENT_NUZZLER:
            return _is_valid_malevolent_nuzzler_target(monster)
        EQUIP_VIOLET_CRYSTAL:
            return _is_valid_violet_crystal_target(monster)
        EQUIP_BOOK_OF_SECRET_ARTS:
            return _is_valid_book_of_secret_arts_target(monster)
        EQUIP_INVIGORATION:
            return _is_valid_invigoration_target(monster)
        EQUIP_MACHINE_CONVERSION_FACTORY:
            return _is_valid_machine_conversion_factory_target(monster)
        EQUIP_RAISE_BODY_HEAT:
            return _is_valid_raise_body_heat_target(monster)
        EQUIP_FOLLOW_WIND:
            return _is_valid_follow_wind_target(monster)
        EQUIP_POWER_OF_KAISHIN:
            return _is_valid_power_of_kaishin_target(monster)
        EQUIP_SALAMANDRA:
            return _is_valid_salamandra_target(monster)
        EQUIP_MAGICAL_LABYRINTH:
            return _is_valid_magical_labyrinth_target(monster)
        EQUIP_MEGAMORPH:
            return _is_valid_megamorph_target(monster)
        EQUIP_METALMORPH:
            return _is_valid_metalmorph_target(monster)
        EQUIP_GUST_FAN:
            return _is_valid_gust_fan_target(monster)
        EQUIP_SWORD_DEEP_SEATED:
            return true
        EQUIP_PHOTON_BOOSTER:
            return monster.type.to_lower() == "fairy" and monster.level <= 4
        EQUIP_GRAVITY_AXE_GRARL:
            return _is_valid_gravity_axe_grarl_target(monster)
        EQUIP_RARE_METALMORPH:
            return _is_valid_rare_metalmorph_target(monster)
        _:
            return false

func _is_valid_dark_energy_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type == "fiend"

func _is_valid_legendary_sword_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in LEGENDARY_SWORD_TYPES

func _is_valid_dark_destruction_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in DARK_DESTRUCTION_ATTRIBUTE

func _is_valid_axe_of_despair_target(_monster: CardData) -> bool:

    return true

func _is_valid_gravity_axe_grarl_target(_monster: CardData) -> bool:

    return true

func _is_valid_megamorph_target(_monster: CardData) -> bool:

    return true

func _is_valid_metalmorph_target(_monster: CardData) -> bool:

    return true

func _is_valid_rare_metalmorph_target(_monster: CardData) -> bool:

    return true

func _is_valid_laser_cannon_armor_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in LASER_CANNON_ARMOR_TYPES

func _is_valid_insect_armor_laser_cannon_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in INSECT_ARMOR_LASER_CANNON_TYPES

func _is_valid_elfs_light_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in ELFS_LIGHT_ATTRIBUTE

func _is_valid_salamandra_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in SALAMANDRA_ATTRIBUTES

func _is_valid_gust_fan_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in GUST_FAN_ATTRIBUTES

func _is_valid_beast_fangs_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in BEAST_FANGS_TYPES

func _is_valid_steel_shell_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in STEEL_SHELL_ATTRIBUTE

func _is_valid_vile_germs_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in VILE_GERMS_TYPES

func _is_valid_black_pendant_target(_monster: CardData) -> bool:

    return true

func _is_valid_silver_bow_arrow_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in SILVER_BOW_ARROW_TYPES

func _is_valid_horn_of_light_target(_monster: CardData) -> bool:

    return true

func _is_valid_horn_of_the_unicorn_target(_monster: CardData) -> bool:

    return true

func _is_valid_dragon_treasure_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in DRAGON_TREASURE_TYPES

func _is_valid_electro_whip_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in ELECTRO_WHIP_TYPES

func _is_valid_cyber_shield_target(monster: CardData) -> bool:

    return monster.id in CYBER_SHIELD_VALID_IDS

func _is_valid_magical_labyrinth_target(monster: CardData) -> bool:
    return monster.id in MAGICAL_LABYRINTH_VALID_IDS

func _is_valid_elegant_egotist_target(monster: CardData) -> bool:

    return monster.id == HARPY_LADY_ID

func _is_valid_mystical_moon_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in MYSTICAL_MOON_TYPES

func _is_valid_malevolent_nuzzler_target(_monster: CardData) -> bool:

    return true

func _is_valid_violet_crystal_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in VIOLET_CRYSTAL_TYPES

func _is_valid_book_of_secret_arts_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in BOOK_OF_SECRET_ARTS_TYPES

func _is_valid_invigoration_target(monster: CardData) -> bool:
    var m_attribute = monster.attribute.to_lower()
    return m_attribute in INVIGORATION_ATTRIBUTES

func _is_valid_machine_conversion_factory_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in MACHINE_CONVERSION_FACTORY_TYPES

func _is_valid_raise_body_heat_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in RAISE_BODY_HEAT_TYPES

func _is_valid_follow_wind_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in FOLLOW_WIND_TYPES

func _is_valid_power_of_kaishin_target(monster: CardData) -> bool:
    var m_type = monster.type.to_lower()
    return m_type in POWER_OF_KAISHIN_TYPES

func get_equip_bonus(equip_id: int) -> Dictionary:
    match equip_id:
        EQUIP_DARK_ENERGY:
            return {"atk": DARK_ENERGY_BONUS, "def": DARK_ENERGY_BONUS}
        EQUIP_LEGENDARY_SWORD:
            return {"atk": LEGENDARY_SWORD_BONUS, "def": LEGENDARY_SWORD_BONUS}
        EQUIP_SWORD_DARK_DESTRUCTION:
            return {"atk": DARK_DESTRUCTION_ATK_BONUS, "def": DARK_DESTRUCTION_DEF_PENALTY}
        EQUIP_AXE_OF_DESPAIR:
            return {"atk": AXE_OF_DESPAIR_BONUS, "def": 0}
        EQUIP_LASER_CANNON_ARMOR:
            return {"atk": LASER_CANNON_ARMOR_BONUS, "def": LASER_CANNON_ARMOR_BONUS}
        EQUIP_INSECT_ARMOR_WITH_LASER_CANNON:
            return {"atk": INSECT_ARMOR_LASER_CANNON_BONUS, "def": 0}
        EQUIP_ELFS_LIGHT:
            return {"atk": ELFS_LIGHT_ATK_BONUS, "def": ELFS_LIGHT_DEF_PENALTY}
        EQUIP_BEAST_FANGS:
            return {"atk": BEAST_FANGS_BONUS, "def": BEAST_FANGS_BONUS}
        EQUIP_STEEL_SHELL:
            return {"atk": STEEL_SHELL_ATK_BONUS, "def": STEEL_SHELL_DEF_PENALTY}
        EQUIP_VILE_GERMS:
            return {"atk": VILE_GERMS_BONUS, "def": VILE_GERMS_BONUS}
        EQUIP_BLACK_PENDANT:
            return {"atk": BLACK_PENDANT_ATK_BONUS, "def": 0}
        EQUIP_SILVER_BOW_ARROW:
            return {"atk": SILVER_BOW_ARROW_BONUS, "def": SILVER_BOW_ARROW_BONUS}
        EQUIP_HORN_OF_LIGHT:
            return {"atk": 0, "def": HORN_OF_LIGHT_DEF_BONUS}
        EQUIP_HORN_OF_THE_UNICORN:
            return {"atk": HORN_OF_THE_UNICORN_BONUS, "def": HORN_OF_THE_UNICORN_BONUS}
        EQUIP_DRAGON_TREASURE:
            return {"atk": DRAGON_TREASURE_BONUS, "def": DRAGON_TREASURE_BONUS}
        EQUIP_ELECTRO_WHIP:
            return {"atk": ELECTRO_WHIP_BONUS, "def": ELECTRO_WHIP_BONUS}
        EQUIP_CYBER_SHIELD:
            return {"atk": CYBER_SHIELD_ATK_BONUS, "def": 0}
        EQUIP_ELEGANT_EGOTIST:
            return {"atk": 0, "def": 0}
        EQUIP_MYSTICAL_MOON:
            return {"atk": MYSTICAL_MOON_BONUS, "def": MYSTICAL_MOON_BONUS}
        EQUIP_MALEVOLENT_NUZZLER:
            return {"atk": MALEVOLENT_NUZZLER_BONUS, "def": 0}
        EQUIP_VIOLET_CRYSTAL:
            return {"atk": VIOLET_CRYSTAL_BONUS, "def": VIOLET_CRYSTAL_BONUS}
        EQUIP_BOOK_OF_SECRET_ARTS:
            return {"atk": BOOK_OF_SECRET_ARTS_BONUS, "def": BOOK_OF_SECRET_ARTS_BONUS}
        EQUIP_INVIGORATION:
            return {"atk": INVIGORATION_ATK_BONUS, "def": INVIGORATION_DEF_PENALTY}
        EQUIP_MACHINE_CONVERSION_FACTORY:
            return {"atk": MACHINE_CONVERSION_FACTORY_BONUS, "def": MACHINE_CONVERSION_FACTORY_BONUS}
        EQUIP_RAISE_BODY_HEAT:
            return {"atk": RAISE_BODY_HEAT_BONUS, "def": RAISE_BODY_HEAT_BONUS}
        EQUIP_FOLLOW_WIND:
            return {"atk": FOLLOW_WIND_BONUS, "def": FOLLOW_WIND_BONUS}
        EQUIP_POWER_OF_KAISHIN:
            return {"atk": POWER_OF_KAISHIN_BONUS, "def": POWER_OF_KAISHIN_BONUS}
        EQUIP_SALAMANDRA:
            return {"atk": SALAMANDRA_ATK_BONUS, "def": 0}
        EQUIP_MAGICAL_LABYRINTH:
            return {"atk": 500, "def": 500}
        EQUIP_MEGAMORPH:
            return {"atk": 1000, "def": 0}
        EQUIP_METALMORPH:
            return {"atk": 300, "def": 300}
        EQUIP_RARE_METALMORPH:
            return {"atk": 1000, "def": 1000}
        EQUIP_GUST_FAN:
            return {"atk": 400, "def": - 200}
        EQUIP_SWORD_DEEP_SEATED:
            return {"atk": 500, "def": 500}
        EQUIP_PHOTON_BOOSTER:
            return {"atk": 2000, "def": 0}
        EQUIP_GRAVITY_AXE_GRARL:
            return {"atk": 500, "def": 0}
        _:
            return {"atk": 0, "def": 0}


func should_prevent_battle_damage(target_is_player: bool) -> bool:
    if not duel_manager:
        return false


    var target_slots = duel_manager.player_slots if target_is_player else duel_manager.enemy_slots

    for slot in target_slots:
        if slot.is_occupied and slot.spawn_point.get_child_count() > 0:
            var card_visual = slot.spawn_point.get_child(0)

            var is_face_up = true
            if card_visual.has_method("is_face_down"):
                is_face_up = not card_visual.is_face_down
            elif duel_manager.has_method("_has_card_back"):
                is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                var card_data = slot.stored_card_data
                if card_data and card_data.id == KURIBOH_ID:
                    print("Kuriboh previne dano de batalha para ", "Jogador" if target_is_player else "Inimigo")
                    return true

    return false

func _get_card_data_from_slot(slot) -> CardData:
    if slot.card and slot.card.has_method("get_card_data"):
        return slot.card.get_card_data()
    return null


func get_field_bonus(monster: CardData, field_name: String) -> Dictionary:
    if not monster:
        return {"atk": 0, "def": 0}

    match field_name:
        "Forest":
            return _get_forest_bonus(monster)
        "Wasteland":
            return _get_wasteland_bonus(monster)
        "Mountain":
            return _get_mountain_bonus(monster)
        "Sogen":
            return _get_sogen_bonus(monster)
        "Umi":
            return _get_umi_bonus(monster)
        "Yami":
            return _get_yami_bonus(monster)
        "Gaia Power":
            return _get_gaia_power_bonus(monster)
        "Jurassic World":
            return _get_jurassic_world_bonus(monster)
        "Sanctuary in the Sky":
            return _get_sanctuary_bonus(monster)
        _:
            return {"atk": 0, "def": 0}

func _get_forest_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()
    return {"atk": FOREST_BONUS, "def": FOREST_BONUS} if m_type in FOREST_BUFFED_TYPES else {"atk": 0, "def": 0}

func _get_wasteland_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()
    return {"atk": WASTELAND_BONUS, "def": WASTELAND_BONUS} if m_type in WASTELAND_BUFFED_TYPES else {"atk": 0, "def": 0}

func _get_mountain_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()
    return {"atk": MOUNTAIN_BONUS, "def": MOUNTAIN_BONUS} if m_type in MOUNTAIN_BUFFED_TYPES else {"atk": 0, "def": 0}

func _get_sogen_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()
    return {"atk": SOGEN_BONUS, "def": SOGEN_BONUS} if m_type in SOGEN_BUFFED_TYPES else {"atk": 0, "def": 0}

func _get_umi_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()

    if m_type in UMI_BUFFED_TYPES:
        return {"atk": UMI_BONUS, "def": UMI_BONUS}


    if m_type in UMI_DEBUFFED_TYPES:
        return {"atk": UMI_PENALTY, "def": UMI_PENALTY}


    return {"atk": 0, "def": 0}

func _get_yami_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()

    if m_type in YAMI_BUFFED_TYPES:
        return {"atk": YAMI_BONUS, "def": YAMI_BONUS}


    if m_type in YAMI_DEBUFFED_TYPES:
        return {"atk": YAMI_PENALTY, "def": YAMI_PENALTY}


    return {"atk": 0, "def": 0}

func _get_gaia_power_bonus(monster: CardData) -> Dictionary:
    var m_att = monster.attribute.to_lower()
    return {"atk": 500, "def": - 400} if m_att in GAIA_POWER_BUFFED_ATTRIBUTES else {"atk": 0, "def": 0}

func _get_sanctuary_bonus(monster: CardData) -> Dictionary:
    var m_att = monster.attribute.to_lower()
    return {"atk": 500, "def": 500} if m_att in SANCTUARY_BUFFED_ATTRIBUTES else {"atk": 0, "def": 0}

func _get_jurassic_world_bonus(monster: CardData) -> Dictionary:
    var m_type = monster.type.to_lower()
    return {"atk": JURASSIC_WORLD_BONUS, "def": JURASSIC_WORLD_BONUS} if m_type in JURASSIC_WORLD_BUFFED_TYPES else {"atk": 0, "def": 0}


func _animate_lp_if_possible(lp_label, new_value: int):

    duel_manager.animate_lp_change(lp_label, new_value)



func _effect_fire(attacker_slot: Node) -> bool:

    if not is_instance_valid(attacker_slot) or not attacker_slot.get("is_occupied"):
        return false


    var spawn_point = attacker_slot.get_node_or_null("SpawnPoint")
    if not spawn_point or spawn_point.get_child_count() == 0:
        return false

    var card_visual: TextureButton = spawn_point.get_child(0)
    var art: CanvasItem = card_visual.get_child(0) if card_visual.get_child_count() > 0 else null
    if not art or not is_instance_valid(art):
        return false


    var sm: = ShaderMaterial.new()
    sm.shader = preload("res://data/common/shaders/fire.gdshader")
    var parameters = {
        "noise": preload("res://data/common/shaders/noises/fire_noise.tres"), 
        "colorCurve": preload("res://data/common/shaders/color_curve/fire_color.tres"), 
        "timed": false, 
        "speed": 0.5, 
        "angle": 0.3, 
        "progress": 0.0, 
        "width": 0.2
    }
    for key in parameters:
        sm.set_shader_parameter(key, parameters[key])


    for child in card_visual.get_children():
        if child != art and child is CanvasItem:
            child.visible = false
    art.material = sm

    _play_carddestroyed_sound()


    var tween: = create_tween()
    tween.tween_property(art.material, "shader_parameter/progress", 1.11, 0.5)\
.set_trans(Tween.TRANS_SINE)\
.set_ease(Tween.EASE_IN_OUT)
    await tween.finished
    return true

func _get_slot_id(slot) -> String:

    if slot == null:
        return "null"


    if slot.has_method("get_instance_id"):
        return "slot_" + str(slot.get_instance_id())
    elif slot.has_method("get_path"):
        return "slot_" + str(slot.get_path())
    else:

        if "name" in slot:
            return "slot_" + str(slot.name)
        else:
            return "slot_" + str(hash(str(slot)))

func _play_carddestroyed_sound(delay_increment: float = 0.3, force_immediate: bool = false):
    var current_time = Time.get_ticks_msec()

    var delay = 0.0

    if not force_immediate:

        if current_time - _last_discard_time < 100:
            _card_discard_delay_offset += delay_increment
        else:
            _card_discard_delay_offset = 0.0
        delay = _card_discard_delay_offset

    _last_discard_time = current_time


    var sound_path = "res://assets/sounds/sfx/carddestroyed.wav"
    if ResourceLoader.exists(sound_path):

        if delay > 0:
            await get_tree().create_timer(delay).timeout

        var new_player = AudioStreamPlayer.new()
        add_child(new_player)

        var stream = load(sound_path)
        new_player.stream = stream
        new_player.play()


        new_player.finished.connect(new_player.queue_free)

func _effect_ancient_telescope(is_player_owner: bool):
    print("Ancient Telescope: Efeito ativado - Olhando as top 5 cartas do deck do oponente")

    if not duel_manager:
        print("ERRO: duel_manager nÃ£o encontrado!")
        return

    var opp_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile

    if opp_deck.size() == 0:
        print("Ancient Telescope: Deck do oponente estÃ¡ vazio!")
        return

    var cards_to_show = []

    var num_cards = min(5, opp_deck.size())
    for i in range(num_cards):

        cards_to_show.append(opp_deck[opp_deck.size() - 1 - i])


    var popup_layer = CanvasLayer.new()
    popup_layer.layer = 100
    duel_manager.add_child(popup_layer)

    var bg = ColorRect.new()
    bg.color = Color(0.0, 0.0, 0.0, 0.863)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    popup_layer.add_child(bg)

    var center_container = CenterContainer.new()
    center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    bg.add_child(center_container)

    var vbox = VBoxContainer.new()
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.add_theme_constant_override("separation", 20)
    center_container.add_child(vbox)


    var title = Label.new()
    title.text = "Opponent's Top Deck Cards"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 32)
    vbox.add_child(title)


    var hbox = HBoxContainer.new()
    hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    hbox.add_theme_constant_override("separation", 20)
    vbox.add_child(hbox)


    var close_btn = Button.new()
    close_btn.text = "CLOSE (X)"
    close_btn.custom_minimum_size = Vector2(200, 50)
    close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    vbox.add_child(close_btn)


    for c_data in cards_to_show:
        var card_container = Control.new()
        card_container.custom_minimum_size = Vector2(364 * 0.5, 530 * 0.5)
        hbox.add_child(card_container)

        var visual = duel_manager.card_visual_scene.instantiate()
        card_container.add_child(visual)
        visual.scale = Vector2(0.5, 0.5)
        visual.position = Vector2.ZERO
        visual.set_card_data(c_data, true)
        visual.rotation_degrees = 0


    var closed_signal = [false]


    var close_func = func():
        closed_signal[0] = true
        popup_layer.queue_free()

    close_btn.pressed.connect(close_func)

    bg.gui_input.connect( func(event):
        if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            close_func.call()
    )


    while not closed_signal[0]:
        await duel_manager.get_tree().create_timer(0.1).timeout

    print("Ancient Telescope: Fim do efeito")

func _apply_lord_of_d_effect(card_data: CardData, is_player_owner: bool, slot):
    print("Lord of D.: Efeito ativado - +200 ATK/DEF para Dragons face-up do dono")

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Lord of D.: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var affected_dragons = 0

    for target_slot in owner_slots:
        if target_slot.is_occupied and target_slot.stored_card_data:
            var monster_data = target_slot.stored_card_data
            if monster_data.type == "Dragon":
                var target_visual = target_slot.spawn_point.get_child(0) if target_slot.spawn_point.get_child_count() > 0 else null
                var target_is_face_up = false

                if target_visual:
                    if target_visual.has_method("is_face_down"):
                        target_is_face_up = not target_visual.is_face_down()
                    elif duel_manager.has_method("_has_card_back"):
                        target_is_face_up = not duel_manager._has_card_back(target_visual)

                if target_is_face_up:
                    monster_data.atk += 200
                    monster_data.def += 200
                    affected_dragons += 1
                    print("  - +200 ATK/DEF para ", monster_data.name)

                    if target_visual and target_visual.has_method("animate_stats_bonus"):
                        target_visual.animate_stats_bonus(monster_data.atk, monster_data.def)

    print("Lord of D.: ", affected_dragons, " monstro(s) Dragon receberam +200 ATK/DEF")
    print("Lord of D.: Efeito concluÃ­do")

func _effect_flute_of_summoning_dragon(is_player_owner: bool):
    print("The Flute of Summoning Dragon: Efeito ativado - Invocando atÃ© 2 Dragons nv<=4 do deck")

    if not duel_manager:
        return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile


    var empty_slots = []
    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slots.append(slot)

    if empty_slots.size() == 0:
        print("The Flute of Summoning Dragon: Nenhum slot vazio. O efeito nÃ£o faz nada.")
        return


    var max_summons = min(2, empty_slots.size())


    var eligible_dragons = []
    for i in range(owner_deck.size()):
        var card = owner_deck[i]
        if card.type == "Dragon" and card.level <= 4:
            eligible_dragons.append({"card": card, "index": i})

    if eligible_dragons.size() == 0:
        print("The Flute of Summoning Dragon: Nenhum dragÃ£o nv<=4 no deck. O efeito resolve sem invocar.")
        return


    eligible_dragons.shuffle()


    var num_summons = min(max_summons, eligible_dragons.size())
    var selected = []
    for i in range(num_summons):
        selected.append(eligible_dragons[i])


    selected.sort_custom( func(a, b): return a["index"] > b["index"])


    var cards_to_summon = []
    for item in selected:
        var card_to_summon = owner_deck[item["index"]]
        owner_deck.remove_at(item["index"])
        cards_to_summon.append(card_to_summon)


    for i in range(cards_to_summon.size()):
        var card = cards_to_summon[i]
        var slot = empty_slots[i]

        print("The Flute of Summoning Dragon: Invocando ", card.name, " no slot!")

        await duel_manager.spawn_card_on_field(card, slot, false, is_player_owner, false, true)


    duel_manager.update_deck_ui()

    owner_deck.shuffle()

    print("The Flute of Summoning Dragon: Efeito concluÃ­do. Foram invocados ", cards_to_summon.size(), " monstro(s).")

func _effect_card_destruction(_is_player_owner: bool):
    print("Card Destruction ativado: Ambos os jogadores descartam as mÃ£os e compram 5 cartas!")

    if not duel_manager:
        return

    var player_discarded = 0
    var enemy_discarded = 0



    for i in range(duel_manager.player_hand.size()):
        var card = duel_manager.player_hand[i]
        if card:
            duel_manager.send_to_graveyard(card, true, true)
            duel_manager.player_hand[i] = null
            player_discarded += 1


    for i in range(duel_manager.enemy_hand.size()):
        var card = duel_manager.enemy_hand[i]
        if card:
            duel_manager.send_to_graveyard(card, false, true)
            duel_manager.enemy_hand[i] = null
            enemy_discarded += 1


    duel_manager.update_hand_ui()
    duel_manager.update_enemy_hand_ui()

    print("Card Destruction: Jogador descartou ", player_discarded, " cartas. IA descartou ", enemy_discarded, " cartas.")


    await duel_manager.get_tree().create_timer(1.0).timeout


    var player_drawn = 0
    var enemy_drawn = 0

    for i in range(5):

        if duel_manager.player_deck_pile.size() > 0:
            var p_card = duel_manager.draw_card_from_deck(true, false)
            if p_card:

                for p_idx in range(duel_manager.player_hand.size()):
                    if duel_manager.player_hand[p_idx] == null:
                        duel_manager.player_hand[p_idx] = p_card
                        player_drawn += 1
                        break


        if duel_manager.enemy_deck_pile.size() > 0:
            var e_card = duel_manager.draw_card_from_deck(false, false)
            if e_card:
                for e_idx in range(duel_manager.enemy_hand.size()):
                    if duel_manager.enemy_hand[e_idx] == null:
                        duel_manager.enemy_hand[e_idx] = e_card
                        enemy_drawn += 1
                        break


        if player_drawn > i or enemy_drawn > i:
            if duel_manager.has_method("_play_draw_sound"):
                duel_manager._play_draw_sound()


        duel_manager.update_hand_ui()
        duel_manager.update_enemy_hand_ui()
        duel_manager.update_deck_ui()
        await duel_manager.get_tree().create_timer(0.2).timeout

    print("Card Destruction: Jogador comprou ", player_drawn, " cartas. IA comprou ", enemy_drawn, " cartas.")
    print("Card Destruction: Efeito concluÃ­do.")

func _effect_last_will(is_player_owner: bool):
    print("Last Will: Efeito ativado - Invocando 1 monstro com ATK <= 1500 do deck.")

    if not duel_manager:
        return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var owner_deck = duel_manager.player_deck_pile if is_player_owner else duel_manager.enemy_deck_pile

    var empty_slot = null
    for slot in owner_slots:
        if not slot.is_occupied:
            empty_slot = slot
            break

    if empty_slot == null:
        print("Last Will: Nenhum slot vazio. Efeito cancelado.")
        return

    var eligible_monsters = []
    for i in range(owner_deck.size()):
        var card = owner_deck[i]

        if card.attribute != "Magic" and card.attribute != "Trap" and card.atk <= 1500:
            eligible_monsters.append({"card": card, "index": i})

    if eligible_monsters.size() == 0:
        print("Last Will: Nenhum alvo válido no deck.")
        return

    eligible_monsters.shuffle()
    var chosen = eligible_monsters[0]

    var card_to_summon = owner_deck[chosen["index"]]
    owner_deck.remove_at(chosen["index"])

    print("Last Will: Invocando ", card_to_summon.name)
    await duel_manager.spawn_card_on_field(card_to_summon, empty_slot, false, is_player_owner, false, true)

    duel_manager.update_deck_ui()
    owner_deck.shuffle()
    print("Last Will: Efeito concluÃ­do.")

func _apply_stern_mystic_effect(_card_data: CardData, is_player_owner: bool, slot):

    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("The Stern Mystic: Invocado face-down, efeito nÃ£o ativa")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)


    _reveal_all_opponent_monsters( not is_player_owner)
    print("The Stern Mystic: Revelou monstros do oponente.")

func _effect_soul_release(is_player_owner: bool):
    print("Soul Release: Ativado! Mandando as 5 primeiras cartas do oponente para o cemitÃ©rio.")

    if not duel_manager:
        return

    var target_deck = duel_manager.enemy_deck_pile if is_player_owner else duel_manager.player_deck_pile
    var cards_milled = 0
    var is_target_player = not is_player_owner

    for i in range(5):
        if target_deck.size() > 0:
            var random_idx = randi() % target_deck.size()
            var card_to_mill = target_deck[random_idx]
            target_deck.remove_at(random_idx)
            duel_manager.send_to_graveyard(card_to_mill, is_target_player, true)
            cards_milled += 1
            await duel_manager.get_tree().create_timer(0.2).timeout

    duel_manager.update_deck_ui()
    print("Soul Release: ", cards_milled, " cartas foram enviadas para o cemitÃ©rio.")

func _effect_tribute_to_the_doomed(is_player_owner: bool):
    print("Tribute to the Doomed: Ativado! Tentando descartar 1 carta da mÃ£o...")

    if not duel_manager:
        return

    var owner_hand = duel_manager.player_hand if is_player_owner else duel_manager.enemy_hand


    var valid_hand_indices = []
    for i in range(owner_hand.size()):
        var c = owner_hand[i]
        if c != null and c.id != EFFECT_TRIBUTE_TO_THE_DOOMED:
            valid_hand_indices.append(i)

    if valid_hand_indices.size() == 0:
        print("Tribute to the Doomed: Nenhuma carta na mÃ£o para descartar! Efeito cancelado.")
        return


    var random_val = randi() % valid_hand_indices.size()
    var discard_index = valid_hand_indices[random_val]
    var discarded_card = owner_hand[discard_index]
    owner_hand[discard_index] = null

    print("Tribute to the Doomed: Descartando ", discarded_card.name, " da mÃ£o.")
    duel_manager.send_to_graveyard(discarded_card, is_player_owner, true)

    if is_player_owner:
        duel_manager.update_hand_ui()
    else:
        duel_manager.update_enemy_hand_ui()

    print("Tribute to the Doomed: Selecionando o monstro inimigo (face-up) mais forte...")
    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots

    var target_to_destroy = null
    var highest_atk = -1

    for o_slot in opponent_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                if current_atk > highest_atk:
                    highest_atk = current_atk
                    target_to_destroy = o_slot

    if target_to_destroy:
        print("Tribute to the Doomed: Destruindo ", target_to_destroy.stored_card_data.name, " (ATK: ", highest_atk, ")")
        await duel_manager._destroy_card(target_to_destroy)
    else:
        print("Tribute to the Doomed: Nenhum monstro válido (face-up) encontrado no campo do oponente.")

func _effect_share_the_pain(is_player_owner: bool):
    print("Share the Pain: Ativado! Varrer campos em busca do maior inimigo e menor aliado (ambos face-up)...")
    if not duel_manager: return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var opp_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots

    var target_owner_slot = null
    var lowest_atk = 999999

    var target_opp_slot = null
    var highest_atk = -1


    for o_slot in owner_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                if current_atk < lowest_atk:
                    lowest_atk = current_atk
                    target_owner_slot = o_slot


    for e_slot in opp_slots:
        if e_slot.is_occupied:
            if _is_card_face_up(e_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(e_slot.stored_card_data, null)
                if current_atk > highest_atk:
                    highest_atk = current_atk
                    target_opp_slot = e_slot

    if not target_owner_slot:
        print("Share the Pain: Sem monstros aliados face-up para sacrificar. Efeito cancelado.")
        return

    print("Share the Pain: Destruindo o prÃ³prio ", target_owner_slot.stored_card_data.name, " (ATK: ", lowest_atk, ")")
    await duel_manager._destroy_card(target_owner_slot)

    if target_opp_slot:
        print("Share the Pain: Destruindo inimigo ", target_opp_slot.stored_card_data.name, " (ATK: ", highest_atk, ")")
        await duel_manager._destroy_card(target_opp_slot)

func _effect_order_to_charge(is_player_owner: bool):
    print("Order to Charge: Ativado! Varrer campos em busca do maior inimigo e menor aliado (ambos face-up)...")
    if not duel_manager: return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var opp_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots

    var target_owner_slot = null
    var lowest_atk = 999999

    var target_opp_slot = null
    var highest_atk = -1


    for o_slot in owner_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                if current_atk < lowest_atk:
                    lowest_atk = current_atk
                    target_owner_slot = o_slot


    for e_slot in opp_slots:
        if e_slot.is_occupied:
            if _is_card_face_up(e_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(e_slot.stored_card_data, null)
                if current_atk > highest_atk:
                    highest_atk = current_atk
                    target_opp_slot = e_slot

    if not target_owner_slot:
        print("Order to Charge: Sem monstros aliados face-up para sacrificar. Efeito cancelado.")
        return

    print("Order to Charge: Destruindo o prÃ³prio ", target_owner_slot.stored_card_data.name, " (ATK: ", lowest_atk, ")")
    await duel_manager._destroy_card(target_owner_slot)

    if target_opp_slot:
        print("Order to Charge: Destruindo inimigo ", target_opp_slot.stored_card_data.name, " (ATK: ", highest_atk, ")")
        await duel_manager._destroy_card(target_opp_slot)

func _effect_shield_and_sword(_is_player_owner: bool):
    print("Shield and Sword: Ativado! Trocando ATK e DEF de todos os monstros face-up no campo do Jogador E do Inimigo.")
    if not duel_manager: return

    var all_slots = duel_manager.player_slots + duel_manager.enemy_slots
    var anything_swapped = false

    for slot in all_slots:
        if slot.is_occupied:
            if _is_card_face_up(slot, false):
                var card = slot.stored_card_data
                var old_atk = card.atk
                var old_def = card.def


                card.atk = old_def
                card.def = old_atk

                print("Shield and Sword: ", card.name, " (", old_atk, "/", old_def, ") > (", card.atk, "/", card.def, ")")

                var visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
                if visual and visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(card.atk, card.def)

                anything_swapped = true

    if anything_swapped:
        await duel_manager.get_tree().create_timer(0.3).timeout
    else:
        print("Shield and Sword: Sem alvos face-up no campo para reverter.")

func _effect_heavy_storm(_is_player_owner: bool):
    print("Heavy Storm: Ativado! Destruindo todas as cartas nos Spell/Trap Zones de Jogador e Inimigo...")
    if not duel_manager: return

    var all_spell_slots = duel_manager.player_spell_slots + duel_manager.enemy_spell_slots
    var slots_to_destroy = []

    for slot in all_spell_slots:
        if slot.is_occupied:
            slots_to_destroy.append(slot)

    if slots_to_destroy.is_empty():
        print("Heavy Storm: Sem cartas nas zonas de Magia/Armadilha para destruir.")
        return

    print("Heavy Storm: Destruindo %d cartas..." % slots_to_destroy.size())
    for slot in slots_to_destroy:
        if slot.is_occupied:
            print("Heavy Storm: Destruindo ", slot.stored_card_data.name)
            await duel_manager._destroy_card(slot, false)


func _apply_barrel_dragon_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Barrel Dragon: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Barrel Dragon: Ativado! Girando a roleta...")


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    var final_number = await _show_number_roulette(is_player_owner)

    if final_number % 2 != 0:
        print("Barrel Dragon: Ãmpar! Efeito falhou.")
        return

    print("Barrel Dragon: Par! Selecionando os 3 monstros com maior ATK do oponente...")
    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var candidates = []
    for o_slot in opponent_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                candidates.append({"slot": o_slot, "atk": current_atk})

    if candidates.is_empty():
        print("Twin-Barrel Dragon: Nenhum monstro válido (face-up) para destruir.")
        return


    candidates.sort_custom( func(a, b): return a["atk"] > b["atk"])
    var targets = candidates.slice(0, min(3, candidates.size()))

    for entry in targets:
        var target_slot = entry["slot"]
        if target_slot.is_occupied:
            print("Barrel Dragon: Destruindo ", target_slot.stored_card_data.name, " (ATK: ", entry["atk"], ")")
            await duel_manager._destroy_card(target_slot)

func _apply_heavy_mech_support_platform_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Heavy Mech Support Platform: Invocado face-down, efeito não ativa.")
        return


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    print("Heavy Mech Support Platform: Ativado! Aplicando +500 ATK/DEF a todos os Machine aliados face-up...")
    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots
    var anything_buffed = false

    for o_slot in owner_slots:
        if o_slot.is_occupied and o_slot.stored_card_data:
            var card = o_slot.stored_card_data
            if card.type.to_lower() == "machine" and _is_card_face_up(o_slot, is_player_owner):
                card.atk += 500
                card.def += 500
                print("Heavy Mech Support Platform: ", card.name, " agora tem ATK/DEF: ", card.atk, "/", card.def)
                var visual = o_slot.spawn_point.get_child(0) if o_slot.spawn_point.get_child_count() > 0 else null
                if visual and visual.has_method("animate_stats_bonus"):
                    visual.animate_stats_bonus(card.atk, card.def)
                anything_buffed = true

    if anything_buffed:
        await duel_manager.get_tree().create_timer(0.4).timeout
    else:
        print("Heavy Mech Support Platform: Nenhum monstro Machine face-up aliado encontrado.")

func _apply_twin_barrel_dragon_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager:
        return


    var is_face_up = false
    var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null

    if card_visual:
        if card_visual.has_method("is_face_down"):
            is_face_up = not card_visual.is_face_down()
        elif duel_manager.has_method("_has_card_back"):
            is_face_up = not duel_manager._has_card_back(card_visual)

    if not is_face_up:
        print("Twin-Barrel Dragon: Invocado face-down, efeito nÃ£o ativa")
        return

    print("Twin-Barrel Dragon: Ativado! Girando a roleta...")


    if card_visual:
        await duel_manager._apply_magic_activation_glow(card_visual)

    var final_number = await _show_number_roulette(is_player_owner)

    if final_number % 2 != 0:
        print("Twin-Barrel Dragon: Ãmpar! Efeito falhou.")
        return

    print("Twin-Barrel Dragon: Par! Selecionando os 2 monstros com maior ATK do oponente...")
    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots


    var candidates = []
    for o_slot in opponent_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                candidates.append({"slot": o_slot, "atk": current_atk})

    if candidates.is_empty():
        print("Twin-Barrel Dragon: Nenhum monstro válido (face-up) para destruir.")
        return


    candidates.sort_custom( func(a, b): return a["atk"] > b["atk"])
    var targets = candidates.slice(0, min(2, candidates.size()))

    for entry in targets:
        var target_slot = entry["slot"]
        if target_slot.is_occupied:
            print("Twin-Barrel Dragon: Destruindo ", target_slot.stored_card_data.name, " (ATK: ", entry["atk"], ")")
            await duel_manager._destroy_card(target_slot)

func _apply_blowback_dragon_effect(_card_data: CardData, is_player_owner: bool, slot):
    if not duel_manager:
        return


    var visual = slot.spawn_point.get_child(0)
    if visual and visual.has_method("is_face_down") and visual.is_face_down():
        return

    print("Blowback Dragon: Ativado! Girando a roleta...")

    if visual:
        await duel_manager._apply_magic_activation_glow(visual)


    var final_number = await _show_number_roulette(is_player_owner)

    if final_number % 2 != 0:
        print("Blowback Dragon: Ãmpar! Efeito falhou.")
        return

    print("Blowback Dragon: Par! Selecionando alvo...")
    var opponent_slots = duel_manager.enemy_slots if is_player_owner else duel_manager.player_slots

    var target_to_destroy = null
    var highest_atk = -1

    for o_slot in opponent_slots:
        if o_slot.is_occupied:
            if _is_card_face_up(o_slot, not is_player_owner):
                var current_atk = duel_manager.get_effective_atk(o_slot.stored_card_data, null)
                if current_atk > highest_atk:
                    highest_atk = current_atk
                    target_to_destroy = o_slot

    if target_to_destroy:
        print("Blowback Dragon: Destruindo ", target_to_destroy.stored_card_data.name, " (ATK: ", highest_atk, ")")
        await duel_manager._destroy_card(target_to_destroy)
    else:
        print("Blowback Dragon: Nenhum monstro válido (face-up) para destruir.")


func _effect_union_attack(is_player_owner: bool):
    print("Union Attack: Efeito ativado!")

    if not duel_manager:
        return

    var owner_slots = duel_manager.player_slots if is_player_owner else duel_manager.enemy_slots


    var face_up_monsters = []
    for slot in owner_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card_visual = slot.spawn_point.get_child(0) if slot.spawn_point.get_child_count() > 0 else null
            var is_face_up = true
            if card_visual:
                if card_visual.has_method("is_face_down"):
                    is_face_up = not card_visual.is_face_down()
                elif duel_manager.has_method("_has_card_back"):
                    is_face_up = not duel_manager._has_card_back(card_visual)

            if is_face_up:
                face_up_monsters.append({"slot": slot, "card": slot.stored_card_data, "visual": card_visual})

    if face_up_monsters.size() < 2:
        print("Union Attack: Precisa de pelo menos 2 monstros face-up no campo. Efeito cancelado.")
        return


    var strongest = face_up_monsters[0]
    for m in face_up_monsters:
        if m.card.atk > strongest.card.atk:
            strongest = m


    var atk_sum = 0
    for m in face_up_monsters:
        if m.card != strongest.card:
            atk_sum += m.card.atk

    if atk_sum <= 0:
        print("Union Attack: Nenhum bÃ´nus de ATK para aplicar.")
        return

    print("Union Attack: %s ganha +%d ATK (soma dos outros monstros) atÃ© o fim do turno!" % [strongest.card.name, atk_sum])


    strongest.card.atk += atk_sum


    if strongest.visual and strongest.visual.has_method("animate_stats_bonus"):
        strongest.visual.animate_stats_bonus(strongest.card.atk, strongest.card.def)


    duel_manager.union_attack_active_monsters.append({"card": strongest.card, "amount": atk_sum})

    print("Union Attack: Novo ATK de %s = %d" % [strongest.card.name, strongest.card.atk])
