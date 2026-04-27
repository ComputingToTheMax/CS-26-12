extends Node
class_name ItemDatabase

@export_file("*.json") var item_data_json: String = "res://Items/ItemDatabase_updated.json"

const SHIP_PART_ICON_BY_SUBFILTER := {
	ItemData.PartSubfilter.ENGINE: "res://Sources/Images/Parts/engine.png",
	ItemData.PartSubfilter.WING: "res://Sources/Images/Parts/fin.png",
	ItemData.PartSubfilter.FUEL_TANK: "res://Sources/Images/Parts/tank.png",
	ItemData.PartSubfilter.NOSE_CONE: "res://Sources/Images/Parts/cone.png",
	ItemData.PartSubfilter.BODY_PANELS: "res://Sources/Images/Parts/panel.png",
	ItemData.PartSubfilter.ELECTRICAL_COMPONENTS: "res://Sources/Images/Parts/wire.png",
	ItemData.PartSubfilter.ENGINE_HOUSING: "res://Sources/Images/Parts/cockpit.png"
}

const REQUIRED_SHIP_PART_SETUP := [
	{"id": "0", "subfilter": ItemData.PartSubfilter.ENGINE},
	{"id": "1", "subfilter": ItemData.PartSubfilter.WING},
	{"id": "2", "subfilter": ItemData.PartSubfilter.FUEL_TANK},
	{"id": "3", "subfilter": ItemData.PartSubfilter.NOSE_CONE},
	{"id": "4", "subfilter": ItemData.PartSubfilter.BODY_PANELS},
	{"id": "5", "subfilter": ItemData.PartSubfilter.ELECTRICAL_COMPONENTS},
	{"id": "6", "subfilter": ItemData.PartSubfilter.ENGINE_HOUSING}
]

var items_by_id: Dictionary = {}
var all_items: Array[ItemData] = []

func create_database(path: String = "") -> void:
	load_items(path)

func load_items(path: String = "") -> void:
	items_by_id.clear()
	all_items.clear()

	if path.strip_edges() != "":
		item_data_json = path

	if item_data_json.strip_edges() == "":
		push_error("ItemDatabase: item_data_json path is empty.")
		return

	if not FileAccess.file_exists(item_data_json):
		push_error("ItemDatabase: JSON file not found: %s" % item_data_json)
		return

	var file: FileAccess = FileAccess.open(item_data_json, FileAccess.READ)
	if file == null:
		push_error("ItemDatabase: Failed to open JSON file: %s" % item_data_json)
		return

	var json_text: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var parse_result: int = json.parse(json_text)
	if parse_result != OK:
		push_error("ItemDatabase: JSON parse error in %s at line %d: %s" % [
			item_data_json,
			json.get_error_line(),
			json.get_error_message()
		])
		return

	var root: Variant = json.data
	if typeof(root) != TYPE_DICTIONARY:
		push_error("ItemDatabase: Root JSON is not a dictionary.")
		return

	var items_array: Array = root.get("items", [])
	for entry_variant in items_array:
		if typeof(entry_variant) != TYPE_DICTIONARY:
			continue

		var entry: Dictionary = entry_variant
		var item: ItemData = _build_item_from_json(entry)
		if item == null:
			continue

		all_items.append(item)
		items_by_id[item.id] = item

	_apply_mvp_ship_part_mapping()

func _build_item_from_json(entry: Dictionary) -> ItemData:
	var item: ItemData = ItemData.new()

	item.id = str(entry.get("ID", ""))
	item.display_name = str(entry.get("Name", ""))
	item.mission = str(entry.get("Mission", ""))
	item.description = str(entry.get("Description", ""))

	item.value = _to_int(entry.get("Price", 0))
	item.buy_price = item.value
	item.sell_price = max(1, int(item.value / 2))
	item.max_stack = _to_int(entry.get("MaxStack", 1))

	var icon_path: String = str(entry.get("Icon", ""))
	if icon_path != "":
		var tex: Variant = load(icon_path)
		if tex is Texture2D:
			item.icon = tex

	item.category = _to_int(entry.get("Category", ItemData.InventoryCategory.ITEM))
	item.item_subfilter = _to_int(entry.get("ItemSubfilter", ItemData.ItemSubfilter.NONE))
	item.part_subfilter = _to_int(entry.get("PartSubfilter", ItemData.PartSubfilter.NONE))
	item.member_subfilter = _to_int(entry.get("MemberSubfilter", ItemData.MemberSubfilter.NONE))

	item.aerodynamics = _to_float(entry.get("Aerodynamics", 0))
	item.weight = _to_float(entry.get("Weight", 0))
	item.cost = _to_float(entry.get("Cost", 0))
	item.repairability = _to_float(entry.get("Repairability", 0))
	item.acceleration = _to_float(entry.get("Acceleration", 0))

	return item

func _apply_mvp_ship_part_mapping() -> void:
	for setup_variant in REQUIRED_SHIP_PART_SETUP:
		var setup: Dictionary = setup_variant
		var item_id: String = str(setup.get("id", ""))
		var subfilter: int = int(setup.get("subfilter", ItemData.PartSubfilter.NONE))

		var item: ItemData = get_item_by_id(item_id)
		if item == null:
			continue

		item.category = ItemData.InventoryCategory.PART
		item.part_subfilter = subfilter
		item.icon = _load_ship_part_icon(subfilter)

	for item in all_items:
		if item == null:
			continue

		if item.category != ItemData.InventoryCategory.PART:
			continue

		if item.part_subfilter == ItemData.PartSubfilter.NONE:
			item.part_subfilter = ItemData.PartSubfilter.BODY_PANELS

		if item.icon == null or item.icon.resource_path == "res://Sources/Images/star.png":
			item.icon = _load_ship_part_icon(item.part_subfilter)

func _load_ship_part_icon(subfilter: int) -> Texture2D:
	var icon_path: String = str(SHIP_PART_ICON_BY_SUBFILTER.get(
		subfilter,
		"res://Sources/Images/Parts/panel.png"
	))

	var tex: Variant = load(icon_path)
	if tex is Texture2D:
		return tex

	var fallback: Variant = load("res://Sources/Images/Placeholder.png")
	if fallback is Texture2D:
		return fallback

	return null

func get_item_by_id(id: String) -> ItemData:
	return items_by_id.get(id, null)

func get_all_items() -> Array[ItemData]:
	return all_items.duplicate()

func get_items_by_category(category: int) -> Array[ItemData]:
	var results: Array[ItemData] = []
	for item in all_items:
		if item.category == category:
			results.append(item)
	return results

func get_parts_by_subfilter(part_subfilter: int) -> Array[ItemData]:
	var results: Array[ItemData] = []
	for item in all_items:
		if item.category == ItemData.InventoryCategory.PART and item.part_subfilter == part_subfilter:
			results.append(item)
	return results

func _to_int(value: Variant, default_value: int = 0) -> int:
	match typeof(value):
		TYPE_INT:
			return value
		TYPE_FLOAT:
			return int(value)
		TYPE_STRING:
			if value.is_valid_int():
				return int(value)
			if value.is_valid_float():
				return int(float(value))
	return default_value

func _to_float(value: Variant, default_value: float = 0.0) -> float:
	match typeof(value):
		TYPE_INT:
			return float(value)
		TYPE_FLOAT:
			return value
		TYPE_STRING:
			if value.is_valid_float():
				return float(value)
			if value.is_valid_int():
				return float(int(value))
	return default_value
