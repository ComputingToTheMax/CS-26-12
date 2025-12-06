extends GutTest

var scenePath: String = "res://Scenes/disclaimer.tscn"
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

func test_background_sprite_exists():
	var sprite := sceneInstance.find_child("SpaceBackgroundPlain", true, false)
	assert_not_null(sprite, "SpaceBackgroundPlain sprite missing")
	assert_true(sprite is Sprite2D, "SpaceBackgroundPlain is not a Sprite2D")

func test_rich_text_label_exists():
	var label := sceneInstance.find_child("RichTextLabel", true, false)
	assert_not_null(label, "RichTextLabel missing")
	assert_true(label is RichTextLabel, "RichTextLabel is not a RichTextLabel")
