extends Control

@export var tutorial_scene_path = "res://Scenes/tutorial.tscn"
@export var main_board_scene_path = "res://Scenes/main_board.tscn"

@onready var title_label: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var selection_buttons: HBoxContainer = $VBoxContainer/PlayerCountButtons

var play_tutorial: bool = true
var currently_pressed_button: BaseButton = null

func _ready() -> void:
	title_label.bbcode_enabled = true
	title_label.text = "[center][b]Some minigames allow multiple players. Select the number of players.[/b][/center]"

	for button in selection_buttons.get_children():
		button.pressed.connect(Callable(handle_player_count_selection).bind(button))

	if selection_buttons.get_child_count() > 0:
		handle_player_count_selection(selection_buttons.get_child(0))
		selection_buttons.get_child(0).button_pressed = true

func handle_player_count_selection(origin_node: BaseButton) -> void:
	if origin_node == null:
		return

	if origin_node == currently_pressed_button:
		origin_node.button_pressed = true
		return

	GlobalSettings.set_number_of_players(int(origin_node.name))

	if currently_pressed_button != null:
		currently_pressed_button.button_pressed = false

	currently_pressed_button = origin_node
	currently_pressed_button.button_pressed = true

func _on_confirm_pressed() -> void:
	Settings.play_tutorial = play_tutorial
	
	print("Going!")

	if Settings.play_tutorial:
		Navigator.go_to_scene_by_path(tutorial_scene_path)
	else:
		Navigator.go_to_scene_by_path(main_board_scene_path)

func _on_play_tutorial_toggled(toggled_on: bool) -> void:
	play_tutorial = toggled_on
