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
	ELECTRICAL_COMPONENTS,
	ENGINE_HOUSING
}

enum MemberSubfilter {
	NONE,
	ECONOMY,
	BUFF,
	SUPPORT,
	LUCK
}

const INVENTORY_CATEGORY_NAMES := {
	InventoryCategory.ITEM: "Item",
	InventoryCategory.PART: "Part",
	InventoryCategory.MEMBER: "Member"
}

const ITEM_SUBFILTER_NAMES := {
	ItemSubfilter.NONE: "None",
	ItemSubfilter.IRON: "Iron",
	ItemSubfilter.COPPER: "Copper",
	ItemSubfilter.CARBON_FIBER: "Carbon Fiber",
	ItemSubfilter.STEEL: "Steel",
	ItemSubfilter.SILICONE: "Silicone",
	ItemSubfilter.WATER: "Water"
}

const PART_SUBFILTER_NAMES := {
	PartSubfilter.NONE: "None",
	PartSubfilter.ENGINE: "Engine",
	PartSubfilter.WING: "Wing",
	PartSubfilter.FUEL_TANK: "Fuel Tank",
	PartSubfilter.NOSE_CONE: "Nose Cone",
	PartSubfilter.BODY_PANELS: "Body Panels",
	PartSubfilter.ELECTRICAL_COMPONENTS: "Electrical Components",
	PartSubfilter.ENGINE_HOUSING: "Engine Housing"
}

const MEMBER_SUBFILTER_NAMES := {
	MemberSubfilter.NONE: "None",
	MemberSubfilter.ECONOMY: "Economy",
	MemberSubfilter.BUFF: "Buff",
	MemberSubfilter.SUPPORT: "Support",
	MemberSubfilter.LUCK: "Luck"
}

@export var id: String = ""
@export var display_name: String = ""
@export var mission: String = ""

@export var aerodynamics: int = 0
@export var weight: int = 0
@export var cost: int = 0
@export var repairability: int = 0
@export var acceleration: int = 0

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

func get_category_name() -> String:
	return INVENTORY_CATEGORY_NAMES.get(category, "Unknown")

func get_subfilter_name() -> String:
	match category:
		InventoryCategory.ITEM:
			return ITEM_SUBFILTER_NAMES.get(item_subfilter, "None")
		InventoryCategory.PART:
			return PART_SUBFILTER_NAMES.get(part_subfilter, "None")
		InventoryCategory.MEMBER:
			return MEMBER_SUBFILTER_NAMES.get(member_subfilter, "None")
	return "None"
