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
	var bg = get_tree().current_scene.get_node("Background")
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
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if _is_mouse_over() and not clicked:
			clicked = true
			
			if is_success_object:
				var confirm = get_node_or_null("ConfirmSound")
				if confirm:
					confirm.play()
				await get_tree().create_timer(1.0).timeout
				
				# ✅ ONLY SUCCESS CHANGES SCENE
				if next_scene_path != "":
					get_tree().change_scene_to_file(next_scene_path)
			
			else:
				var fail = get_tree().current_scene.get_node_or_null("FailClick")
				if fail:
					fail.play()
				await get_tree().create_timer(0.6).timeout
				
				# ❌ DO NOTHING AFTER FAIL
				clicked = false

func _is_mouse_over() -> bool:
	if texture == null:
		return false
	var mouse_pos = get_global_mouse_position()
	var size = texture.get_size() * scale
	var rect = Rect2(global_position - size * 0.5, size)
	return rect.has_point(mouse_pos)