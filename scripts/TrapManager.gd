extends Node








var player_traps: Array[TrapData] = []
var enemy_traps: Array[TrapData] = []

func _ready():


    EventBus.attack_declared.connect(_on_attacker)
    EventBus.monster_summoned.connect(_on_monster_summoned)
    EventBus.monster_destroyed.connect(_on_monster_destroyed)


func add_trap(trap: TrapData) -> void :

    print("\n Adicionando Trap: ", trap.id, "\n")

    if trap.owner.is_player_slot:
        player_traps.append(trap)
    else:
        enemy_traps.append(trap)


    EventBus.trap_activated.emit(trap)


func remove_trap(trap: TrapData, _attacker, _defender) -> void :

    print("\n Removendo Trap: ", trap.id, "\n")

    if trap.owner.is_player_slot:
        player_traps.erase(trap)
    else:
        enemy_traps.erase(trap)


    EventBus.trap_removed.emit(trap)



func clear_all_traps() -> void :
    player_traps.clear()
    enemy_traps.clear()
    print("TrapManager: Todas as traps foram limpas (reset).")



func check_negation(activating_trap: TrapData, attacker, defender) -> bool:

    var opponent_traps = enemy_traps if activating_trap.owner.is_player_slot else player_traps

    if opponent_traps.is_empty():
        return false




    var target_card = null
    if activating_trap.owner and "stored_card_data" in activating_trap.owner:
        target_card = activating_trap.owner.stored_card_data

    for counter_trap in opponent_traps:
        if counter_trap.id == 735:

            if await _try_activate_seven_tools(counter_trap, activating_trap, attacker, defender):
                return true
        elif counter_trap.id == 754:

            if target_card and await _try_activate_solemn_judgment(counter_trap, target_card, activating_trap.owner.is_player_slot):
                return true
        elif counter_trap.id == 758:

            if target_card and await _try_activate_divine_punishment(counter_trap, target_card, activating_trap.owner.is_player_slot):
                return true

    return false

func _try_activate_seven_tools(seven_tools: TrapData, target_trap: TrapData, attacker, defender) -> bool:

    if seven_tools.owner.is_player_slot == target_trap.owner.is_player_slot:
        return false








    var can_activate = true
    for cond in seven_tools.conditions:
        if cond.has_method("check_negation"):
            var res = cond.check_negation(target_trap, seven_tools)
            if res is Object and res.get_class() == "GDScriptFunctionState":
                res = await res
            if not res:
                can_activate = false
                break

    if can_activate:
        print("TrapManager: Seven Tools of the Bandit (ID 735) interceptando ativação de ", target_trap.name)

        for effect in seven_tools.effects:
            if effect.has_method("apply"):
                await effect.apply(attacker, defender, seven_tools)


        remove_trap(seven_tools, attacker, defender)
        EventBus.trap_consumed.emit(seven_tools, attacker, defender)

        var dm = EffectManager.duel_manager
        if dm: await dm.get_tree().process_frame
        return true

    return false


func check_magic_negation(magic_card: CardData, is_player_spell: bool) -> bool:
    var duel_manager = EffectManager.duel_manager
    if not duel_manager:
        return false

    var opponent_traps = player_traps if not is_player_spell else enemy_traps

    if opponent_traps.is_empty():
        return false

    for counter_trap in opponent_traps:
        if counter_trap.id == 749:

            if await _try_activate_magic_jammer(counter_trap, magic_card, is_player_spell):
                return true
        elif counter_trap.id == 754:

            if await _try_activate_solemn_judgment(counter_trap, magic_card, is_player_spell):
                return true
        elif counter_trap.id == 758:

            if await _try_activate_divine_punishment(counter_trap, magic_card, is_player_spell):
                return true

    return false

func _try_activate_magic_jammer(magic_jammer: TrapData, target_magic: CardData, is_player_spell: bool) -> bool:
    var duel_manager = EffectManager.duel_manager
    var owner_is_player = magic_jammer.owner.is_player_slot


    if owner_is_player == is_player_spell:
        return false


    var owner_hand = duel_manager.player_hand if owner_is_player else duel_manager.enemy_hand
    var valid_cards = []

    for i in range(owner_hand.size()):
        if owner_hand[i] != null:
            valid_cards.append(i)

    if valid_cards.is_empty():
        print("TrapManager: Magic Jammer sem cartas na mão para descartar. Custo não pode ser pago.")
        return false


    var discard_idx = valid_cards[randi() % valid_cards.size()]
    var discarded_card = owner_hand[discard_idx]
    owner_hand[discard_idx] = null
    print("TrapManager: Magic Jammer descartou ", discarded_card.name, " como custo.")
    duel_manager.send_to_graveyard(discarded_card, owner_is_player, true)

    if owner_is_player:
        duel_manager.update_hand_ui()
    else:
        duel_manager.update_enemy_hand_ui()

    print("TrapManager: Magic Jammer (ID 749) interceptando ativação de Mágica: ", target_magic.name)


    remove_trap(magic_jammer, null, null)
    EventBus.trap_consumed.emit(magic_jammer, null, null)

    await duel_manager.get_tree().process_frame
    return true


func check_summon_negation(monster_card: CardData, is_player_summon: bool) -> bool:
    var duel_manager = EffectManager.duel_manager
    if not duel_manager:
        return false

    var opponent_traps = player_traps if not is_player_summon else enemy_traps

    if opponent_traps.is_empty():
        return false

    for counter_trap in opponent_traps:
        if counter_trap.id == 754:

            if await _try_activate_solemn_judgment(counter_trap, monster_card, is_player_summon):
                return true
        elif counter_trap.id == 758:

            if await _try_activate_divine_punishment(counter_trap, monster_card, is_player_summon):
                return true

    return false

func _try_activate_solemn_judgment(solemn_judgment: TrapData, target_card: CardData, is_player_action: bool) -> bool:
    var duel_manager = EffectManager.duel_manager
    var owner_is_player = solemn_judgment.owner.is_player_slot


    if owner_is_player == is_player_action:
        return false


    if owner_is_player:
        var current_lp = duel_manager.player_lp
        var cost = int(current_lp / 2.0)
        duel_manager.player_lp -= cost
        duel_manager.update_lp_ui()
        duel_manager.check_game_over()
        print("TrapManager: Solemn Judgment pagou ", cost, " LP (Metade) como custo.")
    else:
        var current_lp = duel_manager.enemy_lp
        var cost = int(current_lp / 2.0)
        duel_manager.enemy_lp -= cost
        duel_manager.update_lp_ui()
        duel_manager.check_game_over()
        print("TrapManager: Solemn Judgment pagou ", cost, " LP (Metade) como custo.")

    print("TrapManager: Solemn Judgment (ID 754) interceptando e destruindo a carta: ", target_card.name)









    remove_trap(solemn_judgment, null, null)
    EventBus.trap_consumed.emit(solemn_judgment, null, null)

    await duel_manager.get_tree().process_frame
    return true

func _try_activate_divine_punishment(divine_punishment: TrapData, target_card: CardData, is_player_action: bool) -> bool:
    var duel_manager = EffectManager.duel_manager
    var owner_is_player = divine_punishment.owner.is_player_slot


    if owner_is_player == is_player_action:
        return false



    var is_monster = target_card.category in [
        CardData.CardCategory.NORMAL_MONSTER, 
        CardData.CardCategory.EFFECT_MONSTER, 
        CardData.CardCategory.FUSION_MONSTER, 
        CardData.CardCategory.RITUAL_MONSTER, 
        CardData.CardCategory.SYNCHRO_MONSTER, 
        CardData.CardCategory.XYZ_MONSTER, 
        CardData.CardCategory.PENDULUM_MONSTER, 
        CardData.CardCategory.LINK_MONSTER
    ]
    if is_monster:
        if not EffectManager.has_on_summon_effect(target_card.id):
            return false


    var owner_slots = duel_manager.player_slots if owner_is_player else duel_manager.enemy_slots
    var fairy_count = 0
    for slot in owner_slots:
        if slot.is_occupied and slot.stored_card_data:
            var card = slot.stored_card_data
            if card.type and card.type.to_lower() == "fairy":
                fairy_count += 1

    var damage = fairy_count * 500

    print("TrapManager: Divine Punishment (ID 758) interceptando e destruindo a carta: ", target_card.name)
    if damage > 0:
        print("TrapManager: Divine Punishment causando ", damage, " de dano (", fairy_count, " Fairy monsters)")
        if owner_is_player:
            duel_manager.enemy_lp -= damage
        else:
            duel_manager.player_lp -= damage
        duel_manager.update_lp_ui()
        duel_manager.check_game_over()





    remove_trap(divine_punishment, null, null)
    EventBus.trap_consumed.emit(divine_punishment, null, null)

    await duel_manager.get_tree().process_frame
    return true



func _on_attacker(attacker, defender) -> void :
    var dm = EffectManager.duel_manager
    if dm: dm.is_processing_trap = true


    var all_traps = player_traps + enemy_traps

    if all_traps.is_empty():
        if dm: dm.is_processing_trap = false
        return


    var valid_traps = []
    for trap in all_traps:
        if trap.trigger_type == "attack" and is_instance_valid(trap.owner):
            valid_traps.append(trap)


    valid_traps.sort_custom( func(a, b):
        var a_is_defender = (a.owner.is_player_slot != attacker.is_player_slot)
        var b_is_defender = (b.owner.is_player_slot != attacker.is_player_slot)
        if a_is_defender != b_is_defender:
            return a_is_defender
        return a.owner.slot_index < b.owner.slot_index
    )

    for trap in valid_traps:
        if await trap.try_active(attacker, defender):


            if trap.cancels_battle:
                var dm_ref = EffectManager.duel_manager
                if dm_ref and "trap_canceled_the_battle" in dm_ref:
                    dm_ref.trap_canceled_the_battle = true
                break

    if dm: dm.is_processing_trap = false



func _on_monster_summoned(summoned_slot, card_data, is_player_owner) -> void :
    var dm = EffectManager.duel_manager
    if dm: dm.is_processing_trap = true


    var opponent_traps = enemy_traps if is_player_owner else player_traps

    if opponent_traps.is_empty():
        if dm: dm.is_processing_trap = false
        return


    var valid_traps = []
    for trap in opponent_traps:
        if trap.trigger_type == "summon" and is_instance_valid(trap.owner):
            valid_traps.append(trap)

    valid_traps.sort_custom( func(a, b): return a.owner.slot_index < b.owner.slot_index)

    for trap in valid_traps:
        if await trap.try_active_on_summon(summoned_slot, card_data):
            break

    if dm: dm.is_processing_trap = false



func _on_monster_destroyed(slot_node, card_data, _is_player_owner) -> void :
    var dm = EffectManager.duel_manager
    if dm: dm.is_processing_trap = true


    var all_traps = player_traps + enemy_traps

    if all_traps.is_empty():
        if dm: dm.is_processing_trap = false
        return


    var valid_traps = []
    for trap in all_traps:
        if trap.trigger_type == "destruction" and is_instance_valid(trap.owner):
            valid_traps.append(trap)


    valid_traps.sort_custom( func(a, b): return a.owner.slot_index < b.owner.slot_index)

    for trap in valid_traps:
        if trap.has_method("try_active_on_destruction"):
            if await trap.try_active_on_destruction(slot_node, card_data):
                break

    if dm: dm.is_processing_trap = false
