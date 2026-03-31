extends Control

@export var tutorial_scene_path = "res://Scenes/tutorial.tscn"
@export var main_board_scene_path = "res://Scenes/main_board.tscn"

var play_tutorial:bool = true

var currently_pressed_button:Node = null


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


func handle_player_count_selection(origin_node:Node):
	
	# If the same button is pressed multiple times, ensure it stays highlighted on subsequent presses.
	if origin_node == currently_pressed_button:
		origin_node.button_pressed = true
		return
	
	GlobalSettings.set_number_of_players(int(origin_node.name)) 
	
	# "Unpress" any currently pressed button and afterwards assign the new button as currently pressed.
	if currently_pressed_button:
		currently_pressed_button.button_pressed = false
			
	currently_pressed_button = origin_node


func _on_confirm_pressed() -> void:
	Settings.play_tutorial = play_tutorial

	if Settings.play_tutorial:
		Navigator.go_to_scene_by_path(tutorial_scene_path)
	else:
		Navigator.go_to_scene_by_path(main_board_scene_path)


func _on_play_tutorial_toggled(toggled_on: bool) -> void:
	play_tutorial = toggled_on
