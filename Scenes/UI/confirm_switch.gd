extends Control
signal choice(play: bool)

@onready var play_btn: Button = $Center/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Play
@onready var skip_btn: Button = $Center/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Skip
@onready var blur: ColorRect = $BG
@onready var panel_mover: Control = $Center/Control

var panel_final_position: Vector2
var panel_start_position: Vector2
var is_closing: bool = false

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	if not play_btn.pressed.is_connected(_on_play_pressed):
		play_btn.pressed.connect(_on_play_pressed)
	if not skip_btn.pressed.is_connected(_on_skip_pressed):
		skip_btn.pressed.connect(_on_skip_pressed)

	blur.modulate.a = 0.0

	await get_tree().process_frame

	panel_final_position = panel_mover.position

	var panel_height: float = panel_mover.size.y
	if panel_height <= 0.0:
		panel_height = 300.0

	panel_start_position = Vector2(panel_final_position.x, -panel_height - 40.0)
	panel_mover.position = panel_start_position

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(blur, "modulate:a", 1.0, 0.2)
	tween.tween_property(panel_mover, "position", panel_final_position, 0.28) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

func close_overlay(play_value: bool) -> void:
	if is_closing:
		return
	is_closing = true

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(blur, "modulate:a", 0.0, 0.18)
	tween.tween_property(panel_mover, "position", panel_start_position, 0.22) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN)

	await tween.finished
	choice.emit(play_value)
	queue_free()

func _on_play_pressed() -> void:
	await close_overlay(true)

func _on_skip_pressed() -> void:
	await close_overlay(false)
