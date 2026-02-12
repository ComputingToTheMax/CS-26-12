extends Button


#@export var signal_name_to_emit: String

@export var target_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#
	#if (signal_name_to_emit == null) and (target_scene == null):
		##push_error("Oops! It looks like this button was neither given a target scene, nor a target handler (a method to do something on a press). Please select the node and provide one of these so that button presses can trigger some event.")
		#push_error("Oops! It looks like this button wasn't given a target scene to switch too. Please select the node in the editor and provide one.")
	
	print(target_scene.resource_path)
	if (target_scene == null):
		push_error("Oops! It looks like the button titled {name} wasn't given a target scene to switch too. Please select the node in the editor and provide one.".format({"name":self.name}))
	
	# Automatically connect any buttons this script is applied to to the _on_pressed method
	# to handle button presses.
	#if signal_name_to_emit != null:
		#self.pressed.connect(_on_pressed_call);
	elif target_scene != null:
		self.pressed.connect(_on_pressed_switch_scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_pressed_call():
	#self.emit_signal(signal_name_to_emit, target_scene)
	
func _on_pressed_switch_scenes():
	
	# It seems like packed scenes are stored in-memory and can potentially create problems with cyclic switching.
	# For now, it is being replaced with the possibly slower "change_scene_to_file" which directly loads the scene at call time. 
	#get_tree().change_scene_to_packed(target_scene)
	
	get_tree().change_scene_to_file(target_scene.resource_path)
	
