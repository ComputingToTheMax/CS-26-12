extends Node2D

@export var tutorial_scene_path = "res://Scenes/tutorial.tscn"
@export var main_board_scene_path = "res://Scenes/main_board.tscn"

var play_tutorial:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tutorial_selection_toggled(toggled_on: bool) -> void:
	play_tutorial = toggled_on


func _on_start_button_pressed() -> void:
	
	if GlobalSettings.number_of_players < 1:
		return
	
	Settings.play_tutorial = play_tutorial
	
	print("Get ready! We're about to start the game!")

	if Settings.play_tutorial:
		Navigator.go_to_scene_by_path(tutorial_scene_path)
	else:
		Navigator.go_to_scene_by_path(main_board_scene_path)
