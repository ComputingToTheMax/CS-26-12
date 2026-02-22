extends Control

@export
var child_minigame_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSettings.number_of_players = 4
	print(GlobalSettings.number_of_players)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
