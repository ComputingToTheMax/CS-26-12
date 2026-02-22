extends Node
class_name PauseManager

@export var pause_menu_scene: PackedScene = preload("res://Scenes/UI/PauseMenu.tscn")
@export var pause_disabled_scenes: Array[String] = [
	"res://Scenes/main_menu.tscn",
	"res://Scenes/settings.tscn"
]
var menu: pauseMe

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return

	var cs := get_tree().current_scene
	if cs != null and cs.is_in_group("no_pause"):
		get_viewport().set_input_as_handled()
		return

	toggle()
	get_viewport().set_input_as_handled()

func toggle() -> void:
	if menu == null:
		_spawn_menu()

	menu.toggle()

func _spawn_menu() -> void:
	menu = pause_menu_scene.instantiate() as pauseMe
	menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().root.add_child(menu)

	menu.main_menu_requested.connect(_go_main_menu)

func _go_main_menu() -> void:
	if menu:
		menu.close()
	Navigator.go_to_scene_by_path("res://Scenes/main_menu.tscn")
	
