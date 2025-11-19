extends GutTest

var scene_path := "res://StartScreen.tscn"

func before_each():
    var scene := load(scene_path)
    assert_not_null(scene, "Scene failed to load")
    self.scene_instance = scene.instantiate()

func after_each():
    self.scene_instance.queue_free()

func test_scene_has_background():
    var node := scene_instance.get_node("Background")
    assert_not_null(node, "Background node missing")
    assert_true(node is Sprite2D, "Background is not Sprite2D")

func test_scene_has_character():
    var node := scene_instance.get_node("Character")
    assert_not_null(node, "Character node missing")
    assert_true(node is Sprite2D, "Character is not Sprite2D")

func test_scene_has_play_button():
    var node := scene_instance.get_node("PlayButton")
    assert_not_null(node, "PlayButton node missing")
    assert_true(node is Button, "PlayButton is not a Button")
