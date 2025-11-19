extends GutTest

var scene_path := "res://StartScreen.tscn"

func before_each():
    var scene := load(scene_path)
    self.scene_instance = scene.instantiate()
    self.scene_instance._ready() # Ensure script runs

func after_each():
    self.scene_instance.queue_free()

func test_play_button_is_disabled():
    var btn := scene_instance.get_node("PlayButton")
    assert_true(btn.disabled, "PlayButton should be disabled on _ready()")
