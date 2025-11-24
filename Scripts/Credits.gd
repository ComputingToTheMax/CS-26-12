extends Node2D

func _ready():
	$Background/ReturnButton.pressed.connect(_on_return_pressed)

func _on_return_pressed():
	var start_scene = load("res://StartScreen.tscn")
	get_tree().change_scene_to_packed(start_scene)
