extends Node
class_name SceneNavigator

var scenes_in_memory: Dictionary[String, Node] = {}

var previous_scene_stack: Array[String] = []
@export var fallback_scene: String = "res://Scenes/main_menu.tscn"

func go_to_packed_scene(target_scene: PackedScene, push_onto_previous_scene_stack=true, retain_in_memory:bool=true):
	var target_scene_path = target_scene.resource_path
	
	go_to_scene_by_path(target_scene_path, push_onto_previous_scene_stack, retain_in_memory)

func go_to_scene_by_path(target_scene_path: String, push_onto_previous_scene_stack := true, retain_in_memory := true) -> void:
	var current_scene_root_node := get_tree().current_scene
	var current_scene_path := ""
	if current_scene_root_node != null:
		current_scene_path = current_scene_root_node.scene_file_path

	if current_scene_path == target_scene_path:
		push_warning("Navigator: already in scene %s" % target_scene_path)
		return

	if push_onto_previous_scene_stack and current_scene_path != "":
		previous_scene_stack.push_back(current_scene_path)

	var target_scene_node: Node = null
	var pulled_from_memory := false

	if scenes_in_memory.has(target_scene_path):
		target_scene_node = scenes_in_memory[target_scene_path]
		pulled_from_memory = true
		print_debug("Pulled from memory: %s" % target_scene_path)
	else:
		target_scene_node = load(target_scene_path).instantiate()
		print_debug("Loaded new: %s" % target_scene_path)

	
	if retain_in_memory or pulled_from_memory:
		if retain_in_memory and current_scene_root_node != null and current_scene_path != "":
			if scenes_in_memory.has(current_scene_path):
				push_warning("Scene already stored in memory: %s (state may be discarded)" % current_scene_path)
			else:
				scenes_in_memory[current_scene_path] = current_scene_root_node

		change_scene_to_node_and_preserve(target_scene_node)
		return

	
	var err := get_tree().change_scene_to_node(target_scene_node)
	if err != OK:
		push_error("Navigator.go_to failed: %s (err=%d)" % [target_scene_path, err])




func change_scene_to_node_and_preserve(target_node: Node):
	var current_scene_root_node := get_tree().current_scene
	
	get_tree().root.add_child(target_node)
	get_tree().current_scene = target_node
	target_node.process_mode = Node.PROCESS_MODE_INHERIT
	target_node.show()
	
	current_scene_root_node.process_mode = Node.PROCESS_MODE_DISABLED
	current_scene_root_node.hide()
	get_tree().root.remove_child(current_scene_root_node)


func go_back(retain_in_memory:bool=false) -> void:
	if not previous_scene_stack.is_empty():
		go_to_scene_by_path(previous_scene_stack.pop_back(), false, retain_in_memory)
	else:
		get_tree().change_scene_to_file(fallback_scene)
