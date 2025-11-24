extends Node2D

func _ready():
	# Wait 3 seconds, then go to StartScreen
	await get_tree().create_timer(3.0).timeout
	_go_to_start_screen()

func _go_to_start_screen():
	var start_scene: PackedScene = load("res://StartScreen.tscn")
	if start_scene:
		get_tree().change_scene_to_packed(start_scene)
	else:
		push_error("Failed to load StartScreen.tscn!")

func _input(event):
	# Optional: allow skipping disclaimer on click
	if event is InputEventMouseButton and event.pressed:
		_go_to_start_screen()
