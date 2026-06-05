extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This function is based on code provided by "ju_again" on the Reddit thread titled "Getting extants of a node2d?"
static func calculate_node2d_bounding_box(node2d: Node2D) -> Rect2:
	var rect := Rect2()
	
	var children := node2d.get_children()
	
	while children:
		var current_child = children.pop_back()
		
		
		# Record the children of the current node if any exist.
		children.append_array(current_child.get_children())
		
		if current_child.has_method("get_rect") and current_child.has_method("to_global"):
			var current_child_rect := current_child.get_rect() as Rect2
			print(current_child_rect)
			current_child_rect.position = current_child.to_global(current_child_rect)
			
			rect = rect.merge(current_child_rect)
			
	if rect.size == Vector2(0, 0):
		push_warning("Oops, it looks like we attempted to calculate a bounding box for a node without children we can extract a size from! This was likely not intended, and a rectangle with a size of 0, 0 has been returned instead.")
	
	return rect
		
static func calculate_length_of_children_paths(node2d: Node2D) -> Vector2:
	
	var paths: Array[Path2D] = []
	var children = node2d.get_children()
	for child in children:
		if child is Path2D:
			paths.append(child)
	
	var minimums = Vector2(0, 0)
	var maximums = Vector2(0, 0)
	
	for path in paths:
		var curve_points := path.curve.get_baked_points()
		
		for current_point in curve_points:
			
			# Globalize the current point location so that it can be compared.
			current_point = path.to_global(current_point)
			
			minimums = minimums.min(current_point)
			maximums = maximums.max(current_point)
			
	return maximums - minimums


static func center_relative_to_parent_control_node(node2d: Node2D, parent_node: Control = node2d.get_parent()) -> void:

	## Locate the parent control node and ensure it is of the Control type.
	#var parent = node2d.get_parent()
	#assert(parent is Control)
	
	node2d.position += Vector2(parent_node.size.x/2, parent_node.size.y/2)
	

# Scaling to fit a Control node:
# - The idea for these functions is to treat the current ratio of parent size to window size as 1, and yield an adjustable scale parameter based on that
#   to achieve the current transform.


static func _identify_current_scale_relative_to_window(node: Node, parent_node: Control = node.get_parent()):
	
	var current_window_scale_ratio = 1.0 * node.get_parent().size.x / GlobalSettings.get_window_size().x
	print("!", node.get_parent().size.x, "!", GlobalSettings.get_window_size().x, "!")
	print(GlobalSettings.get_window_size().x)
	
	var ratio_offset = 1.0 - current_window_scale_ratio
	
	var scale = node.scale.x
	
	const WARNING_TEXT = "Identification of current scale relative to window size is intended as a debugging tool, not for production use."
	
	push_warning(WARNING_TEXT)
	print(WARNING_TEXT)
	print("Node: %s\n\tCurrent Scale: %s\n\tRatio Offset to Use the Current Scale: %s" % [node, scale, ratio_offset])
	
	

static func scale_to_current_window_size(node:Node, scale:float, ratio_offset:float = 0, parent_node: Control = node.get_parent()):
	# Scale the size of the paths upwards to fit the current screen size.
	var scale_factor:float = (parent_node.size.x / GlobalSettings.get_window_size().x + ratio_offset) * scale
	
	# Convert the scale factor into a two-value vector and apply it.
	node.scale *= Vector2(1, 1) * scale_factor


static func fade_out(target: Node, duration:float=0.3, existing_tween: Tween=null):
	
	if existing_tween == null:
		existing_tween = target.create_tween()
		
	existing_tween.tween_property(target, "modulate", Color.TRANSPARENT, duration).set_ease(Tween.EASE_IN)
		
