extends Node2D

func _ready():
	# Play button
	$PlayButton.pressed.connect(_on_play_pressed)

	# Settings button
	$Background/SettingsButton.pressed.connect(_on_settings_pressed)

	# Link to external Psyche Resources
	if $Background.has_node("PsycheButton"):
		$Background/PsycheButton.pressed.connect(_on_external_link_pressed)

	# Credits button
	$Button.pressed.connect(_on_credits_pressed)


func _on_play_pressed():
	var next_scene = load("res://Tutorial_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_settings_pressed():
	var next_scene = load("res://Settings_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_external_link_pressed():
	OS.shell_open("https://psyche.ssl.berkeley.edu/mission/faq/")


func _on_credits_pressed():
	var credits_scene = load("res://Credits.tscn")
	get_tree().change_scene_to_packed(credits_scene)
