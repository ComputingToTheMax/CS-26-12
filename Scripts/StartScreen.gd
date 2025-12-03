extends Node2D
@onready var fade_rect: ColorRect =$FadeLayer/FadeRect

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
	fade_rect.color.a=1.0
	var tween := create_tween()
	tween.tween_property(fade_rect,"color:a",0.0,0.4)
	$PlayButton.pressed.connect(_on_play_pressed)

	# Settings button
	$Background/SettingsButton.pressed.connect(_on_settings_pressed)

	# Link to external Psyche Resources
	if $Background.has_node("PsycheButton"):
		$Background/PsycheButton.pressed.connect(_on_external_link_pressed)

	# Credits button
	$Button.pressed.connect(_on_credits_pressed)
func _transition_to_scene(path: String) ->void:
	var tween := create_tween()
	tween.tween_property(fade_rect,"color:a",1.0,0.4)
	await tween.finished
	
	var next_scene: PackedScene=load(path)
	get_tree().change_scene_to_packed(next_scene)

func _on_play_pressed() -> void:
	_transition_to_scene("res://Tutorial_Screen.tscn")
func _on_play_pressed():
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	var next_scene = load("res://Tutorial_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_settings_pressed():
	_transition_to_scene("res://Settings_Screen.tscn")
	
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	var next_scene = load("res://Settings_Screen.tscn")
	get_tree().change_scene_to_packed(next_scene)


func _on_external_link_pressed():
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	OS.shell_open("https://psyche.ssl.berkeley.edu/mission/faq/")


func _on_credits_pressed():
	_transition_to_scene("res://Credits.tscn")
	
