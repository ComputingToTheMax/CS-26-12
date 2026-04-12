extends Node2D
signal done(result: Dictionary)

@export var show_instruction_popup := false

const INSTRUCTION_TEXT := "Click on the moving asteroid to advance"
const INSTRUCTION_DURATION := 3.0

func _ready():
	if show_instruction_popup:
		_show_instruction_popup()

func _show_instruction_popup():
	var canvas := CanvasLayer.new()
	canvas.name = "InstructionPopup"
	add_child(canvas)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.5
	panel.anchor_top = 0.0
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.0
	panel.offset_left = -220
	panel.offset_top = 20
	panel.offset_right = 220
	panel.offset_bottom = 80
	canvas.add_child(panel)

	var label := Label.new()
	label.text = INSTRUCTION_TEXT
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(400, 44)
	panel.add_child(label)

	await get_tree().create_timer(INSTRUCTION_DURATION).timeout
	if is_instance_valid(canvas):
		canvas.queue_free()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_on_object := false
		
		for child in get_children():
			if child is Sprite2D and child.has_method("_is_mouse_over"):
				if child._is_mouse_over():
					clicked_on_object = true
					break
		
		if not clicked_on_object:
			var fail = get_node_or_null("FailClick")
			if fail:
				fail.play()
