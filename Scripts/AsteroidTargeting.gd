extends Sprite2D

@export var move_speed: float = 200.0

@onready var confirm_player: AudioStreamPlayer = $ConfirmTargetPlayer
@onready var background: Sprite2D = get_parent().get_node("BlackSkyBackground")

var direction: Vector2

func _ready():
	randomize()
	_set_random_direction()

func _process(delta):
	position += direction * move_speed * delta
	_keep_inside_background()

func _set_random_direction():
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _keep_inside_background():
	if background == null or texture == null:
		return
	
	var bg_pos = background.global_position
	var bg_size = background.texture.get_size() * background.scale
	var asteroid_size = texture.get_size() * scale
	
	var left = bg_pos.x - bg_size.x * 0.5 + asteroid_size.x * 0.5
	var right = bg_pos.x + bg_size.x * 0.5 - asteroid_size.x * 0.5
	var top = bg_pos.y - bg_size.y * 0.5 + asteroid_size.y * 0.5
	var bottom = bg_pos.y + bg_size.y * 0.5 - asteroid_size.y * 0.5
	
	# Bounce off edges
	if position.x <= left or position.x >= right:
		direction.x *= -1
	if position.y <= top or position.y >= bottom:
		direction.y *= -1
	
	# Clamp position to remain inside background
	position.x = clamp(position.x, left, right)
	position.y = clamp(position.y, top, bottom)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_mouse_over():
			confirm_player.play()

func _is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var size = texture.get_size() * scale
	var rect = Rect2(position - size * 0.5, size)
	return rect.has_point(mouse_pos)
