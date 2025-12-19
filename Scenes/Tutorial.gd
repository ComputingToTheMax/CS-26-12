extends Node2D


@onready var pause_menu: Control = $CanvasLayer/PauseMenu  # the instanced PauseMenu node


@onready var dialog_label: Label = $DialogLayer/DialogBox/DialogContainer/DialogText

var current_index := 0

var dialog_lines := [
	"Welcome to our game about the Psyche asteroid. Press the space button to go through text boxes",
	"In this game you will race around our psyche-themed board trying to reach psyche before any of your competitors",
	"There are many minigames scattered around the board that when landed on will give you a challenge to complete",
	"By scoring well on minigames you can gain powerful items or money",
	"You can spend your money at shops to buy powerful items, or to hire people to help you along your journy",
	"Good luck, the fate of Psyche is on your hands"
]

func _ready() -> void:
	dialog_label.text = dialog_lines[current_index]
	pause_menu.connect("main_menu_requested", Callable(self, "_on_pause_main_menu"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.toggle()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_accept"):
		advance_dialog()


func _on_pause_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://StartScreen.tscn")

func advance_dialog():
	current_index += 1
	
	if current_index < dialog_lines.size():
		dialog_label.text = dialog_lines[current_index]
	else:
		get_tree().change_scene_to_file("res://Scenes/main_board.tscn")
