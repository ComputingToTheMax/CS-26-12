extends Node2D


@onready var pause_menu: Control = $CanvasLayer/PauseMenu  # the instanced PauseMenu node

@onready var dialog_image: TextureRect = $DialogLayer/DialogBox/DialogContainer/DialogImage

@onready var dialog_label: Label = $DialogLayer/DialogBox/DialogContainer/DialogText

@onready var bg_rect: TextureRect = $BackgroundLayer/TextureRect
@onready var tutorialchar: TextureRect = $BackgroundLayer/Characters/Spaceman 
@onready var contextimg: TextureRect = $ContextLayer/Context


var current_index := 0


var dialog_entries := [
	{
		"text": "Welcome to our game about the Psyche asteroid. Press space or click to go through text boxes",
		"bg":"",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":""
	},
	{
		"text": "In this game you will race around our psyche-themed board trying to reach psyche before any of your competitors",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":"res://Sources/Images/boardexample.png"
	},{
		"text": "There are many spaces to land on to help you advance your journey",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":"res://Sources/Images/boardexample.png"
	},
	{
		"text": "There are many minigames scattered around the board that when landed on will give you a challenge to complete",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":"res://Sources/Images/boardexample.png"
	},
	{
		"text": "By scoring well on minigames you can gain powerful items or money",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":""
	},
	{
		"text": "You can spend your money at shops to buy powerful items, or to hire people to help you along your journey",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":""
	},
	{
		"text": "Good luck, the fate of Psyche is on your hands",
		"bg": "",
		"tutorialchar":"res://Sources/Images/SpacemanCharacter1.png",
		"context":""
	}
]

func _ready() -> void:
	_show_dialog_entry(current_index)
	pause_menu.connect("main_menu_requested", Callable(self, "_on_pause_main_menu"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.toggle()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("ui_accept"):
		advance_dialog()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		advance_dialog()
func _set_context(path: Variant) -> void:
	if contextimg == null:
		return

	if path == null or String(path) == "":
		contextimg.texture = null
		contextimg.visible = false
		return

	var tex := load(String(path)) as Texture2D
	if tex == null:
		contextimg.texture = null
		contextimg.visible = false
		return

	contextimg.texture = tex
	contextimg.visible = true

		
func _set_tex(rect: TextureRect, path: Variant, label: String) -> void:
	if rect == null:
		push_error("TextureRect is NULL for: " + label + " (node path is wrong or node doesn't exist)")
		return

	if path == null or String(path) == "":
		rect.texture = null
		rect.visible = false
		return

	var tex := load(String(path)) as Texture2D
	if tex == null:
		push_error("Failed to load texture for " + label + " at: " + String(path))
		rect.texture = null
		rect.visible = false
		return

	rect.texture = tex
	rect.visible = true
func _on_pause_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://StartScreen.tscn")
func _show_dialog_entry(index: int) -> void:
	var entry: Dictionary = dialog_entries[index]

	dialog_label.text = entry.get("text", "")

	_set_tex(bg_rect, entry.get("bg", ""), "BG")
	_set_tex(tutorialchar, entry.get("tutorialchar", ""), "Char")
	_set_tex(contextimg, entry.get("context",""),"Con")
func advance_dialog():
	current_index += 1

	if current_index < dialog_entries.size():
		_show_dialog_entry(current_index)
	else:
		get_tree().change_scene_to_file("res://Scenes/main_board.tscn")
