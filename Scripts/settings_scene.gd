extends Node2D

var click_player: AudioStreamPlayer
var click_enabled := true

func _ready():
	## Create the audio player
	#click_player = AudioStreamPlayer.new()
	#add_child(click_player)
#
	## Load the click sound file
	#click_player.stream = load("res://Sources/Sounds/click.wav")

	# Return to Main Menu button
	#$Background/ReturnButton.pressed.connect(_on_return_pressed)
	$Background/ToggleSoundButton.pressed.connect(_on_toggle_sound_pressed)
	# Resolution buttons
	$Res360Button.pressed.connect(func() -> void: _change_resolution(360, 640))
	$Res480Button.pressed.connect(func() -> void: _change_resolution(480, 854))
	$Res720Button.pressed.connect(func() -> void: _change_resolution(720, 1280))
	$Res1080Button.pressed.connect(func() -> void: _change_resolution(1080, 1920))
	
	_update_click_sound_display_text()

#func play_click():
	#if not click_enabled:
		#return
	#if click_player.playing:
		#click_player.stop()
	#click_player.play()
	
func _on_toggle_sound_pressed():
	_toggle_click_sound()
	_update_click_sound_display_text()

func _toggle_click_sound():
	GlobalSettings.click_sound_enabled = !GlobalSettings.click_sound_enabled
	return GlobalSettings.click_sound_enabled
	
func _update_click_sound_display_text():
	if GlobalSettings.click_sound_enabled:
		$Background/ToggleSoundButton.text = "Disable Click Sounds"
	else:
		$Background/ToggleSoundButton.text = "Enable Click Sounds"
		
func _on_back_pressed()->void:
	Navigator.go_back()
#func _on_return_pressed():
	#play_click()
	#await get_tree().create_timer(click_player.stream.get_length()).timeout
	#Navigator.go_back()

func _change_resolution(height: int, width: int) -> void:
	#play_click()
	await get_tree().create_timer(click_player.stream.get_length()).timeout
	DisplayServer.window_set_size(Vector2(width, height))
	print("Resolution changed to: %dx%d" % [width, height])
