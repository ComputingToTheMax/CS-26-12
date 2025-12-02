extends Node2D
@onready var fade_rect: ColorRect =$FadeLayer/FadeRect
func _ready():
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


func _on_settings_pressed():
	_transition_to_scene("res://Settings_Screen.tscn")
	


func _on_external_link_pressed():
	OS.shell_open("https://psyche.ssl.berkeley.edu/mission/faq/")


func _on_credits_pressed():
	_transition_to_scene("res://Credits.tscn")
	
