extends Control
class_name InventoryOverlay
const SLOT_BUTTON_SCENE_PATH := "res://Scenes/UI/SlotBtn.tscn"
var slot_button_scene: PackedScene = null
@export var rows: int = 3
@export var slot_size: Vector2 = Vector2(90, 110)

@onready var close_btn := $Screen/MarginContainer/VBoxContainer/TopBar/HBoxContainer/Closebtn as BaseButton
#@onready var grid := $Screen/InvPanel/CenterContainer/MarginContainer/GridContainer as GridContainer
@onready var money_label: Label = %MoneyLabel
@onready var progress: ProgressBar = %progress

@onready var sell_total_label: Label = $Screen/MarginContainer/VBoxContainer/BottomBar/HBoxContainer/Total
@onready var sell_confirm_btn: BaseButton = $Screen/MarginContainer/VBoxContainer/BottomBar/HBoxContainer/ConfirmSell
@onready var sell_cancel_btn: BaseButton = $Screen/MarginContainer/VBoxContainer/BottomBar/HBoxContainer/CancelSell
@onready var items_btn: BaseButton = $Screen/MarginContainer/VBoxContainer/TopBar/HBoxContainer/ItemBtn
@onready var parts_btn: BaseButton = $Screen/MarginContainer/VBoxContainer/TopBar/HBoxContainer/PartBtn
@onready var members_btn: BaseButton = $Screen/MarginContainer/VBoxContainer/TopBar/HBoxContainer/MemberBtn
@onready var category_label: Label = $Screen/MarginContainer/VBoxContainer/TopBar/CenterContainer/VBoxContainer/HBoxContainer/Category
@onready var subfilter: OptionButton = $Screen/MarginContainer/VBoxContainer/TopBar/CenterContainer/VBoxContainer/HBoxContainer/OptionButton
@onready var scroll_container: ScrollContainer = $Screen/MarginContainer/VBoxContainer/CenterContainer/ScrollContainer
@onready var grid: GridContainer = $Screen/MarginContainer/VBoxContainer/CenterContainer/ScrollContainer/GridContainer
var current_category: int = ItemData.InventoryCategory.ITEM
enum InventoryMode {
	NORMAL,
	SELL
}

var current_mode: InventoryMode = InventoryMode.NORMAL
var marked_for_sale: Dictionary = {} # { index: true }
var sell_target_shop = null
var sold_popup: AcceptDialog = null
var hover_tooltip: Panel = null
var hover_name_label: Label = null
var hover_desc_label: Label = null
var hovered_item: ItemData = null
var current_subfilter: String = "All"
var inventory_model: InventoryModel = null
var columns: int = 1
func _ready() -> void:
	slot_button_scene = load(SLOT_BUTTON_SCENE_PATH) as PackedScene
	print("grid node",grid)
	hide()
	if items_btn != null:
		items_btn.pressed.connect(_on_items_pressed)

	if parts_btn != null:
		parts_btn.pressed.connect(_on_parts_pressed)

	if members_btn != null:
		members_btn.pressed.connect(_on_members_pressed)
	if money_label == null:
		push_error("InventoryOverlay: MoneyLabel path is wrong or node is missing.")
		return
	if subfilter != null:
		if not subfilter.item_selected.is_connected(_on_subfilter_select):
			subfilter.item_selected.connect(_on_subfilter_select)
	if grid == null:
		push_error("InventoryOverlay: GridContainer path is wrong or node is missing.")
		return

	_create_sold_popup()
	_create_hover_tooltip()

	if close_btn != null:
		close_btn.pressed.connect(_on_close_pressed)

	if sell_total_label != null:
		#sell_total_label.text = "Total Profit: $0"
		sell_total_label.hide()

	if sell_confirm_btn != null:
		#sell_confirm_btn.text = "Sell"
		sell_confirm_btn.disabled = true
		sell_confirm_btn.hide()
		sell_confirm_btn.pressed.connect(_on_sell_confirm_pressed)

	if sell_cancel_btn != null:
		#sell_cancel_btn.text = "Cancel"
		sell_cancel_btn.hide()
		sell_cancel_btn.pressed.connect(_on_sell_cancel_pressed)

	_update_money(MoneySave.money)
	MoneySave.money_changed.connect(_update_money)
	_update_category_label()
	_populate_subfilter()
func _slot_matches_current_filter(slot_data: Variant) -> bool:
	if slot_data == null:
		return true

	var item: ItemData = slot_data.get("item", null)
	if item == null:
		return true

	if item.category != current_category:
		return false

	if current_subfilter == "All":
		return true

	match current_category:
		ItemData.InventoryCategory.ITEM:
			return _matches_item_subfilter(item)

		ItemData.InventoryCategory.PART:
			return _matches_part_subfilter(item)

		ItemData.InventoryCategory.MEMBER:
			return _matches_member_subfilter(item)

	return true
func _matches_item_subfilter(item: ItemData) -> bool:
	match current_subfilter:
		"All":
			return true
		"Iron":
			return item.item_subfilter == ItemData.ItemSubfilter.IRON
		"Copper":
			return item.item_subfilter == ItemData.ItemSubfilter.COPPER
		"Carbon Fiber":
			return item.item_subfilter == ItemData.ItemSubfilter.CARBON_FIBER
		"Steel":
			return item.item_subfilter == ItemData.ItemSubfilter.STEEL
		"Silicone":
			return item.item_subfilter == ItemData.ItemSubfilter.SILICONE
		"Water":
			return item.item_subfilter == ItemData.ItemSubfilter.WATER
		_:
			return true
func _matches_part_subfilter(item: ItemData) -> bool:
	match current_subfilter:
		"All":
			return true
		"Engine":
			return item.part_subfilter == ItemData.PartSubfilter.ENGINE
		"Wing":
			return item.part_subfilter == ItemData.PartSubfilter.WING
		"Fuel Tank":
			return item.part_subfilter == ItemData.PartSubfilter.FUEL_TANK
		"Nose Cone":
			return item.part_subfilter == ItemData.PartSubfilter.NOSE_CONE
		"Body Panels":
			return item.part_subfilter == ItemData.PartSubfilter.BODY_PANELS
		"Electrical Components":
			return item.part_subfilter == ItemData.PartSubfilter.ELECTRICAL_COMPONENTS
		_:
			return true
func _matches_member_subfilter(item: ItemData) -> bool:
	match current_subfilter:
		"All":
			return true
		"Economy":
			return item.member_subfilter == ItemData.MemberSubfilter.ECONOMY
		"Buff":
			return item.member_subfilter == ItemData.MemberSubfilter.BUFF
		"Support":
			return item.member_subfilter == ItemData.MemberSubfilter.SUPPORT
		"Luck":
			return item.member_subfilter == ItemData.MemberSubfilter.LUCK
		_:
			return true
func _on_subfilter_select(index: int) -> void:
	current_subfilter = subfilter.get_item_text(index)
	_rebuild_grid()
func _populate_subfilter() -> void:
	if subfilter == null:
		return

	subfilter.clear()

	match current_category:
		ItemData.InventoryCategory.ITEM:
			subfilter.add_item("All")
			subfilter.add_item("Iron")
			subfilter.add_item("Steel")
			subfilter.add_item("Carbon Fiber")
			subfilter.add_item("Copper")
			subfilter.add_item("Silicone")
			subfilter.add_item("Water")

		ItemData.InventoryCategory.PART:
			subfilter.add_item("All")
			subfilter.add_item("Engine")
			subfilter.add_item("Wing")
			subfilter.add_item("Fuel Tank")
			subfilter.add_item("Nose Cone")
			subfilter.add_item("Body Panels")
			subfilter.add_item("Electrical Components")
		ItemData.InventoryCategory.MEMBER:
			subfilter.add_item("All")
			subfilter.add_item("Support")
			subfilter.add_item("Economy")
			subfilter.add_item("Buff")
			subfilter.add_item("Luck")

	subfilter.select(0)
	current_subfilter = "All"
func _update_category_label() -> void:
	match current_category:
		ItemData.InventoryCategory.ITEM:
			category_label.text = "Items"

		ItemData.InventoryCategory.PART:
			category_label.text = "Parts"

		ItemData.InventoryCategory.MEMBER:
			category_label.text = "Members"
func _on_items_pressed() -> void:
	current_category = ItemData.InventoryCategory.ITEM
	_update_category_label()
	_populate_subfilter()
	_rebuild_grid()

func _on_parts_pressed() -> void:
	current_category = ItemData.InventoryCategory.PART
	_update_category_label()
	_populate_subfilter()
	_rebuild_grid()

func _on_members_pressed() -> void:
	current_category = ItemData.InventoryCategory.MEMBER
	_update_category_label()
	_populate_subfilter()
	_rebuild_grid()
func _create_sold_popup() -> void:
	sold_popup = AcceptDialog.new()
	sold_popup.title = "Sale Complete"
	sold_popup.dialog_text = "Successfully sold."
	sold_popup.visible = false
	add_child(sold_popup)
func _show_sold_popup(total: int) -> void:
	if sold_popup == null:
		return

	sold_popup.dialog_text = "Successfully sold items for $" + str(total) + "."
	sold_popup.popup_centered()
func _process(delta: float) -> void:
	if hover_tooltip != null and hover_tooltip.visible:
		_update_hover_tooltip_position()

func _create_hover_tooltip() -> void:
	hover_tooltip = Panel.new()
	hover_tooltip.name = "HoverTooltip"
	hover_tooltip.visible = false
	hover_tooltip.custom_minimum_size = Vector2(220, 100)
	hover_tooltip.z_index = 1000
	hover_tooltip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hover_tooltip)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 8
	vbox.offset_top = 8
	vbox.offset_right = -8
	vbox.offset_bottom = -8
	hover_tooltip.add_child(vbox)

	hover_name_label = Label.new()
	hover_name_label.text = ""
	hover_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(hover_name_label)

	hover_desc_label = Label.new()
	hover_desc_label.text = ""
	hover_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hover_desc_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hover_desc_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(hover_desc_label)

func show_hover_tooltip(item: ItemData) -> void:
	if item == null or hover_tooltip == null:
		hide_hover_tooltip()
		return

	hovered_item = item
	hover_name_label.text = item.display_name
	hover_desc_label.text = item.description
	hover_tooltip.show()
	_update_hover_tooltip_position()

func hide_hover_tooltip() -> void:
	hovered_item = null
	if hover_tooltip != null:
		hover_tooltip.hide()

func _update_hover_tooltip_position() -> void:
	if hover_tooltip == null:
		return

	var mouse_pos := get_global_mouse_position()
	var offset := Vector2(16, 16)
	var desired_pos := mouse_pos + offset

	var viewport_rect := get_viewport_rect()
	var tooltip_size := hover_tooltip.size

	if desired_pos.x + tooltip_size.x > viewport_rect.size.x:
		desired_pos.x = mouse_pos.x - tooltip_size.x - 16

	if desired_pos.y + tooltip_size.y > viewport_rect.size.y:
		desired_pos.y = mouse_pos.y - tooltip_size.y - 16

	hover_tooltip.global_position = desired_pos

func set_inventory(model: InventoryModel) -> void:
	if inventory_model != null and inventory_model.changed.is_connected(_rebuild_grid):
		inventory_model.changed.disconnect(_rebuild_grid)

	inventory_model = model

	if inventory_model != null:
		if not inventory_model.changed.is_connected(_rebuild_grid):
			inventory_model.changed.connect(_rebuild_grid)

	_rebuild_grid()

func enter_sell_mode(shop_ref = null) -> void:
	current_mode = InventoryMode.SELL
	sell_target_shop = shop_ref
	marked_for_sale.clear()

	if sell_total_label != null:
		sell_total_label.show()

	if sell_confirm_btn != null:
		sell_confirm_btn.show()

	if sell_cancel_btn != null:
		sell_cancel_btn.show()

	_update_sell_total()
	_rebuild_grid()
func exit_sell_mode() -> void:
	current_mode = InventoryMode.NORMAL
	sell_target_shop = null
	marked_for_sale.clear()

	if sell_total_label != null:
		sell_total_label.hide()

	if sell_confirm_btn != null:
		sell_confirm_btn.hide()
		sell_confirm_btn.disabled = true

	if sell_cancel_btn != null:
		sell_cancel_btn.hide()

	_rebuild_grid()

func _update_money(amount: int) -> void:
	if money_label != null:
		money_label.text = "Money: " + str(amount)

func _update_sell_total() -> void:
	var total := 0

	if inventory_model != null:
		for i in marked_for_sale.keys():
			var slot = inventory_model.get_slot(int(i))
			if slot == null:
				continue

			var item: ItemData = slot["item"]
			var qty: int = int(slot["qty"])
			total += item.sell_price * qty

	if sell_total_label != null:
		sell_total_label.text = "Total Profit: $" + str(total)

	_update_sell_buttons()
func _update_sell_buttons() -> void:
	var has_selection := not marked_for_sale.is_empty()

	if sell_confirm_btn != null:
		sell_confirm_btn.disabled = not has_selection

func _rebuild_grid() -> void:
	print("inventory model",inventory_model)
	for c in grid.get_children():
		c.queue_free()

	if inventory_model == null:
		return

	var range_info: Dictionary = inventory_model.get_category_slot_range(current_category)
	var start_index: int = int(range_info["start"])
	var count: int = int(range_info["count"])

	grid.columns = 6

	for i in range(start_index, start_index + count):
		var slot := slot_button_scene.instantiate() as SlotButton
		if slot == null:
			push_error("SlotBtn.tscn failed to instance.")
			return

		slot.index = i
		slot.inventory_model = inventory_model
		slot.custom_minimum_size = slot_size
		slot.marked_for_sale = marked_for_sale.has(i)

		match current_mode:
			InventoryMode.SELL:
				slot.interaction_mode = SlotButton.InteractionMode.SELL
				if not slot.sell_toggled.is_connected(_on_slot_sell_toggled):
					slot.sell_toggled.connect(_on_slot_sell_toggled)
			_:
				slot.interaction_mode = SlotButton.InteractionMode.DRAG

		if not slot.hovered_item.is_connected(show_hover_tooltip):
			slot.hovered_item.connect(show_hover_tooltip)
		if not slot.unhovered_item.is_connected(hide_hover_tooltip):
			slot.unhovered_item.connect(hide_hover_tooltip)

		grid.add_child(slot)
		slot.refresh()

		var slot_data = inventory_model.get_slot(i)
		var is_match := _slot_matches_current_filter(slot_data)
		slot.set_filter_enabled(is_match)

	if current_mode == InventoryMode.SELL:
		_update_sell_total()
func _on_slot_sell_toggled(index: int) -> void:
	if inventory_model == null:
		return

	var slot = inventory_model.get_slot(index)
	if slot == null:
		return

	if marked_for_sale.has(index):
		marked_for_sale.erase(index)
	else:
		marked_for_sale[index] = true

	_update_sell_total()
	_rebuild_grid()
func _on_sell_confirm_pressed() -> void:
	if inventory_model == null:
		return

	if marked_for_sale.is_empty():
		return

	var indexes: Array = marked_for_sale.keys()
	indexes.sort()
	indexes.reverse()

	var total := 0

	for i in indexes:
		var slot = inventory_model.get_slot(int(i))
		if slot == null:
			continue

		var item: ItemData = slot["item"]
		var qty: int = int(slot["qty"])
		total += item.sell_price * qty

		if sell_target_shop != null and sell_target_shop.has_method("receive_sold_item"):
			sell_target_shop.receive_sold_item(item, qty)

		inventory_model.remove_from_slot(int(i), qty)

	MoneySave.money += total

	_show_sold_popup(total)

	var shop_ref = sell_target_shop
	exit_sell_mode()
	hide()

	if shop_ref != null:
		shop_ref.show()
func _on_sell_cancel_pressed() -> void:
	var shop_ref = sell_target_shop
	exit_sell_mode()
	hide()

	if shop_ref != null:
		shop_ref.show()

func _on_close_pressed() -> void:
	hide_hover_tooltip()

	if current_mode == InventoryMode.SELL:
		var shop_ref = sell_target_shop
		exit_sell_mode()
		hide()

		if shop_ref != null:
			shop_ref.show()
		return

	hide()
