extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var engine_license_text:String = "[center]This game uses the Godot Engine. The Godot Engine is available under the following license:\n\n[i]" + Engine.get_license_text() + "[/i][/center]"

	text = engine_license_text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
