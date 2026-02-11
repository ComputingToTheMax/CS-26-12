extends Control

var current_pressed_button = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connect Children Player Count Selection Buttons to the Below Handler
	# TODO: Store the assumption that button names represent player counts.
	var selection_buttons = $VBoxContainer/PlayerCountButtons
	
	print(selection_buttons.get_children())
	
	for button in selection_buttons.get_children():
		
		button.pressed.connect(handle_player_count_selection)
		
		print(button.get_signal_connection_list("pressed"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_player_count_selection(id):
	
	var origin_node = instance_from_id(id)
	GlobalSettings.number_of_players = int(origin_node.name)
	
	print(origin_node.name, "Pressed!")
	
	# "Unpress" any currently pressed button and afterwards assign the new button as currently pressed.
	if current_pressed_button:
			current_pressed_button.pressed = false
			
	current_pressed_button = origin_node
