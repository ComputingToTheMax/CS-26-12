extends GutTest

var scenePath: String = "res://StartScreen.tscn"
var sceneInstance: Node = null

func before_each() -> void:
    var scene: PackedScene = load(scenePath)
    assert_not_null(scene, "Scene failed to load")
    sceneInstance = scene.instantiate()
    assert_not_null(sceneInstance, "Scene failed to instantiate")

    # Force ready on all children so scripts initialize
    sceneInstance.propagate_call("_ready")

func after_each() -> void:
    if sceneInstance:
        sceneInstance.queue_free()

func test_play_button_is_disabled() -> void:
    var btn: Button = sceneInstance.get_node("PlayButton")
    assert_not_null(btn, "PlayButton node missing")
    assert_true(btn.disabled, "PlayButton should be disabled on _ready()")
