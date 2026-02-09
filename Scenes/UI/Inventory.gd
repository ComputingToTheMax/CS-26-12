extends Control
class_name InventoryOverlay

@onready var close_btn: BaseButton = $Screen/CloseBtn

signal closed

func _ready() -> void:
	visible = false
	close_btn.pressed.connect(hide_overlay)

func show_overlay() -> void:
	visible = true
	grab_focus()

func hide_overlay() -> void:
	visible = false
	emit_signal("closed")

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		hide_overlay()
		get_viewport().set_input_as_handled()
