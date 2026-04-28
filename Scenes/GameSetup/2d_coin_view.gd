class_name DiscoveryToken
extends Control

@export var maximum_rotation:int = 35
@export var coin_image = null

var mouse_inside = false
@onready var positioning_node = %PositioningNode
@onready var click_panel = %InteractionArea
@onready var coin = %Coin

var coin_radius = -1
var maximum_length = -1

var _coin_dropped = false
var _follow_mouse = false
var local_click_location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Determine the current radius of the coin
	coin_radius = click_panel.size.x / 2

	
	pass # Replace with function body.
	
func set_coin_image(filepath):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _follow_mouse:
		# To make the drag position follow the mouse from where a click occurs, adjust for the size of the coin and the local click position.
		position = get_global_mouse_position() - Vector2(size.x/2, size.y/2) - local_click_location


func _on_panel_mouse_entered() -> void:
	mouse_inside = true


func _on_panel_mouse_exited() -> void:
	mouse_inside = false
	
	
func _input(event):
	if (mouse_inside) and (event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT):
		
		if event.pressed == true:
			#print(event)
			
			# As control nodes do not have a "to_local" function, a Node2D has been added as a child of the clickable panel
			# and is used to translate click coordinates into a local space.

			# Calculate the local mouse position relative to the center of the panel container surrounding the panel.
			
			local_click_location = click_panel.get_local_mouse_position() - Vector2(click_panel.size.x/2, click_panel.size.y/2)

			var vector_for_rotation = Vector3(-1 * local_click_location[1], 0, 1 * local_click_location[0]).normalized()
			
			var rotation_vector = maximum_rotation * vector_for_rotation * (min(1, local_click_location.length()/coin_radius))
			
			# print(rotation_vector)
			
			coin.set_target_rotation(rotation_vector)
			
			_follow_mouse = true
			
		else:
			_follow_mouse = false
			coin.set_target_rotation(Vector3())
			
			
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
	
	
	
	return self
	
