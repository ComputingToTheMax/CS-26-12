extends Node

# Public Global Settings Variables

#
# Game Settings
#
static var click_sound_enabled: bool = true
static var default_background:String = "res://Sources/Images/SpaceBackgroundPlain.jpeg"


#
# Game State
#

#
# Helper Functions
#

# Returns, width, height
static func get_window_size(screen=0) -> Vector2i:
	return DisplayServer.window_get_size_with_decorations(screen)



#
# Player Settings and State
#

# Classes and Structures
class PlayerConfiguration:
	
	static func select_button():
		var selected_button = null
		
		var i = 0
		while !selected_button:
			
			var current_suggested_button = COMMON_BUTTON_COMBINATIONS[GlobalSettings.number_of_players][i]
			
			# If we've gone through the common and recommended button combinations, start picking random letters.
			if i >= len(COMMON_BUTTON_COMBINATIONS[GlobalSettings.number_of_players]):
				current_suggested_button = ALL_BUTTONS[randi_range(0, len(ALL_BUTTONS) - 1)]
				
			
			if !GlobalSettings.check_if_button_in_use(current_suggested_button):
				selected_button = current_suggested_button
			else:
				i += 1
				
				
		GlobalSettings.used_buttons.append(selected_button)
				
		return selected_button
		
	func get_action_name(button_index:int):
		var action_name: String = "Player" + str(self.id) + "Key" + str(button_index)
		return action_name
		
	func update_button_keycode(button_index:int):
		
		# Action (Named with a String) -> Multiple InputEvents/InputEventKeys can be registered.
		# This mirrors the structure of manually created events using the graphical user interface under Project > Project Settings > Input Map.
		
		var action_name: String = get_action_name(button_index)
		
		# TODO: Determine if you truly do have to erase and re-add the input map each time you update a keycode.
		var previous_input_event = self.button_inputevents[button_index]
		if InputMap.has_action(action_name) and InputMap.action_has_event(action_name, previous_input_event):
			InputMap.action_erase_event(action_name, previous_input_event)
		
		# This would erase the entire action. (And likely, all associated events?)
		# InputMap.erase_action(action_name)
		
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		
		self.button_inputevents[button_index].keycode = OS.find_keycode_from_string(self.buttons[button_index])
		InputMap.action_add_event(action_name, button_inputevents[button_index])	
		
	
	# Displayed Player ID Number
	var id:int
	
	# A Hexadecimal Player Color
	var color: String
	
	# Individual characters representing a player's buttons
	var buttons: Array[String] = []
	var button_inputevents: Array[InputEventKey] = [] # Events can be referenced by: Player[ID]Key[KeyIndex], such as "Player0Key0"
	
	var shape:player_shapes
	
	func _init(id, color=null, button_one=null, button_two=null, shape=null):
		
		self.id = id
		
		if !color:
			self.color=ALL_PLAYER_COLORS[GlobalSettings.number_of_players]
				
		# Register InputMaps for the selected buttons.
		for button_index in range(GlobalSettings.PLAYER_BUTTON_COUNT):
			buttons.append(select_button())
			button_inputevents.append(InputEventKey.new())
			
			update_button_keycode(button_index)
		
		
		print("Player ID %s created!\n\tButtons: %s" % [self.id, self.buttons])

	


# Setup and Configuration

static var number_of_players = 0
static var next_player_id = 0
const PLAYER_BUTTON_COUNT = 2
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
	var new_player = PlayerConfiguration.new(next_player_id)
	next_player_id += 1
	
	players.append(new_player)
	active_players.append(new_player)
	number_of_players += 1
	
static func _player_id_in_bounds_check(id):
	if (id < 0) or (id > players.size() - 1):
		push_error("Oops, an out-of-bounds player ID of %s was accessed when only %s players exist. Player IDs are 0-indexed." % [id, players.size()])

static func activate_player(id):
	_player_id_in_bounds_check(id)
	if not (players[id] in active_players):
		active_players.append(players[id])

# Assumption: Player indices are unique; the first id match will be removed from the active players list.
static func deactivate_player(id):
	_player_id_in_bounds_check(id)
	for index in range(active_players.size()):
		if active_players[index].id == id:
			active_players.remove_at(index)
			return true
	
	return false
	
static func set_number_of_players(new_number_of_players:int):	
	while players.size() < new_number_of_players:
		GlobalSettings.create_player()
		
	number_of_players = new_number_of_players
		
static func get_number_of_active_players() -> int:
	return len(active_players)
	
static func get_player_by_id(id:int) -> PlayerConfiguration:
	_player_id_in_bounds_check(id)
	return players[id]
		
static func check_if_button_in_use(button_letter:String):
	return (button_letter in GlobalSettings.used_buttons)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
