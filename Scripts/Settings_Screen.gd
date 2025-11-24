extends Node2D

func _ready():
	# Return to Main Menu button
	$Background/ReturnButton.pressed.connect(_on_return_pressed)

	# Resolution buttons
	$Res360Button.pressed.connect(func() -> void: _change_resolution(360, 640))
	$Res480Button.pressed.connect(func() -> void: _change_resolution(480, 854))
	$Res720Button.pressed.connect(func() -> void: _change_resolution(720, 1280))
	$Res1080Button.pressed.connect(func() -> void: _change_resolution(1080, 1920))

func _on_return_pressed():
	# Use correct scene-changing method
	get_tree().change_scene_to_file("res://StartScreen.tscn")

func _change_resolution(height: int, width: int) -> void:
	DisplayServer.window_set_size(Vector2(width, height))
	print("Resolution changed to: %dx%d" % [width, height])
