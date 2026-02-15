extends Control


@onready var play_checkbox: CheckBox =%PlayTutorial

@export var tutorial_scene_path := "res://Scenes/tutorial.tscn"
@export var main_board_scene_path := "res://Scenes/main_board.tscn"

func _ready() -> void:
	if Engine.has_singleton("GameSettings"):
		play_checkbox.button_pressed = Settings.play_tutorial

	play_checkbox.toggled.connect(_on_play_toggled)

func _on_play_toggled(pressed: bool) -> void:
	Settings.play_tutorial = pressed

func on_confirm_pressed() -> void:
	Settings.play_tutorial = play_checkbox.button_pressed

	if Settings.play_tutorial:
		Navigator.go_to(tutorial_scene_path)
	else:
		Navigator.go_to(main_board_scene_path)
