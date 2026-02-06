extends Button


@export var target_handler: Node
@export var target_signal_name: String

@export var target_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Automatically connect any buttons this script is applied to to the _on_pressed method
	# to handle button presses.
	if target_handler != null:
		self.pressed.connect(_on_pressed_call);
	elif target_scene != null:
		self.pressed.connect(_on_pressed_switch_scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed_call():
	target_handler.emit_signal(target_signal_name, target_scene)
	
func _on_pressed_switch_scenes():
	get_tree().change_scene_to_packed(target_scene)
	
