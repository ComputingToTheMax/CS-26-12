extends Control

@export var default_minigame_tile_path: String

@onready var game_tile_container = %GameTileContainer
@onready var game_tile_subview_template = %GameTileSubViewTemplate

# Class Variables
var initialized: bool = false

var target_minigame_path:String
var child_game_scenes = []

# A custom initialization function to allow passthrough of parameters during programatic instantiation calls.
func __init(current_tree, target_minigame_path: String) -> void:
	self.target_minigame_path = target_minigame_path
	
	# DEBUG: During direct scene testing, assign a default number of players if a number of players
	#        yet to be set.
	GlobalSettings.ensure_player_configuration_is_set()
		
	# Ensure that the game is visible at the root.
	if get_parent() == current_tree.root:
		print("The game should already be visible at the root, so no further work is required!")
	# If the game is not yet visible, add it to the root.
	else:
		
		current_tree.root.add_child.call_deferred(self)
	
	
	# Remember that the game has now been initialized.
	initialized = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Quick!")
	
	# If initialization of parameters hasn't yet been performed, initialize with default values.
	# This will only work if the current scene has access to the current scene tree.
	# TODO: More robust versions might be able to access the scene tree through a singleton.
	if !initialized:
		push_warning("The __init function of this game stacking handler wasn't called before game launch. This should not happen in a production build. Default values have been provided in the meantime.")
		__init(get_tree(), default_minigame_tile_path)
	
	# Calculate the maximum height of each minigame viewport.
	var viewport_size = GlobalSettings.get_window_size()
	viewport_size.y = (viewport_size.y - (5 * (GlobalSettings.number_of_players - 1))) / GlobalSettings.number_of_players
	#print("Viewport Size:", viewport_size)
	
	print("Instantiating a minigame scene with the following path:\t", target_minigame_path)
	
	for player in GlobalSettings.active_players:
		print("\tCreating Game Tile ", len(child_game_scenes))
		_create_subview(player, viewport_size)
		
	# Request a child to coordinate and begin the game. Any child should be able to launch the game, but the first child is chosen as the default.
	child_game_scenes[0].launch_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_subview(player: GlobalSettings.PlayerConfiguration, viewport_size: Vector2i):
	
	# Create an instance of the target game scene tile.
	var current_instance_of_target_scene = load(target_minigame_path).instantiate()
	#current_instance_of_target_scene.set_process(false)
	#return
	
	# The Subview Version
	## Create an instance of the subview template in which to put the target game tile.
	#var current_subview = game_tile_subview_template.duplicate()
	#current_subview.__init(player)
	#var current_subview_viewport = current_subview.get_node("SubViewport")
	#
	## Set the viewport size.
	#current_subview_viewport.size = viewport_size
	#current_subview_viewport.add_child(current_instance_of_target_scene)
	#
	## Add the current subview to the working scene tree.
	#game_tile_container.add_child(current_subview)
	
	# The Direct Control Node Version
	game_tile_container.add_child(current_instance_of_target_scene)
	
	# This is crucial! Only initialize the target scene after it has been added, so that it's "_ready"
	# function has been run properly.
	print("Initializing with player:", player)
	#current_instance_of_target_scene.__init(player, viewport_size)
	current_instance_of_target_scene.__init(player)
	
	# Make the current subview visible.
	#current_subview.visible = true
	
	child_game_scenes.append(current_instance_of_target_scene)
