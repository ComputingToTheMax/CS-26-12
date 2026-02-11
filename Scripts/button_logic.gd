extends Button

@export var target_handler: Node
@export var target_method_name: String = "on_confirm_pressed"
@export var target_scene: PackedScene

func _ready() -> void:
	if target_handler != null:
		pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if target_handler == null:
		push_error("ConfirmButton: target_handler is null")
		return
	if not target_handler.has_method(target_method_name):
		push_error("ConfirmButton: handler '%s' has no method '%s'" % [target_handler.name, target_method_name])
		return

	target_handler.call("_on_request_transition", target_scene)
