extends Control

@export var default_minigame_path: String
var target_minigame_path:String

@onready var subview_template = $SubViewTemplate
@onready var subview_parent = $CenterContainer/VBoxContainer

var child_game_scenes = []

func __init(target_minigame_path: String) -> void:
	self.target_minigame_path = target_minigame_path
	
	print(default_minigame_path, target_minigame_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Calculate the maximum height of each minigame viewport.
	var viewport_size = GlobalSettings.get_window_size()
	viewport_size.y = (viewport_size.y - (5 * (GlobalSettings.number_of_players - 1))) / GlobalSettings.number_of_players
	
	#print("Viewport Size:", viewport_size)
	
	for player in GlobalSettings.active_players:
		#print("Creating subview!")
		_create_subview(player, viewport_size)
		
		
	# Request a child to begin the game. Any child should be able to launch the game, but the first child is chosen as the default.
	child_game_scenes[0].launch_game()
		
	print("Instantiating a minigame scene with the following path:\t", target_minigame_path)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_subview(player: GlobalSettings.PlayerConfiguration, viewport_size: Vector2i):
	
	var current_instance_of_target_scene = load(target_minigame_path).instantiate()
	
	var current_subview = subview_template.duplicate()
	current_subview.__init(player)
	var current_subview_viewport = current_subview.get_node("SubViewport")
	
	current_subview_viewport.size = viewport_size
	current_subview_viewport.add_child(current_instance_of_target_scene)
	
	# Add the current subview to the working scene tree.
	subview_parent.add_child(current_subview)
	
	# This is crucial! Only initialize the target scene after it has been added, so that it's "_ready"
	# function has been run properly.
	current_instance_of_target_scene.__init(player, viewport_size)
	
	# Make the current subview visible.
	current_subview.visible = true
	
	child_game_scenes.append(current_instance_of_target_scene)
