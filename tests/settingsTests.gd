extends GutTest

var scenePath: String = "res://Settings_Screen.tscn"
var sceneInstance: Node = null

func before_each() -> void:
	var scene: PackedScene = load(scenePath)
	assert_not_null(scene, "Scene failed to load")
	sceneInstance = scene.instantiate()
	assert_not_null(sceneInstance, "Scene failed to instantiate")

func after_each() -> void:
	if sceneInstance:
		sceneInstance.queue_free()

func test_scene_loads():
	assert_not_null(sceneInstance)

func test_sound_slider_exists():
	var slider := sceneInstance.find_child("SoundSlider", true, false)
	assert_not_null(slider, "SoundSlider missing")
	assert_true(slider is Slider, "SoundSlider is not a Slider")

func test_back_button_exists():
	var btn := sceneInstance.find_child("BackButton", true, false)
	assert_not_null(btn, "BackButton missing")
	assert_true(btn is Button, "BackButton is not a Button")
