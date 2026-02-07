extends Control

@onready var close_btn: BaseButton = $Panel/Root/MarginContainer/NavBar/Close

func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)
	await get_tree().process_frame


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		leave_shop()

func _on_close_pressed() -> void:
	leave_shop()

func leave_shop() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/main_board.tscn")
