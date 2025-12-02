extends Node2D

var click_player: AudioStreamPlayer

func _ready():
	# Create the audio player
	click_player = AudioStreamPlayer.new()
	add_child(click_player)

	# Load the click sound file
	click_player.stream = load("res://Sources/Sounds/click.wav")

	# Return to Main Menu button
	$Background/ReturnButton.pressed.connect(_on_return_pressed)

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
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	var next_scene = load("res://Tutorial_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_settings_pressed():
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	var next_scene = load("res://Settings_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_external_link_pressed():
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	OS.shell_open("https://psyche.ssl.berkeley.edu/mission/faq/")


func _on_credits_pressed():
	var credits_scene = load("res://Credits.tscn")
	get_tree().change_scene_to_packed(credits_scene)
