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

func test_background_texture_loaded() -> void:
    var bg: Sprite2D = sceneInstance.get_node("Background")
    assert_not_null(bg, "Background node missing")
    assert_not_null(bg.texture, "Background texture not assigned")

func test_background_position() -> void:
    var bg: Sprite2D = sceneInstance.get_node("Background")
    assert_not_null(bg, "Background node missing")
    assert_eq(bg.position, Vector2(640, 360), "Background position incorrect")

func test_character_position() -> void:
    var char: Sprite2D = sceneInstance.get_node("Character")
    assert_not_null(char, "Character node missing")
    assert_eq(char.position, Vector2(640, 400), "Character position incorrect")
