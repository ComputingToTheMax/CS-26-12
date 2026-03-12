extends TextureButton
class_name SlotButton

signal hovered_item(item: ItemData)
signal unhovered_item
signal slot_selected(index: int, inventory_model: InventoryModel)
signal sell_toggled(index: int)

enum InteractionMode {
	DRAG,
	SELECT,
	SELL
}

static var is_dragging: bool = false
var index: int = -1
var inventory_model: InventoryModel = null
var interaction_mode: InteractionMode = InteractionMode.DRAG
var marked_for_sale: bool = false
var is_selected: bool = false

@export var selected_bg: Color = Color(0.45, 0.7, 1.0, 1.0)
@onready var bg: ColorRect = $Content/BG
@onready var icon_rect: TextureRect = $Content/IconControl/icon
@onready var icon_control: Control=$Content/IconControl
@onready var qty_label: Label = $Content/quantity
@onready var name_bar: ColorRect = $Content/Description
@onready var item_name_label: Label = $Content/Description/ItemName
@export var normal_icon_scale: Vector2 = Vector2(1, 1)
@export var selected_icon_scale: Vector2 = Vector2(0.9, 0.9)
@export var normal_bg: Color = Color(1, 1, 1, 1)
@export var hover_bg: Color = Color(0.761, 0.132, 0.492, 1.0)
@export var sell_mark_bg: Color = Color(0.35, 0.8, 0.35, 1.0)

func _ready() -> void:
	add_to_group("inventory_slots")

	if bg != null:
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if icon_rect != null:
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if qty_label != null:
		qty_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if name_bar != null:
		name_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if item_name_label != null:
		item_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE


	if name_bar != null:
		name_bar.color = Color(0, 0, 0, 0.65)

	if bg != null:
		bg.z_index = 0
	if icon_rect != null:
		icon_rect.z_index = 1
	if name_bar != null:
		name_bar.z_index = 2
	if item_name_label != null:
		item_name_label.z_index = 3
	if qty_label != null:
		qty_label.z_index = 4

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
	await get_tree().process_frame


	if icon_control != null:
		icon_control.pivot_offset = icon_control.size / 2.0
func _on_mouse_entered() -> void:
	if not is_dragging and bg != null and not marked_for_sale:
		bg.color = hover_bg

	if inventory_model == null:
		return

	var slot: Variant = inventory_model.get_slot(index)
	if slot == null:
		return

	var item: ItemData = slot["item"]
	emit_signal("hovered_item", item)

func _on_mouse_exited() -> void:
	_apply_base_visual()
	emit_signal("unhovered_item")

func _on_pressed() -> void:
	print("Slot pressed, index=", index, " mode=", interaction_mode)

	if inventory_model == null:
		return

	var slot: Variant = inventory_model.get_slot(index)

	match interaction_mode:
		InteractionMode.SELECT:
			if slot == null:
				return
			emit_signal("slot_selected", index, inventory_model)

		InteractionMode.SELL:
			if slot == null:
				return
			emit_signal("sell_toggled", index)

		_:
			pass

func refresh() -> void:
	if inventory_model == null:
		_clear_display()
		return

	var slot: Variant = inventory_model.get_slot(index)
	set_slot_data(slot)
	_apply_base_visual()

func set_slot_data(slot: Variant) -> void:
	if slot == null:
		_clear_display()
		return

	var item: ItemData = slot["item"]
	var qty: int = int(slot["qty"])

	if icon_rect != null:
		icon_rect.texture = item.icon

	if qty_label != null:
		qty_label.text = str(qty) if qty > 1 else ""

	if name_bar != null:
		name_bar.visible = true

	if item_name_label != null:
		match interaction_mode:
			InteractionMode.SELL:
				item_name_label.text = "$" + str(item.sell_price * qty)
			InteractionMode.SELECT:
				item_name_label.text = "$" + str(item.buy_price)
			_:
				item_name_label.text = item.display_name

	tooltip_text = ""

func _clear_display() -> void:
	if icon_rect != null:
		icon_rect.texture = null
	if qty_label != null:
		qty_label.text = ""
	if item_name_label != null:
		item_name_label.text = ""
	if name_bar != null:
		name_bar.visible = false
	tooltip_text = ""

func _apply_base_visual() -> void:
	if bg == null:
		return

	var target_scale := normal_icon_scale

	if marked_for_sale:
		bg.color = sell_mark_bg
		target_scale = selected_icon_scale
	elif is_selected:
		bg.color = selected_bg
		target_scale = selected_icon_scale
	else:
		bg.color = normal_bg
		target_scale = normal_icon_scale

	if icon_control != null:
		var tween := create_tween()
		tween.tween_property(icon_control, "scale", target_scale, 0.08)

func _get_drag_data(at_position: Vector2) -> Variant:
	if interaction_mode != InteractionMode.DRAG:
		return null

	if inventory_model == null:
		return null

	var slot = inventory_model.get_slot(index)
	if slot == null:
		return null

	is_dragging = true
	emit_signal("unhovered_item")
	_reset_all_slot_backgrounds()

	var preview_root := Control.new()
	preview_root.custom_minimum_size = Vector2(56, 56)
	preview_root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var preview_bg := ColorRect.new()
	preview_bg.color = Color(0, 0, 0, 0.25)
	preview_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	preview_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_root.add_child(preview_bg)

	var preview_icon := TextureRect.new()
	preview_icon.texture = slot["item"].icon
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	preview_icon.offset_left = 4
	preview_icon.offset_top = 4
	preview_icon.offset_right = -4
	preview_icon.offset_bottom = -4
	preview_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_root.add_child(preview_icon)

	set_drag_preview(preview_root)

	return {
		"from_index": index,
		"from_inventory": inventory_model
	}



func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if interaction_mode != InteractionMode.DRAG:
		return false

	return typeof(data) == TYPE_DICTIONARY \
		and data.has("from_index") \
		and data.has("from_inventory") \
		and data["from_inventory"] == inventory_model

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if interaction_mode != InteractionMode.DRAG:
		return

	var from_index: int = int(data["from_index"])
	inventory_model.transfer_or_swap(from_index, index)
	is_dragging = false
	_reset_all_slot_backgrounds()

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		is_dragging = false
		_reset_all_slot_backgrounds()

func _reset_all_slot_backgrounds() -> void:
	var tree := get_tree()
	if tree == null:
		return

	for node in tree.get_nodes_in_group("inventory_slots"):
		if node is SlotButton:
			(node as SlotButton)._apply_base_visual()
