extends TextureButton
class_name TextureButtonEffects

@export var normal_color: Color = Color.WHITE
@export var hover_color: Color = Color(0.9, 0.9, 0.9, 1.0)
@export var pressed_color: Color = Color(0.65, 0.65, 0.65, 1.0)
@export var disabled_color: Color = Color(0.45, 0.45, 0.45, 0.6)

@export var hover_scale_amount: float = 1.04
@export var pressed_scale_amount: float = 0.96

var base_scale: Vector2
var hovering: bool = false


func _ready() -> void:
	base_scale = scale
	pivot_offset = size / 2.0

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	resized.connect(_on_resized)

	_update_visual()


func _on_resized() -> void:
	pivot_offset = size / 2.0


func _on_mouse_entered() -> void:
	hovering = true
	_update_visual()


func _on_mouse_exited() -> void:
	hovering = false
	_update_visual()


func _on_button_down() -> void:
	if disabled:
		return

	self_modulate = pressed_color
	scale = base_scale * pressed_scale_amount


func _on_button_up() -> void:
	_update_visual()


func set_enabled(value: bool) -> void:
	disabled = not value
	_update_visual()


func _update_visual() -> void:
	if disabled:
		self_modulate = disabled_color
		scale = base_scale
		return

	if hovering:
		self_modulate = hover_color
		scale = base_scale * hover_scale_amount
	else:
		self_modulate = normal_color
		scale = base_scale
