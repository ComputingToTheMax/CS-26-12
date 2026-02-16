extends TextureButton
class_name SlotButton

signal slot_clicked(index: int, button: int)

var index: int = -1

@onready var icon_rect: TextureRect = $icon
@onready var qty_label: Label = $quantity
@onready var bg: ColorRect = $BG

@export var normal_bg: Color = Color(1, 1, 1, 1)
@export var hover_bg: Color = Color(0.761, 0.132, 0.492, 1.0)

func _ready() -> void:

	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	bg.color = normal_bg
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	bg.color = hover_bg

func _on_mouse_exited() -> void:
	bg.color = normal_bg

func set_slot_data(slot: Variant) -> void:
	if slot == null:
		icon_rect.texture = null
		qty_label.text = ""
		return

	var item: ItemData = slot["item"]
	var qty: int = int(slot["qty"])

	icon_rect.texture = item.icon
	qty_label.text = str(qty) if qty > 1 else ""
