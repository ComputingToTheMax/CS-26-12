extends Control

@export var default_minigame_path: String
var target_minigame_path:String

@onready var subview_template = $SubViewTemplate
@onready var subview_parent = $VBoxContainer

func __init(target_minigame_path: String) -> void:
	self.target_minigame_path = target_minigame_path
	
	print(default_minigame_path, target_minigame_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for player in GlobalSettings.active_players:
		print("Creating subview!")
		_create_subview(player)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_subview(player: GlobalSettings.PlayerConfiguration):
	
	print("PATH!", target_minigame_path)
	var current_instance_of_target_scene = load(target_minigame_path).instantiate()
	
	var current_subview = subview_template.duplicate()
	current_subview.__init(player)
	var current_subview_viewport = current_subview.get_node("SubViewport")
	
	current_subview_viewport.add_child(current_instance_of_target_scene)
	
	# Finish by making the current subview visible and adding it into the working tree.
	current_subview.visible = true
	subview_parent.add_child(current_subview)
