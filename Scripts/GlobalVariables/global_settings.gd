extends Node

# Public Global Settings Variables

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
	
	func __init__(id, color=null, button_one=null, button_two=null, shape=null):
		self.id = id
		
		if !color:
			self.color=ALL_PLAYER_COLORS[GlobalSettings.number_of_players]
			
		var i = 0
		while !button_one:
			
			var current_suggested_button = COMMON_BUTTON_COMBINATIONS[GlobalSettings.number_of_players][i]
			
			# If we've gone through the common and recommended button combinations, start picking random letters.
			if i >= len(COMMON_BUTTON_COMBINATIONS[GlobalSettings.number_of_players]):
				current_suggested_button = ALL_BUTTONS[randi_range(0, len(ALL_BUTTONS) - 1)]
				
			
			if !GlobalSettings.check_if_button_in_use(current_suggested_button):
				button_one = current_suggested_button
			else:
				i += 1
		
	

	


# Setup and Configuration

static var number_of_players = 0
static var players:Array[PlayerConfiguration] = []
static var active_players:Array[PlayerConfiguration] = []

const ALL_PLAYER_COLORS = ["#0C6E9E", "#E76F51", "#33673B", "#8B426A"]

const ALL_BUTTONS = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
const COMMON_BUTTON_COMBINATIONS = [["Q", "W", "E", "R", "A", "S", "D", "F"], ["O", "P", "I", "U", "L", "K", "J", "H"], ["Z", "X", "C", "V", "A", "S", "D", "F"], ["N", "M", "B", "V", "L", "K", "J", "H", "G"]]
static var used_buttons = []

enum player_shapes {Square, Circle, Triangle, Pentagon}

static var player_colors = ALL_PLAYER_COLORS.duplicate(true)

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
static func create_player():
	var new_player = PlayerConfiguration.new()
	players.append(new_player)
	number_of_players += 1
	
static func set_number_of_players(new_number_of_players:int):
	number_of_players = new_number_of_players
	
	while len(players) < new_number_of_players:
		create_player()
		
static func get_number_of_active_players() -> int:
	return len(active_players)
	
static func check_if_button_in_use(button_letter:String):
	return (button_letter in GlobalSettings.used_buttons)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
