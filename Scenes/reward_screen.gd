extends Control

signal item_chosen(item: ItemData)

var _picked := false
var _database: ItemDatabase = null
var _player_inventory: InventoryModel
var _title_label: Label
var _hint_label: Label
var _money_label: Label
var _chosen_items: Array[ItemData] = []

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
	panel.custom_minimum_size = Vector2(560, 320)
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
	_hint_label.text = "Click an item to claim it."
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 14)
	inner_vbox.add_child(_hint_label)
	
	_money_label = Label.new()
	var winnings = randi_range(5,10)
	_hint_label.text = "You won " + str(winnings) + " dollars"
	MoneySave.add_money(winnings)
	
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	inner_vbox.add_child(hbox)

	hbox.name = "ItemHBox"

func _create_item_display(item: ItemData, index: int) -> Control:

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(150, 200)
	btn.flat = false
	btn.pressed.connect(_on_item_picked.bind(index))

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 8)
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(vbox)

	var icon_rect := TextureRect.new()
	icon_rect.custom_minimum_size = Vector2(96, 96)
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if item.icon != null:
		icon_rect.texture = item.icon
	vbox.add_child(icon_rect)
	
	var name_label := Label.new()
	name_label.text = item.display_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 14)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(name_label)

	return btn

func _populate_rewards() -> void:
	var all_items: Array[ItemData] = _database.get_all_items()
	all_items.shuffle()
	var chosen: Array[ItemData] = all_items.slice(0, min(3, all_items.size()))

	for item in chosen:
		if item == null:
			continue
		_chosen_items.append(item)

	print("Items chosen: ", _chosen_items.size())

	var hbox := _find_node_by_name(self, "ItemHBox")
	if hbox == null:
		push_error("RewardScreen: could not find ItemHBox")
		return

	for i in range(_chosen_items.size()):
		var item: ItemData = _chosen_items[i]
		if item == null:
			continue
		var display := _create_item_display(item, i)
		hbox.add_child(display)

func _find_node_by_name(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var result := _find_node_by_name(child, target_name)
		if result != null:
			return result
	return null

func _on_item_picked(index: int) -> void:
	if _picked:
		return
	_picked = true

	if index >= _chosen_items.size():
		push_error("RewardScreen: picked index out of range")
		return

	var item: ItemData = _chosen_items[index]

	if item != null and _player_inventory != null:
		var success := _player_inventory.add_item(item, 1)
		if not success:
			print("Inventory full, could not add: ", item.display_name)
		else:
			print("Claimed: ", item.display_name)

	item_chosen.emit(item)
	queue_free()
