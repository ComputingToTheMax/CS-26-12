extends Node2D
signal done(result: Dictionary)

@export var show_instruction_popup := false

const INSTRUCTION_TEXT := "Click on the moving asteroid to advance"
const INSTRUCTION_DURATION := 3.0

func _ready() -> void:
	if show_instruction_popup:
		_show_instruction_popup()

func _show_instruction_popup() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "InstructionPopup"
	canvas.layer = 220
	add_child(canvas)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	canvas.add_child(margin)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 84)
	margin.add_child(panel)

	var label := Label.new()
	label.text = INSTRUCTION_TEXT
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(420, 48)
	label.add_theme_font_size_override("font_size", 22)
	panel.add_child(label)

	await get_tree().create_timer(INSTRUCTION_DURATION).timeout
	if is_instance_valid(canvas):
		canvas.queue_free()

func _input(event: InputEvent) -> void:
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