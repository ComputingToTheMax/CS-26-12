extends Control


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
