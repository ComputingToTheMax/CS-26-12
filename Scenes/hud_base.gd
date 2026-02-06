extends Control

@onready var inv_btn: BaseButton = $InvBtn

@onready var inv_overlay: Control = $InvOverlay
@onready var screen: Control = $InvOverlay/Screen

@onready var close_btn: BaseButton = $InvOverlay/Screen/TopBar/Closebtn

# Optional: click dim background to close (if you connect gui_input)
@onready var dim: ColorRect = $InvOverlay/Screen/ColorRect

# Example “big button”
@onready var crew_btn: BaseButton = $InvOverlay/Screen/InvPanel/CrewCont/Crew

var overlay_open := false
var tween: Tween

func _ready() -> void:
	# Start closed
	inv_overlay.visible = false
	close_btn.visible = false
	inv_btn.visible = true
	var inv_panel := $InvOverlay/Screen/InvPanel
	print("InvPanel node:", inv_panel)
	print("InvPanel script:", inv_panel.get_script())	

	_place_screen_offscreen()

	# If you prefer code connections instead of editor:
	# inv_btn.pressed.connect(_on_inv_btn_pressed)
	# close_btn.pressed.connect(_on_closebtn_pressed)
	# crew_btn.pressed.connect(_on_crew_pressed)

func _unhandled_input(event: InputEvent) -> void:
	# Only close with Esc when inventory is open
	if overlay_open and event.is_action_pressed("ui_cancel"):
		close_inventory()

func _place_screen_offscreen() -> void:
	var h := get_viewport_rect().size.y
	screen.position = Vector2(0, -h)

func _on_inv_btn_pressed() -> void:
	open_inventory()

func _on_closebtn_pressed() -> void:
	close_inventory()

func open_inventory() -> void:
	if overlay_open:
		return
	overlay_open = true

	# Swap buttons (so Close appears where Inv was)
	inv_btn.visible = false
	close_btn.visible = true

	inv_overlay.visible = true

	if tween:
		tween.kill()
	tween = create_tween()

	var h := get_viewport_rect().size.y
	screen.position = Vector2(0, -h)
	tween.tween_property(screen, "position", Vector2(0, 0), 0.35)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

func close_inventory() -> void:
	if not overlay_open:
		return
	overlay_open = false

	if tween:
		tween.kill()
	tween = create_tween()

	var h := get_viewport_rect().size.y
	tween.tween_property(screen, "position", Vector2(0, -h), 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

	tween.tween_callback(func():
		inv_overlay.visible = false
		close_btn.visible = false
		inv_btn.visible = true
	)
