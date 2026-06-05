extends Node2D

signal done(result: Dictionary)

@export var target_game_tile_scene_path: String
@export var stacking_organizing_scene_path: String

var game_handler


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	game_handler = load(stacking_organizing_scene_path).instantiate()
	
	game_handler.game_done.connect(_propagate_game_done_signal)
	
	game_handler.__init(get_tree(), target_game_tile_scene_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _propagate_game_done_signal(result: Dictionary):

	print("Exiting the Genesis Solar Wind Minigame!")
	#game_handler.queue_free()
	done.emit(result)
	queue_free()
