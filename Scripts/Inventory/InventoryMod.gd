extends Node
class_name InventoryModel

signal changed

@export var slot_count: int = 24
@export var money: int = 0
@export var debug_fill_on_ready: bool = true

var slots: Array = []
var item_db : ItemDatabase
var sampleItem: ItemData = preload("res://Items/stock/stock_item.tres")

func _ready() -> void:
	item_db = ItemDatabase.new()
	item_db.load_items("res://Items/ItemDatabase.json")

	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = null
	print("InventoryModel Ready")
	
	if debug_fill_on_ready:
		print("fill on ready true")
		add_item(item_db.get_item("0"), 5)
		add_item(sampleItem, 5)

func get_item_from_db(s: String)-> Variant:
	return item_db.get_item(s)

func get_slot(i: int) -> Variant:
	if i < 0 or i >= slot_count:
		return null
	return slots[i]

func set_slot(i: int, slot: Variant) -> void:
	if i < 0 or i >= slot_count:
		return
	slots[i] = slot
	emit_signal("changed")

func clear_slot(i: int) -> void:
	if i < 0 or i >= slot_count:
		return
	slots[i] = null
	emit_signal("changed")

func add_item(item: ItemData, amount: int = 1) -> int:
	if item == null or amount <= 0:
		return amount

	var remaining: int = amount

	for i in range(slot_count):
		var s: Variant = slots[i]
		if s == null:
			continue

		var sd: Dictionary = s as Dictionary
		var slot_item: ItemData = sd.get("item", null) as ItemData
		var slot_qty: int = int(sd.get("qty", 0))

		if slot_item == item and slot_qty < item.max_stack:
			var space: int = item.max_stack - slot_qty
			var add_now: int = min(space, remaining)

			sd["qty"] = slot_qty + add_now
			remaining -= add_now

			if remaining == 0:
				emit_signal("changed")
				return 0

	for i in range(slot_count):
		if slots[i] == null:
			var add_now: int = min(item.max_stack, remaining)
			slots[i] = {
				"item": item,
				"qty": add_now
			}
			remaining -= add_now

			if remaining == 0:
				emit_signal("changed")
				return 0

	emit_signal("changed")
	return remaining

func remove_from_slot(i: int, amount: int) -> bool:
	if i < 0 or i >= slot_count:
		return false
	if amount <= 0:
		return false

	var s: Variant = slots[i]
	if s == null:
		return false

	if int(s["qty"]) < amount:
		return false

	s["qty"] = int(s["qty"]) - amount
	if int(s["qty"]) <= 0:
		slots[i] = null

	emit_signal("changed")
	return true

func swap_slots(a: int, b: int) -> void:
	if a < 0 or a >= slot_count or b < 0 or b >= slot_count:
		return
	if a == b:
		return

	var temp = slots[a]
	slots[a] = slots[b]
	slots[b] = temp
	emit_signal("changed")

func transfer_or_swap(from_i: int, to_i: int) -> void:
	if from_i < 0 or from_i >= slot_count or to_i < 0 or to_i >= slot_count:
		return
	if from_i == to_i:
		return

	var from_slot: Variant = slots[from_i]
	var to_slot: Variant = slots[to_i]

	if from_slot == null:
		return

	if to_slot == null:
		slots[to_i] = from_slot
		slots[from_i] = null
		emit_signal("changed")
		return

	var from_item: ItemData = from_slot["item"]
	var to_item: ItemData = to_slot["item"]

	if from_item == to_item:
		var from_qty: int = int(from_slot["qty"])
		var to_qty: int = int(to_slot["qty"])
		var space: int = from_item.max_stack - to_qty

		if space > 0:
			var moved: int = min(space, from_qty)
			to_slot["qty"] = to_qty + moved
			from_slot["qty"] = from_qty - moved

			if int(from_slot["qty"]) <= 0:
				slots[from_i] = null

			emit_signal("changed")
			return

	var temp = slots[to_i]
	slots[to_i] = slots[from_i]
	slots[from_i] = temp
	emit_signal("changed")

func set_money(value: int) -> void:
	money = max(0, value)
	emit_signal("changed")

func add_money(amount: int) -> void:
	money += amount
	if money < 0:
		money = 0
	emit_signal("changed")
