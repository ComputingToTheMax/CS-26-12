extends Node
class_name SceneNavigator

var stack: Array[String] = []
@export var fallback_scene: String = "res://Scenes/main_board.tscn"

func go_to(scene_path: String) -> void:

	var current := get_tree().current_scene
	if current != null and current.scene_file_path != "":
		stack.push_back(current.scene_file_path)
	get_tree().change_scene_to_file(scene_path)
	var err := get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("SceneNavigator.go_to failed: %s (err=%d)" % [scene_path, err])
func go_back() -> void:
	if not stack.is_empty():
		get_tree().change_scene_to_file(stack.pop_back())
	else:
		# If user ran Inventory directly, or stack got cleared
		get_tree().change_scene_to_file(fallback_scene)
