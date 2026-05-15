extends Resource
class_name PartInstance

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

const RARITY_NAMES := {
	Rarity.COMMON: "Common",
	Rarity.UNCOMMON: "Uncommon",
	Rarity.RARE: "Rare",
	Rarity.EPIC: "Epic",
	Rarity.LEGENDARY: "Legendary"
}

@export var item_data: ItemData
@export var rarity: int = Rarity.COMMON

@export var aerodynamics: float = 2.2
@export var weight: float = 2.2
@export var cost: float = 2.2
@export var repairability: float = 2.2
@export var acceleration: float = 2.2

@export var category: int = ItemData.InventoryCategory.PART
@export var item_subfilter: int = ItemData.ItemSubfilter.NONE
@export var part_subfilter: int = ItemData.PartSubfilter.NONE
@export var member_subfilter: int = ItemData.MemberSubfilter.NONE

@export var shop_price: int = 5

func initialize_from_item(data: ItemData) -> void:
	item_data = data

	if data == null:
		category = ItemData.InventoryCategory.PART
		item_subfilter = ItemData.ItemSubfilter.NONE
		part_subfilter = ItemData.PartSubfilter.NONE
		member_subfilter = ItemData.MemberSubfilter.NONE
		return

	category = data.category
	item_subfilter = data.item_subfilter
	part_subfilter = data.part_subfilter
	member_subfilter = data.member_subfilter

func get_display_name() -> String:
	if item_data == null:
		return "Unknown Part"
	return item_data.display_name

func get_description() -> String:
	if item_data == null:
		return ""
	return item_data.description

func get_icon():
	if item_data == null:
		return null
	return item_data.icon

func get_rarity_name() -> String:
	return RARITY_NAMES.get(rarity, "Common")

func get_total_stats() -> float:
	return aerodynamics + weight + cost + repairability + acceleration
func get_category()->int:
	return part_subfilter
func get_stat_text() -> String:
	return "[%s]\nAerodynamics: %.1f\nWeight: %.1f\nCost: %.1f\nRepairability: %.1f\nAcceleration: %.1f\nTotal: %.1f\nPrice: %d coins" % [
		get_rarity_name(),
		aerodynamics,
		weight,
		cost,
		repairability,
		acceleration,
		get_total_stats(),
		shop_price
	]
