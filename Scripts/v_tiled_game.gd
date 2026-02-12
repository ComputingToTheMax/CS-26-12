extends Control

@export var target_scene:PackedScene

@onready var subview_template = $SubViewTemplate
@onready var subview_parent = $VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in range(0, GlobalSettings.get_number_of_active_players()):
		_create_subview()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_subview():
	var current_subview = subview_template.duplicate()
	var current_subview_viewport = current_subview.get_node("SubViewport")
	
	current_subview.visible = true
	
	subview_parent.add_child(current_subview)
