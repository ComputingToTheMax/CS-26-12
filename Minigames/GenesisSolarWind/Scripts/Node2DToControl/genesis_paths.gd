extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Scale the size of the paths upwards to fit the current screen size.
	print(get_parent().size.x / GlobalSettings.get_window_size().x)
	var scale_factor:float = (get_parent().size.x / GlobalSettings.get_window_size().x + 0.41753472222222) * 1.65
	
	# Convert the scale factor into a two-value vector and apply it.
	scale *= Vector2(1, 1) * scale_factor
	
	
	GlobalUtilities.center_relative_to_parent_control_node(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
