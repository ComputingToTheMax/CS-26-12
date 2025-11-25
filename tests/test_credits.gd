extends GutTest

var scenePath: String = "res://Credits.tscn"
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

func test_return_button_exists():
	var btn := sceneInstance.find_child("ReturnButton", true, false)
	assert_not_null(btn, "ReturnButton missing")
	assert_true(btn is Button, "ReturnButton is not a Button")
