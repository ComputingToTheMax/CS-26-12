extends Control
class_name InventoryOverlay
@export var slot_button_scene: PackedScene = preload("res://Scenes/UI/SlotBtn.tscn")
@export var slot_count: int = 12
@export var columns: int = 6
@export var slot_size: Vector2 = Vector2(80, 110) # width height
@onready var close_btn := $Screen/MarginContainer/VBoxContainer/TopBar/HBoxContainer/Closebtn as BaseButton 
@onready var grid := $Screen/InvPanel/CenterContainer/MarginContainer/GridContainer as GridContainer
@onready var money_label : Label = %MoneyLabel
@onready var progress: ProgressBar = %progress

func _ready() -> void:


	if money_label == null:
		push_error("InventoryOverlay: MoneyLabel path is wrong or node is missing.")
		return
	grid.columns = columns
	
	_build_grid()
	close_btn.pressed.connect(_on_close_pressed)
	_update_money(MoneySave.money)
	MoneySave.money_changed.connect(_update_money)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var hovered := get_viewport().gui_get_hovered_control()

func _update_money(amount: int) -> void:
	money_label.text ="Money: " + str(amount)
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("CLICK CAUGHT BY:", name)	
func _build_grid() -> void:

	if slot_button_scene == null:
		push_error("slot_button_scene is null. Assign SlotBtn.tscn in Inspector or preload it.")
		return
	for c in grid.get_children():
		c.queue_free()

	for i in range(slot_count):
		var slot := slot_button_scene.instantiate() as SlotButton
		slot.index=i
		if slot == null:
			push_error("SlotBtn.tscn failed to instance (returned null).")
			return

		slot.custom_minimum_size = slot_size
		grid.add_child(slot)
func _on_close_pressed() -> void:
	ui.hide_inventory()
