extends GutTest

var scene_path := "res://StartScreen.tscn"

func before_each():
    var scene := load(scene_path)
    self.scene_instance = scene.instantiate()

func after_each():
    self.scene_instance.queue_free()

func test_background_texture_loaded():
    var bg := scene_instance.get_node("Background")
    assert_not_null(bg.texture, "Background texture not assigned")

func test_character_texture_loaded():
    var char := scene_instance.get_node("Character")
    assert_not_null(char.texture, "Character texture not assigned")

func test_background_position():
    var bg := scene_instance.get_node("Background")
    assert_eq(bg.position, Vector2(640, 360), "Background position incorrect")

func test_character_position():
    var char := scene_instance.get_node("Character")
    assert_eq(char.position, Vector2(640, 400), "Character position incorrect")
