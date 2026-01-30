extends Sprite2D

@onready var confirmPlayer: AudioStreamPlayer = $ConfirmTargetPlayer

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_mouse_over():
			confirmPlayer.play()

func _is_mouse_over() -> bool:
	if texture == null:
		return false

	var mousePos := get_global_mouse_position()
	var size := texture.get_size() * scale
	var rect := Rect2(position - size * 0.5, size)
	return rect.has_point(mousePos)
