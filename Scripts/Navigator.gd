extends Node
class_name SceneNavigator

var scenes_in_memory: Dictionary[String, Node] = {}

var previous_scene_stack: Array[String] = []
@export var fallback_scene: String = "res://Scenes/main_menu.tscn"

func go_to_packed_scene(target_scene: PackedScene, push_onto_previous_scene_stack=true, retain_in_memory:bool=true):
	var target_scene_path = target_scene.resource_path
	
	go_to_scene_by_path(target_scene_path, push_onto_previous_scene_stack, retain_in_memory)

func go_to_scene_by_path(target_scene_path: String, push_onto_previous_scene_stack=true, retain_in_memory:bool=true) -> void:
	
	# Identify information about the current scene.
	var current_scene_root_node := get_tree().current_scene
	var current_scene_path:String
	
	# Guard Clauses
	
	# Flag potentially inconsistent states if the current scene doesn't seem to exist.
	if (current_scene_root_node == null):
		print_debug("The current scene didn't seem to exist when the SceneNavigator went to transition scenes.")
	else:
		current_scene_path = current_scene_root_node.scene_file_path
		
	if (current_scene_path == ""):
		print_debug("The current scene path didn't seem to exist when the SceneNavigator went to transition scenes.")
	
	# Abort the transition if we are asked to switch to a scene that is already the current scene.
	if (current_scene_path == target_scene_path):
		push_error("Oops, the SceneNavigator was asked to navigate to the same scene that is already active: $s" % [current_scene_path])
		return
		
	# At this point, it should be safe to transition.
	
	# Keep track of the name of the current scene.
	if (previous_scene_stack != null):
		previous_scene_stack.push_back(current_scene_path)
		
	# Obtain the target node to transition to.
	var target_scene_node = null
	if scenes_in_memory.has(target_scene_path):
		print_debug("An existing scene has been pulled back from memory: %s" % [target_scene_path])
		target_scene_node = scenes_in_memory[target_scene_path]
	else:
		print_debug("A new scene has been loaded into memory: %s" % [target_scene_path])
		target_scene_node = load(target_scene_path).instantiate()
	
	# If we are supposed to retain the current node in memory, use a custom scene switcher. Otherwise, use the default Godot "change_scene_to_node"
	# which automatically deletes the previous scene.
	if retain_in_memory:
		
		# Save the current scene node if requested.
		# TODO: Determined if the optimal behavior is to overwrite or to keep the preserved version.
		if scenes_in_memory.has(current_scene_path):
			push_warning("The current scene: \"%s\" has already been stored in memory, so it won't be saved again. The current state will be discarded. If this is intended behavior, this warning can be ignored.")
		else:
			scenes_in_memory[current_scene_path] = current_scene_root_node
		
		change_scene_to_node_and_preserve(target_scene_node)
		
	else:
		var err := get_tree().change_scene_to_node(target_scene_node)
		push_error("SceneNavigator.go_to failed: %s (err=%d)" % [target_scene_path, err])

# TODO: Implement Godot scene-switcher-like error handling.
func change_scene_to_node_and_preserve(target_node: Node):
	var current_scene_root_node := get_tree().current_scene
	
	# Add, enable, and show the target node from the scene tree.
	get_tree().root.add_child(target_node)
	get_tree().current_scene = target_node
	target_node.process_mode = Node.PROCESS_MODE_INHERIT
	target_node.show()
	
	# Disable and hide the previous node.
	current_scene_root_node.process_mode = Node.PROCESS_MODE_DISABLED
	current_scene_root_node.hide()
	get_tree().root.remove_child(current_scene_root_node)


func go_back(retain_in_memory:bool=false) -> void:
	if not previous_scene_stack.is_empty():
		go_to_scene_by_path(previous_scene_stack.pop_back(), false, retain_in_memory)
	else:
		get_tree().change_scene_to_file(fallback_scene)
