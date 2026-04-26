extends Control

@export var maximum_rotation:int = 35

var mouse_inside = false
@onready var positioning_node = %PositioningNode
@onready var click_panel = $Panel
@onready var coin = %Coin

var coin_radius = -1
var maximum_length = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Determine the current radius of the coin
	coin_radius = click_panel.size.x / 2

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_panel_mouse_entered() -> void:
	mouse_inside = true


func _on_panel_mouse_exited() -> void:
	mouse_inside = false
	
	
func _input(event):
	if (mouse_inside) and (event is InputEventMouseButton) and (event.button_index == 1):
		
		if event.pressed == true:
			#print(event)
			
			# As control nodes do not have a "to_local" function, a Node2D has been added as a child of the clickable panel
			# and is used to translate click coordinates into a local space.
			var local_position = positioning_node.to_local(event.position)
			var vector_for_rotation = Vector3(-1 * local_position[1], 0, 1 * local_position[0]).normalized()
			
			var rotation_vector = maximum_rotation * vector_for_rotation * (max(coin_radius, vector_for_rotation.length())/coin_radius)
			
			# print(rotation_vector)
			
			coin.set_target_rotation(rotation_vector)
			
		else:
			coin.set_target_rotation(Vector3())
