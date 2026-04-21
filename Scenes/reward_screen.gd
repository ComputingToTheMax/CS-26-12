extends Control

signal item_chosen(part_instance: PartInstance)

var _reward_parts: Array[PartInstance] = []
var _picked: bool = false
var _database: ItemDatabase
var _player_inventory: InventoryModel
var _buttons: Array[Button] = []
var _title_label: Label
var _hint_label: Label

func setup(player_inventory: InventoryModel) -> void:
	_player_inventory = player_inventory

func _ready() -> void:
	randomize()

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	anchor_right = 1.0
	anchor_bottom = 1.0
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH

	_database = ItemDatabase.new()
	_database.load_items("")

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
	panel.custom_minimum_size = Vector2(760, 360)
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
	_hint_label.text = "Tap a part to claim it."
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 14)
	inner_vbox.add_child(_hint_label)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 16)
	inner_vbox.add_child(hbox)

	for i in range(3):
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(220, 240)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.visible = false
		btn.pressed.connect(_on_item_picked.bind(i))
		hbox.add_child(btn)
		_buttons.append(btn)

func _populate_rewards() -> void:
	_reward_parts.clear()

	var valid_part_ids: Array = []

	for id in _database.items.keys():
		var item: ItemData = _database.get_item(id)
		if item == null:
			continue

		if item.category == ItemData.InventoryCategory.PART:
			valid_part_ids.append(id)

	valid_part_ids.shuffle()

	var chosen_count: int = min(3, valid_part_ids.size())

	for i in range(chosen_count):
		var item: ItemData = _database.get_item(valid_part_ids[i])
		if item == null:
			continue

		var reward: PartInstance = RewardGen.make_random_part(item)
		_reward_parts.append(reward)

	for i in range(_buttons.size()):
		if i >= _reward_parts.size():
			_buttons[i].visible = false
			continue

		var reward: PartInstance = _reward_parts[i]
		_buttons[i].text = "%s\n\n%s\n\n%s" % [
			reward.get_display_name(),
			reward.get_description(),
			reward.get_stat_text()
		]
		_buttons[i].visible = true

func _on_item_picked(index: int) -> void:
	if _picked:
		return
	if index < 0 or index >= _reward_parts.size():
		return

	_picked = true

	var reward: PartInstance = _reward_parts[index]

	if reward != null and _player_inventory != null:
		var success: bool = _player_inventory.add_part_instance(reward)
		if not success:
			print("Inventory full, could not add: ", reward.get_display_name())
		else:
			print("Claimed: ", reward.get_display_name(), " [", reward.get_rarity_name(), "]")

	item_chosen.emit(reward)
	queue_free()
