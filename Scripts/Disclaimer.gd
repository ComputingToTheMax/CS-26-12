extends Node2D

@export var target_scene: PackedScene

func _ready():
	# Wait 3 seconds, then go to StartScreen
	await get_tree().create_timer(3.0).timeout
	_go_to_start_screen()


# Load and run the initial start scene.
func _go_to_start_screen():
	if target_scene:
		get_tree().change_scene_to_packed(target_scene)
	else:
		push_error("Failed to load the target scene!")

func _input(event):
	# Optional: allow skipping disclaimer on click
	if event is InputEventMouseButton and event.pressed:
		_go_to_start_screen()
