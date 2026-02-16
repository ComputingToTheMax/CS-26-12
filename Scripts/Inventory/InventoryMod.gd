extends Node
class_name InventoryModel

signal changed
@export var slot_button_scene: PackedScene
@export var slot_count: int = 24
@export var money: int = 0

# Each slot is either null, or { "item": ItemData, "qty": int }
var slots: Array = []

func _ready() -> void:
	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = null

func get_slot(i: int) -> Variant:
	return slots[i]

func set_slot(i: int, slot: Variant) -> void:
	slots[i] = slot
	emit_signal("changed")

func add_item(item: ItemData, amount: int = 1) -> int:
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

	# 2) place into empty slots
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

	# Inventory full, some items couldn't be added
	emit_signal("changed")
	return remaining


func remove_from_slot(i: int, amount: int) -> bool:
	var s = slots[i]
	if s == null:
		return false
	if amount <= 0:
		return false
	if int(s["qty"]) < amount:
		return false

	s["qty"] = int(s["qty"]) - amount
	if int(s["qty"]) <= 0:
		slots[i] = null
	emit_signal("changed")
	return true
