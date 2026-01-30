extends Sprite2D

@export var moveSpeed: float = 200.0

@onready var controlRoot: Control = get_parent().get_node("Control")
@onready var confirmPlayer: AudioStreamPlayer = $ConfirmTargetPlayer

var direction: Vector2

func _ready():
	randomize()
	_set_random_direction()
	set_process(true)

func _process(delta):
	position += direction * moveSpeed * delta
	_keep_inside_control()

func _set_random_direction():
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _keep_inside_control():
	var rect := controlRoot.get_global_rect()
	var texSize := texture.get_size() * scale

	var left = rect.position.x + texSize.x * 0.5
	var right = rect.position.x + rect.size.x - texSize.x * 0.5
	var top = rect.position.y + texSize.y * 0.5
	var bottom = rect.position.y + rect.size.y - texSize.y * 0.5

	if position.x < left or position.x > right:
		direction.x *= -1

	if position.y < top or position.y > bottom:
		direction.y *= -1

	position.x = clamp(position.x, left, right)
	position.y = clamp(position.y, top, bottom)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_mouse_over():
			confirmPlayer.play()

func _is_mouse_over() -> bool:
	var mousePos = get_global_mouse_position()
	var size = texture.get_size() * scale
	var rect = Rect2(position - size * 0.5, size)
	return rect.has_point(mousePos)
