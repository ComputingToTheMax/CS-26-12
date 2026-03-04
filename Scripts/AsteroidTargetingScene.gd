extends Node2D
#class_name AT1
signal done(result: Dictionary)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		var clicked_on_object := false
		
		for child in get_children():
			if child is Sprite2D and child.has_method("_is_mouse_over"):
				if child._is_mouse_over():
					clicked_on_object = true
					break
		
		if not clicked_on_object:
			var fail = get_node_or_null("FailClick")
			if fail:
				fail.play()
