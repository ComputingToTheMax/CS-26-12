extends Control
signal choice(play: bool)

@onready var play_btn: Button = $Center/Panel/MarginContainer/VBoxContainer/HBoxContainer/Play
@onready var skip_btn: Button = $Center/Panel/MarginContainer/VBoxContainer/HBoxContainer/Skip
@onready var bg: ColorRect=$BG
func _ready() -> void:

	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_offsets_preset(Control.PRESET_FULL_RECT)

	mouse_filter = Control.MOUSE_FILTER_STOP

	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE



	if play_btn == null or skip_btn == null:
		push_error("ConfirmSwitch: Button paths are wrong")
		return

	play_btn.pressed.connect(_on_play_pressed)
	skip_btn.pressed.connect(_on_skip_pressed)

func _on_play_pressed() -> void:
	choice.emit(true)
	queue_free()

func _on_skip_pressed() -> void:
	choice.emit(false)
	queue_free()
