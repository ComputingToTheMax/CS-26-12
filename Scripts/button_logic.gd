extends Button


@export var target_handler: Node
@export var target_signal_name: String

@export var target_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Automatically connect any buttons this script is applied to to the _on_pressed method
	# to handle button presses.
	self.pressed.connect(_on_pressed);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed():
	target_handler.emit_signal(target_signal_name, target_scene)
