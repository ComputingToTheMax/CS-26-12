extends Control

signal closed

const SLOT_BUTTON_SCENE_PATH := "res://Scenes/UI/SlotBtn.tscn"

var slot_button_scene: PackedScene = null
var shop_inventory: InventoryModel = null

@export var slot_size: Vector2 = Vector2(90, 110)
@export var columns: int = 5

@onready var close_btn: BaseButton = $Control/Panel/Root/MarginContainer/NavBar/Close
@onready var buy_btn: BaseButton = $Control/Panel/Root/MarginContainer/MainShopCont/ShopBtns/BuyBtn
@onready var sell_btn: BaseButton = $Control/Panel/Root/MarginContainer/MainShopCont/ShopBtns/SellBtn
@onready var hire_btn: BaseButton = $Control/Panel/Root/MarginContainer/MainShopCont/ShopBtns/HireBtn

@onready var shop_grid: GridContainer = $Control/Panel/Root/MarginContainer/MainShopCont/Control/ScrollContainer/ShopGrid
@onready var item_name_label: Label = $Control/Panel/Root/MarginContainer/MainShopCont/ShopInfo/ItemLabel
@onready var item_desc_label: Label = $Control/Panel/Root/MarginContainer/MainShopCont/ShopInfo/ItemDesc
@onready var item_price_label: Label = $Control/Panel/Root/MarginContainer/MainShopCont/ShopInfo/ItemPrice
@onready var buy_total_label: Label = $Control/Panel/Root/MarginContainer/MainShopCont/purchasePrice
var player_inventory: InventoryModel = null
var inventory_overlay: InventoryOverlay = null

var selected_index: int = -1
var selected_shop_index: int = -1

var selected_item: ItemData = null

func _ready() -> void:
	slot_button_scene = load(SLOT_BUTTON_SCENE_PATH) as PackedScene

	if close_btn != null:
		close_btn.pressed.connect(_on_close_pressed)
	if buy_btn != null:
		buy_btn.pressed.connect(_on_buy_pressed)
	if sell_btn != null:
		sell_btn.pressed.connect(_on_sell_pressed)
	if hire_btn != null:
		hire_btn.pressed.connect(_on_hire_pressed)
	if buy_total_label != null:
		buy_total_label.text = "Total Cost: $0"
	_clear_selection_display()
	_create_shop_inventory()
	_fill_fixed_stock()
	_rebuild_shop_grid()
func _on_shop_slot_hovered(item: ItemData) -> void:
	if item == null:
		return

	if item_name_label != null:
		item_name_label.text = item.display_name
	if item_desc_label != null:
		item_desc_label.text = item.description
	if item_price_label != null:
		item_price_label.text = "Buy: $" + str(item.buy_price)
func setup_shop(player_inv: InventoryModel, inv_overlay: InventoryOverlay) -> void:
	player_inventory = player_inv
	inventory_overlay = inv_overlay
func _update_buy_total() -> void:
	if buy_total_label == null:
		return

	if selected_item == null:
		buy_total_label.text = "Total Cost: $0"
	else:
		buy_total_label.text = "Total Cost: $" + str(selected_item.buy_price)
func _create_shop_inventory() -> void:
	shop_inventory = InventoryModel.new()

func _fill_fixed_stock() -> void:
	var stock_items: Array[ItemData] = [
		load("res://Items/stock/stock_item1.tres") as ItemData,
		load("res://Items/stock/stock_item2.tres") as ItemData,
		load("res://Items/stock/stock_item3.tres") as ItemData,
		load("res://Items/stock/stock_item4.tres") as ItemData,
		load("res://Items/stock/stock_item5.tres") as ItemData,
		load("res://Items/stock/stock_item6.tres") as ItemData,
		load("res://Items/stock/stock_item7.tres") as ItemData,
		load("res://Items/stock/stock_item8.tres") as ItemData,
		load("res://Items/stock/stock_item9.tres") as ItemData,
		load("res://Items/stock/stock_item10.tres") as ItemData
	]

	for i in range(min(stock_items.size(), shop_inventory.slot_count)):
		var item := stock_items[i]
		if item == null:
			continue

		shop_inventory.set_slot(i, {
			"item": item,
			"qty": 1
		})

func _rebuild_shop_grid() -> void:
	if shop_grid == null:
		push_error("Shop: ShopGrid not found")
		return
	if slot_button_scene == null:
		push_error("Shop: slot_button_scene is null")
		return
	if shop_inventory == null:
		push_error("Shop: shop_inventory is null")
		return

	for c in shop_grid.get_children():
		c.queue_free()

	shop_grid.columns = columns

	for i in range(shop_inventory.slot_count):
		var slot := slot_button_scene.instantiate() as SlotButton
		if slot == null:
			push_error("Shop: failed to instance SlotBtn")
			return

		slot.index = i
		slot.inventory_model = shop_inventory
		slot.custom_minimum_size = slot_size
		slot.interaction_mode = SlotButton.InteractionMode.SELECT
		slot.is_selected = (i == selected_shop_index)

		if not slot.slot_selected.is_connected(_on_shop_slot_selected):
			slot.slot_selected.connect(_on_shop_slot_selected)
		if not slot.hovered_item.is_connected(_on_shop_slot_hovered):
			slot.hovered_item.connect(_on_shop_slot_hovered)
		if not slot.unhovered_item.is_connected(_on_shop_slot_unhovered):
			slot.unhovered_item.connect(_on_shop_slot_unhovered)

		shop_grid.add_child(slot)
		slot.refresh()

func _on_shop_slot_selected(index: int, source_inventory: InventoryModel) -> void:
	if source_inventory == null:
		return

	var slot = source_inventory.get_slot(index)
	if slot == null:
		return

	if selected_shop_index == index:
		_clear_selection_display()
		_rebuild_shop_grid()
		return

	selected_shop_index = index
	selected_index = index
	selected_item = slot["item"]

	_update_selection_display()
	_update_buy_total()
	_rebuild_shop_grid()
func _on_shop_slot_unhovered() -> void:
	if selected_item == null:
		_clear_selection_display()
	else:
		_update_selection_display()

func _update_selection_display() -> void:
	if selected_item == null:
		_clear_selection_display()
		return

	item_name_label.text = selected_item.display_name
	item_desc_label.text = selected_item.description
	item_price_label.text = "Buy: $" + str(selected_item.buy_price)

func _clear_selection_display() -> void:
	selected_shop_index = -1
	selected_index = -1
	selected_item = null

	if item_name_label != null:
		item_name_label.text = ""
	if item_desc_label != null:
		item_desc_label.text = ""
	if item_price_label != null:
		item_price_label.text = ""
	if buy_total_label != null:
		buy_total_label.text = "Total Cost: $0"
func _on_buy_pressed() -> void:
	if selected_item == null:
		return
	if player_inventory == null or shop_inventory == null:
		return

	var slot = shop_inventory.get_slot(selected_index)
	if slot == null:
		return

	var price: int = selected_item.buy_price
	if MoneySave.money < price:
		return

	var added: bool = player_inventory.add_item(selected_item, 1)
	if not added:
		return

	var removed: bool = shop_inventory.remove_from_slot(selected_index, 1)
	if not removed:
		# rollback if something went wrong
		player_inventory.remove_from_slot(
			player_inventory.get_first_empty_slot_in_category(selected_item.category),
			1
		)
		return

	MoneySave.money -= price

	if shop_inventory.get_slot(selected_index) == null:
		_clear_selection_display()
	else:
		_update_selection_display()

	_update_buy_total()
	_rebuild_shop_grid()
func _on_sell_pressed() -> void:
	print("Sell pressed")
	print("inventory_overlay = ", inventory_overlay)
	print("player_inventory = ", player_inventory)

	if inventory_overlay == null or player_inventory == null:
		push_error("Shop: inventory overlay or player inventory missing")
		return

	hide()
	inventory_overlay.set_inventory(player_inventory)
	inventory_overlay.show()
	inventory_overlay.enter_sell_mode(self)
	
func _on_hire_pressed() -> void:
	print("Hire pressed")

func receive_sold_item(item: ItemData, qty: int) -> void:
	if shop_inventory == null or item == null or qty <= 0:
		return

	shop_inventory.add_item(item, qty)
	_rebuild_shop_grid()
func _on_close_pressed() -> void:
	leave_shop()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		leave_shop()

func leave_shop() -> void:
	closed.emit()
	queue_free()
