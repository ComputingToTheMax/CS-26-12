extends Sprite2D

@export var move_speed: float = 200.0
@export var next_scene_path: String = ""
@export var is_success_object: bool = false

var direction: Vector2
var clicked := false

func _ready():
	randomize()
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _process(delta):
	position += direction * move_speed * delta
	_keep_inside_background()

func _keep_inside_background():
	var bg = get_parent().get_node_or_null("Background")
	if bg == null or texture == null:
		return
	
	var bg_pos = bg.global_position
	var bg_size = bg.texture.get_size() * bg.scale
	var size = texture.get_size() * scale
	
	var left = bg_pos.x - bg_size.x * 0.5 + size.x * 0.5
	var right = bg_pos.x + bg_size.x * 0.5 - size.x * 0.5
	var top = bg_pos.y - bg_size.y * 0.5 + size.y * 0.5
	var bottom = bg_pos.y + bg_size.y * 0.5 - size.y * 0.5
	
	if position.x <= left or position.x >= right:
		direction.x *= -1
	if position.y <= top or position.y >= bottom:
		direction.y *= -1
	
	position.x = clamp(position.x, left, right)
	position.y = clamp(position.y, top, bottom)

func _input(event):
	if clicked:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not _is_mouse_over():
			return
		
		clicked = true
		
		var confirm = get_node_or_null("ConfirmSound")
		if confirm:
			confirm.play()
		
		if is_success_object and next_scene_path != "":
			await get_tree().create_timer(0.3).timeout
			_go_to_next_scene()

func _go_to_next_scene() -> void:
	var packed: PackedScene = load(next_scene_path)
	if packed == null:
		push_error("Could not load next scene: " + next_scene_path)
		return
	
	var current_minigame = get_parent()
	var container = current_minigame.get_parent()
	if current_minigame == null or container == null:
		push_error("Could not find minigame parent/container")
		return
	
	var next_minigame = packed.instantiate()
	container.add_child(next_minigame)
	
	if current_minigame.has_signal("done") and next_minigame.has_signal("done"):
		next_minigame.done.connect(func(result):
			current_minigame.emit_signal("done", result)
		)
	
	current_minigame.hide()
	current_minigame.set_process(false)
	current_minigame.set_physics_process(false)
	current_minigame.set_process_input(false)
	current_minigame.set_process_unhandled_input(false)

func _is_mouse_over() -> bool:
	if texture == null:
		return false
	
	var mouse_pos = get_global_mouse_position()
	var size = texture.get_size() * scale
	var rect = Rect2(global_position - size / 2, size)
	return rect.has_point(mouse_pos)
