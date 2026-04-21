extends TextureButton
class_name SlotButton

signal slot_selected(index: int, source_inventory: InventoryModel)
signal sell_toggled(index: int)
signal hovered_slot(index: int, source_inventory: InventoryModel)
signal unhovered_slot()
enum InteractionMode {
	DRAG,
	SELECT,
	SELL
}

@export var index: int = -1
@export var inventory_model: InventoryModel
@export var interaction_mode: InteractionMode = InteractionMode.DRAG

@export var normal_bg: Color = Color(1, 1, 1, 0.08)
@export var hover_bg: Color = Color(0.668, 0.993, 0.92, 0.161)
@export var select_bg: Color = Color(0.95, 0.55, 0.85, 0.35)
@export var marked_bg: Color = Color(0.0, 0.408, 0.976, 0.278)
@export var show_mouse_tooltip: bool = true


var is_selected: bool = false
var marked_for_sale: bool = false
var is_hovered: bool = false
var filter_enabled: bool = true
@onready var bg: ColorRect = $Content/BG
@onready var content: Control = $Content
@onready var icon_control: Control = $Content/IconControl
@onready var icon_rect: TextureRect = $Content/IconControl/icon
@onready var name_bar: ColorRect = $Content/Description
@onready var item_name_label: Label = $Content/Description/ItemName
#@onready var qty_label: Label = $Content/QtyLabel

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	if not resized.is_connected(_on_resized):
		resized.connect(_on_resized)

	if icon_control != null and not icon_control.resized.is_connected(_on_icon_control_resized):
		icon_control.resized.connect(_on_icon_control_resized)

	call_deferred("_refresh_visuals_deferred")


func refresh() -> void:
	if inventory_model == null:
		_clear_display()
		return

	var slot: Variant = inventory_model.get_slot(index)
	set_slot_data(slot)
	_apply_visual_state()
	call_deferred("_apply_icon_transform")


func set_slot_data(slot: Variant) -> void:
	if slot == null:
		_clear_display()
		return

	var item = slot.get("item", null)
	var qty: int = int(slot.get("qty", 0))

	var item_data: ItemData = null
	var instance: PartInstance = null
	
	if item is PartInstance:
		instance = item
		item_data = instance.item_data
	elif item is ItemData:
		item_data = item
	else:
		_clear_display()
		return

	if item_data == null:
		_clear_display()
		return

	if icon_rect != null:
		icon_rect.texture = item_data.icon
		icon_rect.visible = item_data.icon != null
		call_deferred("_apply_icon_transform")

	if name_bar != null:
		name_bar.visible = true

	if item_name_label != null:
		item_name_label.visible=true
		item_name_label.remove_theme_color_override("font_color")

		if instance != null:
			item_name_label.text = "[%s]" % instance.get_rarity_name()

			var rarity_colors := {
				PartInstance.Rarity.COMMON: Color.WHITE,
				PartInstance.Rarity.UNCOMMON: Color(0.4, 1.0, 0.4),
				PartInstance.Rarity.RARE: Color(0.4, 0.6, 1.0),
				PartInstance.Rarity.EPIC: Color(0.8, 0.4, 1.0),
				PartInstance.Rarity.LEGENDARY: Color(1.0, 0.7, 0.2)
			}

			item_name_label.add_theme_color_override(
				"font_color",
				rarity_colors.get(instance.rarity, Color.WHITE)
			)
		else:
			match interaction_mode:
				InteractionMode.SELL:
					item_name_label.text = "%d coins" % int(item_data.sell_price * max(qty, 1))
				InteractionMode.SELECT:
					item_name_label.text = "%d coins" % int(item_data.buy_price)
				_:
					item_name_label.text = item_data.display_name

	var category_name := _get_category_name(item)
	var subfilter_name := _get_subfilter_name(item)

	if show_mouse_tooltip:
		if instance != null:
			tooltip_text = "%s\nType: %s - %s\n%s" % [
				item_data.display_name,
				category_name,
				subfilter_name,
				instance.get_stat_text()
			]
		else:
			tooltip_text = "%s\nType: %s - %s\n%s" % [
				item_data.display_name,
				category_name,
				subfilter_name,
				item_data.description
			]
	else:
		tooltip_text = ""


func _clear_display() -> void:
	if icon_rect != null:
		icon_rect.texture = null
		icon_rect.visible = false

	if name_bar != null:
		name_bar.visible = false

	if item_name_label != null:
		item_name_label.text = ""
		item_name_label.remove_theme_color_override("font_color")
		item_name_label.visible=false

#	if qty_label != null:
#		qty_label.text = ""
#		qty_label.visible = false

	tooltip_text = ""
	call_deferred("_apply_icon_transform")


func _apply_visual_state() -> void:
	if bg == null:
		return

	if is_selected and is_hovered:
		bg.color = Color(1.0, 0.4, 0.8, 0.45)
	elif is_selected:
		bg.color = select_bg
	elif marked_for_sale:
		bg.color = marked_bg
	elif is_hovered:
		bg.color = hover_bg
	else:
		bg.color = normal_bg

	call_deferred("_apply_icon_transform")


func _apply_icon_transform() -> void:
	if icon_control == null or icon_rect == null:
		return

	if not icon_rect.visible or icon_rect.texture == null:
		return

	var holder_size: Vector2 = icon_control.size
	if holder_size.x <= 0.0 or holder_size.y <= 0.0:
		call_deferred("_apply_icon_transform")
		return

	var tex: Texture2D = icon_rect.texture
	var tex_size: Vector2 = tex.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return

	var shrink_ratio: float = 1.0
	if is_selected or marked_for_sale:
		shrink_ratio = 0.82

	var max_box: Vector2 = holder_size * shrink_ratio
	var fit_scale: float = min(max_box.x / tex_size.x, max_box.y / tex_size.y)
	var target_size: Vector2 = (tex_size * fit_scale).round()

	icon_rect.size = target_size
	icon_rect.position = ((holder_size - target_size) * 0.5).round()


func _on_pressed() -> void:
	if inventory_model == null:
		return

	var slot: Variant = inventory_model.get_slot(index)
	if slot == null:
		return

	match interaction_mode:
		InteractionMode.SELECT, InteractionMode.DRAG:
			emit_signal("slot_selected", index, inventory_model)

		InteractionMode.SELL:
			emit_signal("sell_toggled", index)

func _on_mouse_entered() -> void:
	is_hovered = true
	_apply_visual_state()
	emit_signal("hovered_slot", index, inventory_model)

func _on_mouse_exited() -> void:
	is_hovered = false
	_apply_visual_state()
	emit_signal("unhovered_slot")

func set_filter_enabled(enabled: bool) -> void:
	filter_enabled = enabled
	modulate = Color(1, 1, 1, 1) if enabled else Color(1, 1, 1, 0.2)
	mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
func _on_resized() -> void:
	call_deferred("_apply_icon_transform")


func _on_icon_control_resized() -> void:
	call_deferred("_apply_icon_transform")


func _refresh_visuals_deferred() -> void:
	_apply_visual_state()
	call_deferred("_apply_icon_transform")
func _get_category_name(item) -> String:
	var category := ItemData.InventoryCategory.ITEM

	if item is PartInstance:
		category = item.category
	elif item is ItemData:
		category = item.category

	match category:
		ItemData.InventoryCategory.ITEM:
			return "Item"
		ItemData.InventoryCategory.PART:
			return "Part"
		ItemData.InventoryCategory.MEMBER:
			return "Member"

	return "Unknown"


func _get_subfilter_name(item) -> String:
	var category := _get_item_category(item)

	match category:
		ItemData.InventoryCategory.ITEM:
			match _get_item_subfilter(item):
				ItemData.ItemSubfilter.IRON: return "Iron"
				ItemData.ItemSubfilter.COPPER: return "Copper"
				ItemData.ItemSubfilter.CARBON_FIBER: return "Carbon Fiber"
				ItemData.ItemSubfilter.STEEL: return "Steel"
				ItemData.ItemSubfilter.SILICONE: return "Silicone"
				ItemData.ItemSubfilter.WATER: return "Water"

		ItemData.InventoryCategory.PART:
			match _get_part_subfilter(item):
				ItemData.PartSubfilter.ENGINE: return "Engine"
				ItemData.PartSubfilter.WING: return "Wing"
				ItemData.PartSubfilter.FUEL_TANK: return "Fuel Tank"
				ItemData.PartSubfilter.NOSE_CONE: return "Nose Cone"
				ItemData.PartSubfilter.BODY_PANELS: return "Body Panels"
				ItemData.PartSubfilter.ELECTRICAL_COMPONENTS: return "Electrical Components"
				ItemData.PartSubfilter.ENGINE_HOUSING: return "Engine Housing"

		ItemData.InventoryCategory.MEMBER:
			match _get_member_subfilter(item):
				ItemData.MemberSubfilter.ECONOMY: return "Economy"
				ItemData.MemberSubfilter.BUFF: return "Buff"
				ItemData.MemberSubfilter.SUPPORT: return "Support"
				ItemData.MemberSubfilter.LUCK: return "Luck"

	return "None"


func _get_item_category(item) -> int:
	if item is PartInstance:
		return item.category
	if item is ItemData:
		return item.category
	return ItemData.InventoryCategory.ITEM


func _get_item_subfilter(item) -> int:
	if item is PartInstance:
		return item.item_subfilter
	if item is ItemData:
		return item.item_subfilter
	return ItemData.ItemSubfilter.NONE


func _get_part_subfilter(item) -> int:
	if item is PartInstance:
		return item.part_subfilter
	if item is ItemData:
		return item.part_subfilter
	return ItemData.PartSubfilter.NONE


func _get_member_subfilter(item) -> int:
	if item is PartInstance:
		return item.member_subfilter
	if item is ItemData:
		return item.member_subfilter
	return ItemData.MemberSubfilter.NONE
