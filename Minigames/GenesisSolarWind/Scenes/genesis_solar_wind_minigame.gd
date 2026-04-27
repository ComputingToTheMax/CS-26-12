extends Node2D



@export var target_scene_path: String

#@export var target_scene: PackedScene
@export var stacking_handler_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var loaded_handler = stacking_handler_scene.instantiate()
	loaded_handler.__init(target_scene_path)
	get_tree().root.add_child.call_deferred(loaded_handler)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
