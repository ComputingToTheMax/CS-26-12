extends "res://addons/gut/test.gd"

const SCENE_PATH := "res://StartScreen.tscn"

var start_scene
var root

func before_each():
	start_scene = load(SCENE_PATH)
	assert_not_null(start_scene, "StartScreen.tscn failed to load")

	root = start_scene.instantiate()
	add_child(root)
	assert_not_null(root, "Failed to instantiate StartScreen scene")


func after_each():
	if root and root.get_parent():
		root.get_parent().remove_child(root)
	root = null
	start_scene = null


# ---------------------------------------------------------
# BASIC LOAD TEST
# ---------------------------------------------------------
func test_scene_loads():
	assert_not_null(root, "Start screen root should not be null")


# ---------------------------------------------------------
# NODE EXISTENCE TESTS
# ---------------------------------------------------------
func test_scene_has_background():
	var bg = root.get_node_or_null("Background")
	assert_not_null(bg, "Background node missing")


func test_scene_has_play_button():
	var btn = root.get_node_or_null("PlayButton")
	assert_not_null(btn, "PlayButton missing")


func test_scene_has_settings_button():
	var btn = root.get_node_or_null("Background/SettingsButton")
	assert_not_null(btn, "SettingsButton missing")


func test_scene_has_character():
	var char = root.get_node_or_null("Character")
	assert_not_null(char, "Character node missing")


# ---------------------------------------------------------
# SIGNAL CONNECTION TESTS
# ---------------------------------------------------------
func test_play_button_has_signal_connected():
	var btn = root.get_node_or_null("PlayButton")
	assert_not_null(btn)
	assert_true(btn.pressed.is_connected(root._on_play_pressed), "Play button should connect to _on_play_pressed")


func test_settings_button_has_signal_connected():
	var btn = root.get_node_or_null("Background/SettingsButton")
	assert_not_null(btn)
	assert_true(btn.pressed.is_connected(root._on_settings_pressed), "Settings button should connect to _on_settings_pressed")


func test_optional_psyche_button_if_exists():
	var btn = root.get_node_or_null("Background/PsycheButton")
	if btn:
		assert_true(btn.pressed.is_connected(root._on_external_link_pressed), "PsycheButton exists but isn't connected")
	else:
		assert_true(true, "PsycheButton optional and not present")
