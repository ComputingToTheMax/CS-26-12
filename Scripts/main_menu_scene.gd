extends Control
@onready var fade_rect: ColorRect =$FadeLayer/FadeRect

var click_player: AudioStreamPlayer
var target_scene: PackedScene
#signal request_transition
@export var play_target_scene: PackedScene
func _ready():
	# Create the audio player
	click_player = AudioStreamPlayer.new()
	add_child(click_player)

	# Load the click sound file
	click_player.stream = load("res://Sources/Sounds/click.wav")

	fade_rect.color.a=1.0
	var tween := create_tween()
	tween.tween_property(fade_rect,"color:a",0.0,0.4)

	# Link to external Psyche Resources
	%PsycheMissionLink.pressed.connect(_on_external_link_pressed)


	
func _on_external_link_pressed():
	click_player.play()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	OS.shell_open("https://psyche.ssl.berkeley.edu/mission/faq/")
	
# Handle General Button Transitions to New Scenes
func _transition_to_scene(load_scene: PackedScene) ->void:
	var tween := create_tween()
	tween.tween_property(fade_rect,"color:a",1.0,0.4)
	await tween.finished
	get_tree().change_scene_to_packed(load_scene)
	
func _click_then_transition(load_scene: PackedScene):
	if click_player and click_player.stream:
		click_player.play()
		await get_tree().create_timer(click_player.stream.get_length()).timeout
	await _transition_to_scene(load_scene)

func _on_request_transition(load_scene: PackedScene) -> void:
	await _click_then_transition(load_scene)
func _on_confirm_pressed() -> void:
	if play_target_scene == null:
		push_error("MainMenu: play_target_scene not set")
		return
	await _click_then_transition(play_target_scene)
