extends Control
class_name InventoryOverlay
@export var slot_button_scene: PackedScene = preload("res://Scenes/UI/SlotBtn.tscn")
@export var slot_count: int = 12
@export var columns: int = 6
@export var slot_size: Vector2 = Vector2(80, 110) # width height
@onready var close_btn := $Screen/MarginContainer/VBoxContainer/TopBar/Closebtn as BaseButton 
@onready var grid := $Screen/InvPanel/CenterContainer/MarginContainer/GridContainer as GridContainer
@onready var progress: ProgressBar = %progress

func _ready() -> void:

	if grid == null:
		push_error("InventoryOverlay: GridContainer path is wrong.")
		return
	if close_btn == null:
		push_error("InventoryOverlay: Closebtn path is wrong.")
		return
	grid.columns = columns
	
	_build_grid()
	close_btn.pressed.connect(_on_close_pressed)


	
func _build_grid() -> void:
	for c in grid.get_children():
		c.queue_free()

	for i in range(slot_count):
		var slot := slot_button_scene.instantiate() as TextureButton
		if slot == null:
			push_error("SlotBtn.tscn failed to instance (returned null).")
			return

		slot.custom_minimum_size = slot_size
		grid.add_child(slot)
func _on_close_pressed() -> void:
	ui.hide_inventory()
