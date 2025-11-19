extends GutTest

var scenePath: String = "res://StartScreen.tscn"
var sceneInstance: Node = null

func before_each() -> void:
	var scene: PackedScene = load(scenePath)
	assert_not_null(scene, "Scene failed to load")
	sceneInstance = scene.instantiate()
	assert_not_null(sceneInstance, "Scene failed to instantiate")

func after_each() -> void:
	if sceneInstance:
		sceneInstance.queue_free()

func test_scene_has_background() -> void:
	var node: Node = sceneInstance.get_node("Background")
	assert_not_null(node, "Background node missing")
	assert_true(node is Sprite2D, "Background is not Sprite2D")

func test_scene_has_character() -> void:
	var node: Node = sceneInstance.get_node("Character")
	assert_not_null(node, "Character node missing")
	assert_true(node is Sprite2D, "Character is not Sprite2D")

func test_scene_has_play_button() -> void:
	var node: Node = sceneInstance.get_node("PlayButton")
	assert_not_null(node, "PlayButton node missing")
	assert_true(node is Button, "PlayButton is not a Button")
