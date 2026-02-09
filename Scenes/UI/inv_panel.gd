extends Control

@export var slot_button_scene: PackedScene
@export var slot_count: int = 12
@export var columns: int = 6
@export var slot_size: Vector2 = Vector2(80, 110) # width height

@onready var grid: GridContainer = $Screen/InvPanel/CenterContainer/MarginContainer/GridContainer
@onready var back_btn:= %Closebtn as BaseButton
func _ready() -> void:
	print("InvOverlay script running at:", get_path())

	print("I am:", get_path())
	print("Children:", get_children())
	print("BackBtn via unique:", get_node_or_null("%BackBtn"))
	print("TopBar exists:", get_node_or_null("TopBar"))
	back_btn.pressed.connect(func(): Navigator.go_back())

	if slot_button_scene == null:
		push_error("InvPanel: slot_button_scene is NULL. Assign SlotButton.tscn on THIS InvPanel node.")
		return

	grid.columns = columns
	_build_grid()

func _build_grid() -> void:
	for c in grid.get_children():
		c.queue_free()

	for i in range(slot_count):
		var slot_node: Node = slot_button_scene.instantiate()
		if slot_node == null:
			push_error("SlotBtn.tscn failed to instance (returned null).")
			return

		var slot := slot_button_scene.instantiate() as Control
		slot.custom_minimum_size = slot_size
		grid.add_child(slot)
	
