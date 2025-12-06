extends Node2D


@onready var pause_menu: Control = $CanvasLayer/PauseMenu  # the instanced PauseMenu node

func _ready() -> void:
	pause_menu.connect("main_menu_requested", Callable(self, "_on_pause_main_menu"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.toggle()
		get_viewport().set_input_as_handled()


func _on_pause_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://StartScreen.tscn")
