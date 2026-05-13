extends Node2D

@export var use_path_method: bool = false

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global_position)
	print(parent.size)
	print(parent.global_position)
	
	var scale_factor:float = (parent.size.x / GlobalSettings.get_window_size().x + 0.41753472222222) * 1.65
	print(scale_factor)
	print(position, global_position)
	
	# Convert the scale factor into a two-value vector.
	scale *= Vector2(1, 1) * scale_factor
	#position *= Vector2(-10.83, -0.789)
	
	#var size
	#if use_path_method:
		#size = GlobalUtilities.calculate_length_of_children_paths(self)
	#else: 
		#size = GlobalUtilities.calculate_node2d_size(self).size
		#
	#print(size)
	#self.position -= Vector2(size.x, size.y/2)
	
	self.position += Vector2(parent.size.x/2, parent.size.y/2)
	#self.position = parent.global_position
	print("---")
	print(scale)
	print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
