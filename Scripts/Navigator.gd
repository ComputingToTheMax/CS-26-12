extends Node
class_name SceneNavigator

var previous_scene_path: String = ""

func go_to(scene_path: String) -> void:
	previous_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)

func go_back() -> void:
	if previous_scene_path == "":
		push_warning("SceneNavigator: No previous scene to go back to.")
		return
	get_tree().change_scene_to_file(previous_scene_path)
