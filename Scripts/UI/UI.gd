extends CanvasLayer
class_name UI

@export var inventory_overlay_scene: PackedScene = preload("res://Scenes/UI/Inventory.tscn")

var inventory: InventoryOverlay = null

func _ready() -> void:
	layer = 100

func show_inventory() -> void:
	if inventory == null:
		if inventory_overlay_scene == null:
			push_error("UI: inventory_overlay_scene not assigned.")
			return
		inventory = inventory_overlay_scene.instantiate() as InventoryOverlay
		add_child(inventory)

	inventory.show_overlay()

func hide_inventory() -> void:
	if inventory != null:
		inventory.hide_overlay()

func toggle_inventory() -> void:
	if inventory != null and inventory.visible:
		hide_inventory()
	else:
		show_inventory()
