extends Control

var current_pressed_button = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connect Children Player Count Selection Buttons to the Below Handler
	# TODO: Store the assumption that button names represent player counts.
	var selection_buttons = $VBoxContainer/PlayerCountButtons
	
	for button in selection_buttons.get_children():
		
		# Bind the buttons themselves to the callable so that it can be accessed as a parameter.
		button.pressed.connect(Callable(handle_player_count_selection).bind(button))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_player_count_selection(origin_node):
	
	GlobalSettings.number_of_players = int(origin_node.name)
	
	# "Unpress" any currently pressed button and afterwards assign the new button as currently pressed.
	if current_pressed_button:
			current_pressed_button.button_pressed = false
			
	current_pressed_button = origin_node
