class_name DiscoveryToken
extends Control

@export var token_mission:String
@onready var image_texture = %Coin/Coin/Graphic.texture.resource_path

# Coin Variables

@export var maximum_rotation:int = 35
@export var coin_image = null

var mouse_inside = false
@onready var click_panel = %InteractionArea
@onready var coin = %Coin

# The target top scene to reparent coins to after they have been moved.
@onready var top_scene = %TopScene

var coin_radius = -1
var maximum_length = -1

var _coin_dropped = false
var _follow_mouse = false
var local_click_location
var current_rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Determine the current radius of the coin
	coin_radius = click_panel.size.x / 2
	
	# Center the coin so that 
	pivot_offset = size / 2.0
	
	pass # Replace with function body.
	
func set_coin_image(filepath):
	pass
	
func drop_coin():
	_coin_dropped = true
	
	var scale_tween = create_tween().tween_property(self, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _follow_mouse:
		# To make the drag position follow the mouse from where a click occurs, adjust for the size of the coin and the local click position.
		position = get_global_mouse_position() - Vector2(size.x/2, size.y/2) - local_click_location

	#if _coin_dropped == true:
		#if scale.x > 0:
			#scale -= scale * 0.2 * delta

func _on_panel_mouse_entered() -> void:
	mouse_inside = true


func _on_panel_mouse_exited() -> void:
	mouse_inside = false
	
	
func _input(event):
	
	
	if (mouse_inside) and (event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT):
		
		if event.pressed == true:
		
			if (top_scene != null) and (get_parent() != top_scene):
				reparent(top_scene)
			
			#print(event)
			
			# As control nodes do not have a "to_local" function, a Node2D has been added as a child of the clickable panel
			# and is used to translate click coordinates into a local space.

			# Calculate the local mouse position relative to the center of the panel container surrounding the panel.
			
			local_click_location = click_panel.get_local_mouse_position() - Vector2(click_panel.size.x/2, click_panel.size.y/2)

			var vector_for_rotation = Vector3(-1 * local_click_location[1], 0, 1 * local_click_location[0]).normalized()
			
			var rotation_vector = maximum_rotation * vector_for_rotation * (min(1, local_click_location.length()/coin_radius))
			
			# print(rotation_vector)
			
			coin.set_target_rotation(rotation_vector)
			current_rotation = rotation_vector
			
			_follow_mouse = true
			
	if (event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed == false):
		_follow_mouse = false
		coin.set_target_rotation(Vector3())
		click_panel.mouse_filter = Control.MOUSE_FILTER_PASS
			
		
func rotate_to_side():
	coin.set_target_rotation(Vector3(0, 0, -90))
	
func rotate_to_click_position():
	coin.set_target_rotation(current_rotation)
	
	
			
func _get_drag_data(at_position: Vector2) -> Variant:
	print("Dragging!")
	
	#var discovery_token_for_preview = load(self.scene_file_path).instantiate()
	#discovery_token_for_preview.set_coin_image(self.coin_image)
	#
	#var preview = Control.new()
	#preview.add_child(discovery_token_for_preview)
	#discovery_token_for_preview.position = -0.5 * discovery_token_for_preview.size
	#discovery_token_for_preview.size *= 0.7
	
	#self.hide()
	
	#set_drag_preview(preview)
	
	click_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return self
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("A DiscoveryToken can't drop to itself.")
	return false
