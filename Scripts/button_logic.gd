extends Button

# Specify one of the below options using the editor to select button properties.
@export var target_scene: PackedScene
@export var target_scene_path: String


func _ready() -> void:
	if (target_scene == null) and (target_scene_path == "" or target_scene_path == null):
		push_error("Oops! It looks like the button titled {name} wasn't given a target scene to switch too. Please select the node in the editor and provide one.".format({"name":self.name}))

	if (target_scene != null) and (target_scene_path != "" or target_scene_path != null):
		push_warning("Oops! Both a target (packed) scene and a target scene path (string) were specified. Only one option will be used.\n\tNode: %s" % [self.name])

	self.pressed.connect(_on_pressed_switch_scenes)
	
func _on_pressed_switch_scenes():
	
	if (target_scene != null):
		Navigator.go_to_packed_scene(target_scene)
	
	elif (target_scene_path != null):
		Navigator.go_to_scene_by_path(target_scene_path)
