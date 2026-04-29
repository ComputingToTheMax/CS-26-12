extends Control
signal choice(play: bool)

@onready var play_btn: Button = $Center/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Play
@onready var skip_btn: Button = $Center/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Skip
@onready var blur: ColorRect = $BG
@onready var panel_mover: Control = $Center/Control
@onready var title_label: Label = $Center/Control/Panel/MarginContainer/VBoxContainer/Title

const MINIGAME_NAMES: Dictionary = {
	"AsteroidTargeting1": "Asteroid Targeting",
	"alien_communication": "Alien Communication",
}

@onready var center: CenterContainer = get_node_or_null("Center") as CenterContainer

var panel_final_position: Vector2 = Vector2.ZERO
var panel_start_position: Vector2 = Vector2.ZERO
var is_closing: bool = false
var minigame_key: String = ""

func setup(name_key: String) -> void:
	minigame_key = name_key
	var display_name: String = MINIGAME_NAMES.get(name_key, name_key)
	title_label.text = "Do you want to play %s?" % display_name

func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size

	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	if center != null:
		center.set_anchors_preset(Control.PRESET_FULL_RECT)
		center.set_offsets_preset(Control.PRESET_FULL_RECT)
		center.position = Vector2.ZERO
		center.size = viewport_size

	if panel_mover == null:
		panel_mover = center

	setup_prompt(title_text, play_text, skip_text)

	if play_btn != null and not play_btn.pressed.is_connected(_on_play_pressed):
		play_btn.pressed.connect(_on_play_pressed)
	if not skip_btn.pressed.is_connected(_on_skip_pressed):
		skip_btn.pressed.connect(_on_skip_pressed)

	if blur != null:
		blur.set_anchors_preset(Control.PRESET_FULL_RECT)
		blur.set_offsets_preset(Control.PRESET_FULL_RECT)
		blur.modulate.a = 0.0

	await get_tree().process_frame
	await get_tree().process_frame

	position = Vector2.ZERO
	global_position = Vector2.ZERO
	size = get_viewport_rect().size

	if center != null:
		center.position = Vector2.ZERO
		center.size = get_viewport_rect().size

	panel_final_position = panel_mover.position if panel_mover != null else Vector2.ZERO

	var panel_height: float = 300.0
	var panel := get_node_or_null("Center/Control/Panel") as Control

	if panel != null and panel.size.y > 0.0:
		panel_height = panel.size.y
	elif panel_mover != null and panel_mover.size.y > 0.0:
		panel_height = panel_mover.size.y

	panel_start_position = Vector2(panel_final_position.x, -panel_height - 40.0)

	if panel_mover != null:
		panel_mover.position = panel_start_position

	var tween := create_tween()
	tween.set_parallel(true)

	if blur != null:
		tween.tween_property(blur, "modulate:a", 1.0, 0.2)

	if panel_mover != null:
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
