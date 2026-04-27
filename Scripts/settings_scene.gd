extends Node2D

func _ready() -> void:
	var slider: HSlider = $Background/VolumeSlider
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = GlobalSettings.master_volume
	slider.value_changed.connect(_on_volume_changed)
	
	$Background/ToggleSoundButton.pressed.connect(_on_toggle_sound_pressed)
	_update_click_sound_display_text()

	$Background/ToggleMinigameIntro.pressed.connect(_on_toggle_intro_pressed)
	_update_intro_display_text()

func _on_volume_changed(value: float) -> void:
	GlobalSettings.master_volume = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)

func _on_toggle_sound_pressed() -> void:
	GlobalSettings.click_sound_enabled = not GlobalSettings.click_sound_enabled
	_update_click_sound_display_text()

func _update_click_sound_display_text() -> void:
	if GlobalSettings.click_sound_enabled:
		$Background/ToggleSoundButton.text = "Disable Click Sounds"
	else:
		$Background/ToggleSoundButton.text = "Enable Click Sounds"

func _on_toggle_intro_pressed() -> void:
	GlobalSettings.minigame_intros_enabled = not GlobalSettings.minigame_intros_enabled
	_update_intro_display_text()

func _update_intro_display_text() -> void:
	if GlobalSettings.minigame_intros_enabled:
		$Background/ToggleMinigameIntro.text = "Disable Minigame Intros"
	else:
		$Background/ToggleMinigameIntro.text = "Enable Minigame Intros"

func _on_back_pressed() -> void:
	Navigator.go_back()
