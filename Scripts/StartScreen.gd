extends Node2D

func _ready():
	var playBtn = $PlayButton
	playBtn.disabled = false
	playBtn.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	var nextScene = load("res://Tutorial_Screen.tscn")
	get_tree().change_scene_to_packed(nextScene)
