extends Node2D

@export var target_game_tile_scene_path: String

@export var stacking_organizing_scene_path: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var loaded_handler = load(stacking_organizing_scene_path).instantiate()
	loaded_handler.__init(get_tree(), target_game_tile_scene_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
