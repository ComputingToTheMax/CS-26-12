extends Control

signal item_chosen(item: ItemData)

var _temp_inventory: InventoryModel
var _temp_slots: Array[int] = []
var _picked := false
var _database: ItemDatabase
var _player_inventory: InventoryModel
var _buttons: Array[Button] = []
var _title_label: Label
var _hint_label: Label

func setup(player_inventory: InventoryModel) -> void:
	_player_inventory = player_inventory
	
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	anchor_right = 1.0
	anchor_bottom = 1.0
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	_database = ItemDatabase.new()
	_database.load_items("res://Items/ItemDatabase.json")
	_build_ui()
	_populate_rewards()

func _build_ui() -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 280)
	center.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	vbox.add_child(margin)

	var inner_vbox := VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", 16)
	margin.add_child(inner_vbox)

	_title_label = Label.new()
	_title_label.text = "You won! Choose a reward."
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 22)
	inner_vbox.add_child(_title_label)

	_hint_label = Label.new()
	_hint_label.text = "Tap an item to claim it."
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 14)
	inner_vbox.add_child(_hint_label)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 16)
	inner_vbox.add_child(hbox)

	for i in range(3):
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(140, 120)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.visible = false
		btn.pressed.connect(_on_item_picked.bind(i))
		hbox.add_child(btn)
		_buttons.append(btn)

func _populate_rewards() -> void:
	print("Populating rewards, db item count: ", _database.items.size())
	_temp_inventory = InventoryModel.new()

	var all_ids: Array = _database.items.keys()
	all_ids.shuffle()
	var chosen_ids: Array = all_ids.slice(0, min(3, all_ids.size()))

	for id in chosen_ids:
		var item: ItemData = _database.get_item(id)
		if item == null:
			push_error("RewardScreen: item '%s' not found" % id)
			continue

		var slot_index := _temp_inventory.get_first_empty_slot_in_category(ItemData.InventoryCategory.ITEM)
		if slot_index == -1:
			push_error("RewardScreen: no empty slot available")
			continue
		_temp_slots.append(slot_index)
		_temp_inventory.add_item(item, 1)

	print("Temp slots filled: ", _temp_slots)

	for i in range(_buttons.size()):
		if i >= _temp_slots.size():
			continue
		var slot_data = _temp_inventory.get_slot(_temp_slots[i])
		print("Slot ", i, " data: ", slot_data)
		if slot_data == null:
			continue
		var item: ItemData = slot_data.get("item", null)
		if item == null:
			continue
		_buttons[i].text = item.display_name + "\n\n" + item.description
		_buttons[i].visible = true

func _on_item_picked(index: int) -> void:
	if _picked:
		return
	_picked = true

	var slot_data = _temp_inventory.get_slot(_temp_slots[index])
	var item: ItemData = slot_data.get("item", null) if slot_data else null

	for slot_index in _temp_slots:
		_temp_inventory.set_slot(slot_index, null)

	if item != null and _player_inventory != null:
		var success := _player_inventory.add_item(item, 1)
		if not success:
			print("Inventory full, could not add: ", item.display_name)
		else:
			print("Claimed: ", item.display_name)

	item_chosen.emit(item)
	queue_free()
