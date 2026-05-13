extends Node2D

@onready var child_path = $ParticlePath/PathFollow2D

var transform_applied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# TODO: This is placed here, as the video may not have been loaded by the time _ready is called, resulting in inproper size calculations.
	if !transform_applied and get_parent().scale != Vector2.ZERO:
		_apply_transform()
		
	#print(get_parent().size/2)
	
	
func _apply_transform():
	
	print(get_parent().size/2)
	
	GlobalUtilities.scale_to_current_window_size(self, 4.071, 0.61805555555556)
	#GlobalUtilities.center_relative_to_parent_control_node(self)

	
	transform_applied = true
