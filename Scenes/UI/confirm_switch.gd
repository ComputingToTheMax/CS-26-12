extends Control
signal choice(play: bool)

@onready var play_btn: Button = $Center/Panel/MarginContainer/VBoxContainer/HBoxContainer/Play
@onready var skip_btn: Button = $Center/Panel/MarginContainer/VBoxContainer/HBoxContainer/Skip
@onready var bg: ColorRect=$BG
func _ready() -> void:
# Make sure the popup is full-screen so the center container can center properly
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_offsets_preset(Control.PRESET_FULL_RECT)

	# Block clicks from going to the board behind
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Make sure the background does NOT sit on top of buttons in input terms
	# (if Bg is behind everything in the tree, this isn't strictly necessary)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Debug: if these print <null>, your button node names differ
	print("play_btn:", play_btn, " skip_btn:", skip_btn)

	if play_btn == null or skip_btn == null:
		push_error("ConfirmSwitch: Button paths are wrong. Check node names (PlayButton/SkipButton).")
		return

	play_btn.pressed.connect(_on_play_pressed)
	skip_btn.pressed.connect(_on_skip_pressed)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("ConfirmSwitch saw mouse click at:", event.position)

func _on_play_pressed() -> void:
	print("Play pressed")
	choice.emit(true)
	queue_free()

func _on_skip_pressed() -> void:
	print("Skip pressed")
	choice.emit(false)
	queue_free()
