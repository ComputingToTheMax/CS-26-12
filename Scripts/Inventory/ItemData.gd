extends Resource
class_name ItemData

enum InventoryCategory {
	ITEM,
	PART,
	MEMBER
}

enum ItemSubfilter {
	NONE,
	IRON,
	COPPER,
	CARBON_FIBER,
	STEEL,
	SILICONE,
	WATER
}

enum PartSubfilter {
	NONE,
	ENGINE,
	WING,
	FUEL_TANK,
	NOSE_CONE,
	BODY_PANELS,
	ELECTRICAL_COMPONENTS
}

enum MemberSubfilter {
	NONE,
	ECONOMY,
	BUFF,
	SUPPORT,
	LUCK
}

@export var id: String
@export var display_name: String
@export var mission: String

@export var speed: int
@export var durability: int
@export var efficiency: int
@export var time_bonus: int
@export var difficulty_reduction: int
@export var icon: Texture2D
@export var value: int = 10
@export var max_stack: int = 99
@export var buy_price: int = 10
@export var sell_price: int = 5
@export_multiline var description: String = ""
@export var category: InventoryCategory = InventoryCategory.ITEM

@export var item_subfilter: ItemSubfilter = ItemSubfilter.NONE
@export var part_subfilter: PartSubfilter = PartSubfilter.NONE
@export var member_subfilter: MemberSubfilter = MemberSubfilter.NONE
