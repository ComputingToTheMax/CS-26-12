extends Control


@onready var play_checkbox: CheckBox =%PlayTutorial
@onready var confirm_button: Button = $VBoxContainer/MarginContainer/confirm
@export var tutorial_scene_path := "res://Scenes/tutorial.tscn"
@export var main_board_scene_path := "res://Scenes/main_board.tscn"

func _ready() -> void:
	
	print("READY Settings.play_tutorial =", Settings.play_tutorial)
	play_checkbox.button_pressed = Settings.play_tutorial
	play_checkbox.toggled.connect(_on_play_toggled)
	confirm_button.pressed.connect(_on_confirm_pressed)



func _on_play_toggled(pressed: bool) -> void:
	Settings.play_tutorial = pressed

func _on_confirm_pressed() -> void:
	Settings.play_tutorial = play_checkbox.button_pressed

	if Settings.play_tutorial:
		Navigator.go_to(tutorial_scene_path)
	else:
		Navigator.go_to(main_board_scene_path)
