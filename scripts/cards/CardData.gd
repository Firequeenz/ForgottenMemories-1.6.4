extends Resource
class_name CardData

enum CardCategory{
    NORMAL_MONSTER, 
    EFFECT_MONSTER, 
    FUSION_MONSTER, 
    RITUAL_MONSTER, 
    SYNCHRO_MONSTER, 
    XYZ_MONSTER, 
    PENDULUM_MONSTER, 
    LINK_MONSTER, 
    MAGIC, 
    TRAP
}

var id: int
var name: String
var atk: int
var def: int
var type: String
var attribute: String
var guardian_star: String
var category: CardCategory
var level: int
var description: String = ""
var limit: int = 3
var is_copy: bool = false
var texture_path: String = ""
var field_bonus_applied: Dictionary = {"atk": 0, "def": 0}

func _init(
    _id: int = 0, 
    _name: String = "", 
    _atk: int = 0, 
    _def: int = 0, 
    _type: String = "", 
    _attribute: String = "", 
    _guardian_star: String = "", 
    _category: CardCategory = CardCategory.NORMAL_MONSTER, 
    _level: int = 0, 
    _description: String = "", 
    _limit: int = 3
):
    id = _id
    name = _name
    atk = _atk
    def = _def
    type = _type
    attribute = _attribute
    guardian_star = _guardian_star
    category = _category
    level = _level
    description = _description
    limit = _limit


func get_copy() -> CardData:
    var new_card = CardData.new(
        self.id, 
        self.name, 
        self.atk, 
        self.def, 
        self.type, 
        self.attribute, 
        self.guardian_star, 
        self.category, 
        self.level, 
        self.description, 
        self.limit
    )


    new_card.texture_path = self.texture_path
    new_card.is_copy = true

    return new_card


func get_original_atk_def() -> CardData:
    var db_card = CardDatabase.get_card(self.id)

    if db_card:

        return CardData.new(
            self.id, 
            self.name, 
            db_card.atk, 
            db_card.def, 
            self.type, 
            self.attribute, 
            self.guardian_star, 
            self.category, 
            self.level, 
            self.description, 
            self.limit
        )
    else:

        return self.get_copy()
