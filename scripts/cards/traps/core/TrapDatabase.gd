extends Node
class_name TrapDatabase












const OnOpponentCardPlay = preload("res://scripts/cards/traps/conditions/OnOpponentCardPlay.gd")
const OnOwnerAttack = preload("res://scripts/cards/traps/conditions/OnOwnerAttack.gd")
const OnOpponentCardPlayWithField = preload("res://scripts/cards/traps/conditions/OnOpponentCardPlayWithField.gd")
const OnOpponentSummonWithRockInGrave = preload("res://scripts/cards/traps/conditions/OnOpponentSummonWithRockInGrave.gd")

const SolemnJudgmentEffect = preload("res://scripts/cards/traps/effects/SolemnJudgmentEffect.gd")
const RobbinGoblinActivateEffect = preload("res://scripts/cards/traps/effects/RobbinGoblinActivateEffect.gd")
const DivinePunishmentEffect = preload("res://scripts/cards/traps/effects/DivinePunishmentEffect.gd")
const ReleaseFromStoneEffect = preload("res://scripts/cards/traps/effects/ReleaseFromStoneEffect.gd")




static var trap_factories: Dictionary = {




    723: func(): return TrapData.new(723, "Mirror Force", true, [OnOpponentAttack.new()], [MirrorForceEffect.new()], true), 
    329: func(): return TrapData.new(329, "Dragon Capture Jar", true, [OnOpponentAttackIsDragon.new()], [DestroyAllOpponentDragonsEffect.new()], true), 
    349: func(): return TrapData.new(349, "Spellbinding Circle", true, [OnOpponentAttack.new()], [HalveAttackerStatsEffect.new()], false), 
    651: func(): return TrapData.new(651, "Kunai With Chain", true, [OnOpponentAttackOnMonster.new()], [BoostDefenderAtkEffect.new()], false), 
    659: func(): return TrapData.new(659, "Waboku", true, [OnOpponentAttack.new()], [WabokuEffect.new()], false), 
    661: func(): return TrapData.new(661, "Crush Card", true, [OnOpponentSummonsHighAtk.new()], [CrushCardEffect.new()], true, "summon"), 
    666: func(): return TrapData.new(666, "Trap Hole", true, [OnOpponentSummonsTrapHole.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    669: func(): return TrapData.new(669, "Shadow Spell", true, [OnOpponentAttack.new()], [DecreaseAttackerAtkEffect.new()], false), 
    681: func(): return TrapData.new(681, "House of Adhesive Tape", true, [OnOpponentSummonsLowDef.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    682: func(): return TrapData.new(682, "Eatgaboon", true, [OnOpponentSummonsLowAtk.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    683: func(): return TrapData.new(683, "Bear Trap", true, [OnOpponentSummonsBearTrap.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    684: func(): return TrapData.new(684, "Invisible Wire", true, [OnOpponentSummonsInvisibleWire.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    685: func(): return TrapData.new(685, "Acid Trap Hole", true, [OnOpponentSummonsHighDef.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    686: func(): return TrapData.new(686, "Widespread Ruin", true, [OnOpponentAttack.new()], [WidespreadRuinEffect.new()], true), 
    687: func(): return TrapData.new(687, "Goblin Fan", true, [OnOpponentSummonsGoblinFan.new()], [DestroySummonedMonsterEffect.new()], true, "summon"), 
    688: func(): return TrapData.new(688, "Bad Reaction to Simochi", true, [], [], false, "heal"), 
    689: func(): return TrapData.new(689, "Reverse Trap", true, [], [], false, "passive"), 
    690: func(): return TrapData.new(690, "Fake Trap", true, [OnOpponentAttack.new()], [StopAttackEffect.new()], true), 
    695: func(): return TrapData.new(695, "Two-Pronged Attack", true, [OnTwoProngedCondition.new()], [TwoProngedAttackEffect.new()], true, "summon"), 
    727: func(): return TrapData.new(727, "Reinforcements", true, [OnOpponentAttacksAttackPosition.new()], [ReinforcementsEffect.new()], false), 
    729: func(): return TrapData.new(729, "Just Desserts", true, [OnOpponentSummon.new()], [JustDessertsEffect.new()], true, "summon"), 
    731: func(): return TrapData.new(731, "Castle Walls", true, [OnOpponentAttacksDefensePosition.new()], [CastleWallsEffect.new()], false), 
    735: func(): return TrapData.new(735, "Seven Tools of the Bandit", true, [OnOpponentTrapActivation.new()], [SevenToolsEffect.new()], false), 
    749: func(): return TrapData.new(749, "Magic Jammer", true, [OnOpponentMagicActivation.new()], [MagicJammerEffect.new()], false), 
    754: func(): return TrapData.new(754, "Solemn Judgment", true, [OnOpponentCardPlay.new()], [SolemnJudgmentEffect.new()], false, "passive"), 
    755: func(): return TrapData.new(755, "Robbin' Goblin", true, [OnOwnerAttack.new()], [RobbinGoblinActivateEffect.new()], false), 
    758: func(): return TrapData.new(758, "Divine Punishment", true, [OnOpponentCardPlayWithField.new()], [DivinePunishmentEffect.new()], false, "passive"), 
    764: func(): return TrapData.new(764, "Release from Stone", true, [OnOpponentSummonWithRockInGrave.new()], [ReleaseFromStoneEffect.new()], true, "summon"), 
    778: func(): return TrapData.new(778, "Survival Instinct", true, [OnOwnerDinosaurDestroyed.new()], [SurvivalInstinctEffect.new()], false, "destruction"), 
    779: func(): return TrapData.new(779, "Fossil Excavation", true, [OnOpponentSummonWithDinoInGrave.new()], [FossilExcavationEffect.new()], true, "summon"), 

}


static func create(id: int) -> TrapData:

    if not trap_factories.has(id):
        return null


    return trap_factories[id].call()
