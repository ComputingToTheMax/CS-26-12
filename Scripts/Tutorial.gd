extends Node2D

@onready var pause_menu: CanvasLayer = $CanvasLayer/PauseMenu
@onready var dialog_label: Label = $DialogLayer/DialogBox/DialogContainer/DialogText
@onready var bg_rect: TextureRect = $BackgroundLayer/Background
@onready var tutorialchar: TextureRect = $BackgroundLayer/Characters/Spaceman
@onready var contextimg: TextureRect = $ContextLayer/Context
@export var tutorial_type := "board"

var dialog_entries: Array = []
var current_index := 0

var board_dialog := [
	{
		"text": "Welcome to Psyche-Opoly. This game is inspired by NASA's Psyche mission, but it is not a literal simulation of the real mission. Press Space or left click to move through the tutorial.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	},
	{
		"text": "Your goal is to collect every ship part needed to finish your spacecraft. When you have all seven ship parts, the game will end and go to credits.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": "res://Sources/Images/boardexample.png"
	},
	{
		"text": "There is also a turn limit. After 15 full trips around the board, the game will end and go to credits even if your ship is not complete yet.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": "res://Sources/Images/boardexample.png"
	},
	{
		"text": "Press Space or click the Roll button on your turn to move. Landing on different tiles can give you money, open shops, or trigger minigames.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": "res://Sources/Images/boardexample.png"
	},
	{
		"text": "Red minigame tiles can launch a challenge. Winning minigames can earn you ship parts and other useful rewards.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": "res://Sources/Images/boardexample.png"
	},
	{
		"text": "Shops let you spend money on parts and helpers. Keep collecting ship parts from shops and minigame rewards until your spacecraft is complete.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	},
	{
		"text": "Some minigames allow multiple players, so choose the right player count before starting the board.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	},
	{
		"text": "Good luck. Build the full ship before 15 laps are up and complete your mission.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	}
]

var alien_dialog := [
	{
		"text": "Your crew has intercepted an alien signal. Type valid words using only the letters shown on the board before time runs out.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	}
]

var hanger_dialog := [
	{
		"text": "Your crew found a shipyard. Sort the ships correctly according to the rules to clear the challenge.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	}
]

var asteroid_dialog := [
	{
		"text": "Your crew has spotted the Psyche asteroid. Click the moving asteroid to keep advancing through the encounter.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	}
]

var genisis_dialog := [
	{
		"text": "Your crew has found the Genesis craft drifting through space. Collect different kinds of solar wind to help the mission.",
		"bg": "",
		"tutorialchar": "res://Sources/Images/SpacemanCharacter1.png",
		"context": ""
	}
]

func _ready() -> void:
	match tutorial_type:
		"board":
			dialog_entries = board_dialog
		"alien":
			dialog_entries = alien_dialog
		"hanger":
			dialog_entries = hanger_dialog
		"asteroid":
			dialog_entries = asteroid_dialog
		"genesis":
			dialog_entries = genisis_dialog
		_:
			dialog_entries = board_dialog

	_show_dialog_entry(current_index)
	pause_menu.connect("main_menu_requested", Callable(self, "_on_pause_main_menu"))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.toggle()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("ui_accept"):
		advance_dialog()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		advance_dialog()

func _set_tex(rect: TextureRect, path: Variant, label_name: String) -> void:
	if rect == null:
		push_error("TextureRect is NULL for: " + label_name)
		return

	if path == null or String(path) == "":
		rect.texture = null
		rect.visible = false
		return

	var tex := load(String(path)) as Texture2D
	if tex == null:
		push_error("Failed to load texture for " + label_name + " at: " + String(path))
		rect.texture = null
		rect.visible = false
		return

	rect.texture = tex
	rect.visible = true

func _on_pause_main_menu() -> void:
	get_tree().paused = false
	Navigator.go_to_scene_by_path("res://Scenes/main_menu.tscn")

func _show_dialog_entry(index: int) -> void:
	if index < 0 or index >= dialog_entries.size():
		return

	var entry: Dictionary = dialog_entries[index]
	dialog_label.text = entry.get("text", "")
	_set_tex(bg_rect, entry.get("bg", ""), "BG")
	_set_tex(tutorialchar, entry.get("tutorialchar", ""), "Char")
	_set_tex(contextimg, entry.get("context", ""), "Context")

func advance_dialog() -> void:
	current_index += 1

	if current_index < dialog_entries.size():
		_show_dialog_entry(current_index)
	else:
		Navigator.go_to_scene_by_path("res://Scenes/main_board.tscn")