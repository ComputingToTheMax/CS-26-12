extends Control

@export var target_scene:PackedScene

@onready var subview_template = $SubViewTemplate
@onready var subview_parent = $VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for player in GlobalSettings.active_players:
		_create_subview(player)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_subview(player: GlobalSettings.PlayerConfiguration):
	var current_subview = subview_template.duplicate()
	current_subview.player = player
	var current_subview_viewport = current_subview.get_node("SubViewport")
	
	current_subview.visible = true
	
	subview_parent.add_child(current_subview)
