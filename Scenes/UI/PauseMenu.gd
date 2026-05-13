extends CanvasLayer
class_name pauseMe
signal main_menu_requested



func _ready() -> void:
	layer = 400
	add_to_group("pause_menu")
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$Control/CenterContainer/MenuPanel/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$Control/CenterContainer/MenuPanel/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$Control/CenterContainer/MenuPanel/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)

func open() -> void:
	visible = true
	get_tree().paused = true


func close() -> void:
	visible = false
	get_tree().paused = false



func toggle() -> void:
	if visible:
		close()
	else:
		open()


func _on_resume_pressed() -> void:
	close()
func _on_settings_pressed()->void:
	close()
	Navigator.go_to_scene_by_path("res://Scenes/settings.tscn")

func _on_main_menu_pressed() -> void:
	close()
	Navigator.go_to_scene_by_path("res://Scenes/main_menu.tscn")
