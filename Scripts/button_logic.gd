extends Button



@export var target_scene: PackedScene
@export var target_scene_path:String


func _ready() -> void:
	
	
	if (target_scene == null) and (target_scene_path == ""):
		push_error("Oops! It looks like the button titled {name} wasn't given a target scene to switch too. Please select the node in the editor and provide one.".format({"name":self.name}))

	

	self.pressed.connect(_on_pressed_switch_scenes)


	
func _on_pressed_switch_scenes():
	
	if target_scene_path != "":
		
		Navigator.go_to(target_scene_path)


		
	
	
	
