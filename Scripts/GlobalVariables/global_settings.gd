extends Node

# Public Global Settings Variables

var number_of_players : int

# Classes and Structures
class PlayerConfiguration:
	
	# Displayed Player ID Number
	var id:int
	
	# A Hexadecimal Player Color
	var color: String
	
	# Individual characters representing a player's buttons
	var button_one: String
	var button_two: String
	
	var shape:player_shapes
	

	


# Setup and Configuration

static var current_player_index = 0
static var players:Array[PlayerConfiguration] = []

const ALL_PLAYER_COLORS = ["#0C6E9E", "#E76F51", "#33673B", "#8B426A"]

const COMMON_BUTTON_COMBINATIONS = [["Q", "W"], ["O", "P"], ["Z", "X"], ["N", "M"]]

enum player_shapes {Square, Circle, Triangle, Pentagon}

static var player_colors = ALL_PLAYER_COLORS.duplicate_deep()

#

static var global_settings_instance = null

# Automatically delete new instances of global settings if a single instance already exists.
func _init() -> void:
	if global_settings_instance == null:
		global_settings_instance = self
	else:
		printerr("Oops,it looks like something unexpectedly tried to create a copy of the global settings. This isn't supported at the moment, so the copy will be deleted.")
		queue_free()
		
		
# Methods
func create_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
