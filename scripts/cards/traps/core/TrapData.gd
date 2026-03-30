extends Resource
class_name TrapData



var id: int
var name: String
var owner
var consume_after_trigger: = true
var cancels_battle: = true
var trigger_type: String = "attack"

var conditions: Array
var effects: Array

func _init(_id: int = -999, _name: String = "Trap Generic", _consume_after_trigger: bool = true, _coditions: Array[Resource] = [], _effects: Array[Resource] = [], _cancels_battle: bool = true, _trigger_type: String = "attack"):
    id = _id
    name = _name
    consume_after_trigger = _consume_after_trigger
    conditions = _coditions
    effects = _effects
    cancels_battle = _cancels_battle
    trigger_type = _trigger_type


func try_active(attacker, defender) -> bool:

    if owner == null:
        push_error("TrapData.try_active: owner é null!")
        return false


    if attacker == null:
        push_error("TrapData.try_active: attacker é null!")
        return false


    if not conditions.is_empty():
        for codition: Resource in conditions:
            if codition.has_method("check"):
                if not codition.check(attacker, defender, self):
                    return false
            else:
                push_error("function check not founded")
                return false


    if TrapManager.has_method("check_negation") and await TrapManager.check_negation(self, attacker, defender):
        print("TrapData: %s foi NEGADA por uma contra-trap!" % name)
        if consume_after_trigger:
            TrapManager.remove_trap(self, attacker, defender)
        EventBus.trap_consumed.emit(self, attacker, defender)
        return true


    EventBus.trap_triggered.emit(self)

    if owner and owner.has_method("get_tree"):
        await owner.get_tree().create_timer(0.6).timeout


    if not effects.is_empty():
        for effect: Resource in effects:
            if effect.has_method("apply"):
                await effect.apply(attacker, defender, self)


    if consume_after_trigger:
        TrapManager.remove_trap(self, attacker, defender)


    EventBus.trap_consumed.emit(self, attacker, defender)
    return true


func try_active_on_summon(summoned_slot, card_data) -> bool:

    if owner == null:
        push_error("TrapData.try_active_on_summon: owner é null!")
        return false


    if summoned_slot == null:
        push_error("TrapData.try_active_on_summon: summoned_slot é null!")
        return false


    if not conditions.is_empty():
        for codition: Resource in conditions:
            if codition.has_method("check_summon"):
                if not codition.check_summon(summoned_slot, card_data, self):
                    return false
            else:
                push_error("function check_summon not found in condition")
                return false


    if TrapManager.has_method("check_negation") and await TrapManager.check_negation(self, summoned_slot, null):
        print("TrapData: %s (On Summon) foi NEGADA!" % name)
        if consume_after_trigger:
            TrapManager.remove_trap(self, summoned_slot, null)
        EventBus.trap_consumed.emit(self, summoned_slot, null)
        return true


    EventBus.trap_triggered.emit(self)

    if owner and owner.has_method("get_tree"):
        await owner.get_tree().create_timer(0.6).timeout


    if not effects.is_empty():
        for effect: Resource in effects:
            if effect.has_method("apply_on_summon"):
                await effect.apply_on_summon(summoned_slot, card_data, self)
            elif effect.has_method("apply"):

                await effect.apply(summoned_slot, null, self)


    if consume_after_trigger:
        TrapManager.remove_trap(self, summoned_slot, null)


    EventBus.trap_consumed.emit(self, summoned_slot, null)
    return true


func try_active_on_equip(target_slot, equip_id: int) -> bool:

    if owner == null:
        push_error("TrapData.try_active_on_equip: owner é null!")
        return false


    if target_slot == null:
        push_error("TrapData.try_active_on_equip: target_slot é null!")
        return false


    if not conditions.is_empty():
        for codition: Resource in conditions:
            if codition.has_method("check_equip"):
                if not codition.check_equip(target_slot, equip_id, self):
                    return false
            else:
                push_error("function check_equip not found in condition")
                return false


    if TrapManager.has_method("check_negation") and await TrapManager.check_negation(self, target_slot, null):
        print("TrapData: %s (On Equip) foi NEGADA!" % name)
        if consume_after_trigger:
            TrapManager.remove_trap(self, target_slot, null)
        EventBus.trap_consumed.emit(self, target_slot, null)
        return true


    EventBus.trap_triggered.emit(self)

    if owner and owner.has_method("get_tree"):
        await owner.get_tree().create_timer(0.6).timeout


    if not effects.is_empty():
        for effect: Resource in effects:
            if effect.has_method("apply_on_equip"):
                await effect.apply_on_equip(target_slot, equip_id, self)
            elif effect.has_method("apply"):

                await effect.apply(target_slot, null, self)


    if consume_after_trigger:
        TrapManager.remove_trap(self, target_slot, null)


    EventBus.trap_consumed.emit(self, target_slot, null)
    return true



func try_active_on_destruction(slot_node, card_data) -> bool:

    if owner == null:
        push_error("TrapData.try_active_on_destruction: owner é null!")
        return false


    if not conditions.is_empty():
        for codition: Resource in conditions:
            if codition.has_method("check_destruction"):
                if not codition.check_destruction(slot_node, card_data, self):
                    return false
            else:
                push_error("function check_destruction not found in condition")
                return false


    if TrapManager.has_method("check_negation") and await TrapManager.check_negation(self, slot_node, null):
        print("TrapData: %s (On Destruction) foi NEGADA!" % name)
        if consume_after_trigger:
            TrapManager.remove_trap(self, slot_node, null)
        EventBus.trap_consumed.emit(self, slot_node, null)
        return true


    EventBus.trap_triggered.emit(self)

    if owner and owner.has_method("get_tree"):
        await owner.get_tree().create_timer(0.6).timeout


    if not effects.is_empty():
        for effect: Resource in effects:
            if effect.has_method("apply_on_destruction"):
                await effect.apply_on_destruction(slot_node, card_data, self)
            elif effect.has_method("apply"):
                await effect.apply(slot_node, null, self)


    if consume_after_trigger:
        TrapManager.remove_trap(self, slot_node, null)


    EventBus.trap_consumed.emit(self, slot_node, null)
    return true
