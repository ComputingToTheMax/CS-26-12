extends Node
class_name InventoryModel

signal changed

const SLOTS_PER_CATEGORY: int = 72
const CATEGORY_COUNT: int = 3

@export var slot_count: int = SLOTS_PER_CATEGORY * CATEGORY_COUNT

var slots: Array = []

func _init() -> void:
	initialize()

func initialize() -> void:
	slots.clear()
	slots.resize(slot_count)

	for i in range(slot_count):
		slots[i] = null

func ensure_initialized() -> void:
	if slots.size() != slot_count:
		initialize()

func clear() -> void:
	initialize()
	changed.emit()
func add_part_instance(part_instance: PartInstance) -> bool:
	if part_instance == null:
		return false

	var slot_index := get_first_empty_slot_in_category(ItemData.InventoryCategory.PART)
	if slot_index == -1:
		return false

	slots[slot_index] = {
		"item": part_instance,
		"item_data": part_instance.item_data
	}

	changed.emit()
	return true
func get_category_slot_range(category: int) -> Dictionary:
	match category:
		ItemData.InventoryCategory.ITEM:
			return {"start": 0, "count": SLOTS_PER_CATEGORY}
		ItemData.InventoryCategory.PART:
			return {"start": SLOTS_PER_CATEGORY, "count": SLOTS_PER_CATEGORY}
		ItemData.InventoryCategory.MEMBER:
			return {"start": SLOTS_PER_CATEGORY * 2, "count": SLOTS_PER_CATEGORY}
		_:
			return {"start": 0, "count": 0}

func get_slot(index: int) -> Variant:
	ensure_initialized()

	if index < 0 or index >= slot_count:
		return null

	return slots[index]

func set_slot(index: int, value: Variant) -> void:
	ensure_initialized()

	if index < 0 or index >= slot_count:
		return

	slots[index] = value
	changed.emit()

func get_slot_indexes_for_category(category: int) -> Array[int]:
	ensure_initialized()

	var result: Array[int] = []
	var range_info: Dictionary = get_category_slot_range(category)
	var start_index: int = int(range_info["start"])
	var count: int = int(range_info["count"])

	for i in range(start_index, start_index + count):
		result.append(i)

	return result

func get_occupied_slot_indexes_for_category(category: int) -> Array[int]:
	ensure_initialized()

	var result: Array[int] = []
	var range_info: Dictionary = get_category_slot_range(category)
	var start_index: int = int(range_info["start"])
	var count: int = int(range_info["count"])

	for i in range(start_index, start_index + count):
		if slots[i] != null:
			result.append(i)

	return result

func get_first_empty_slot_in_category(category: int) -> int:
	ensure_initialized()

	var range_info: Dictionary = get_category_slot_range(category)
	var start_index: int = int(range_info["start"])
	var count: int = int(range_info["count"])

	for i in range(start_index, start_index + count):
		if slots[i] == null:
			return i

	return -1

func add_item(item: ItemData, quantity: int = 1) -> bool:
	ensure_initialized()

	if item == null:
		return false

	var range_info: Dictionary = get_category_slot_range(item.category)
	var start_index: int = int(range_info["start"])
	var count: int = int(range_info["count"])

	for i in range(start_index, start_index + count):
		var slot_data = slots[i]
		if slot_data == null:
			continue

		var slot_item: ItemData = slot_data.get("item", null)
		if slot_item == null:
			continue

		if slot_item == item and int(slot_data.get("qty", 0)) < item.max_stack:
			var current_qty: int = int(slot_data.get("qty", 0))
			var space_left: int = item.max_stack - current_qty
			var amount_to_add: int = min(space_left, quantity)

			slot_data["qty"] = current_qty + amount_to_add
			quantity -= amount_to_add

			if quantity <= 0:
				changed.emit()
				return true

	while quantity > 0:
		var empty_index: int = get_first_empty_slot_in_category(item.category)
		if empty_index == -1:
			changed.emit()
			return false

		var amount_for_slot: int = min(quantity, item.max_stack)
		slots[empty_index] = {
			"item": item,
			"qty": amount_for_slot
		}
		quantity -= amount_for_slot

	changed.emit()
	return true

func remove_from_slot(index: int, amount: int = 1) -> bool:
	ensure_initialized()

	if index < 0 or index >= slot_count:
		return false

	var slot_data = slots[index]
	if slot_data == null:
		return false

	var current_qty: int = int(slot_data.get("qty", 0))
	if current_qty <= amount:
		slots[index] = null
	else:
		slot_data["qty"] = current_qty - amount

	changed.emit()
	return true

func transfer_or_swap(from_index: int, to_index: int) -> void:
	ensure_initialized()

	if from_index < 0 or from_index >= slot_count:
		return
	if to_index < 0 or to_index >= slot_count:
		return
	if from_index == to_index:
		return

	var from_slot = slots[from_index]
	var to_slot = slots[to_index]

	slots[to_index] = from_slot
	slots[from_index] = to_slot

	changed.emit()
