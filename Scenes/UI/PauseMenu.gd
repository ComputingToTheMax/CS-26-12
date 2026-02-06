extends Control

signal main_menu_requested

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$MenuPanel/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$MenuPanel/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)


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


func _on_main_menu_pressed() -> void:
	emit_signal("main_menu_requested")
