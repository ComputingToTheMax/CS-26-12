extends HBoxContainer

@onready var spacer_template = $Spacer
@onready var player_card_template = $PlayerCardScene

var _current_player_card_number = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(GlobalSettings.current_maximum_number_of_players - 1):
		add_child(create_player_card())


func create_player_card():
	var current_card = VBoxContainer.new()
	
	if _current_player_card_number % 2 == 0:
		var current_spacer = spacer_template.duplicate()
		current_spacer.show()
		current_card.add_child(current_spacer)
		
	var current_card_scene = player_card_template.duplicate()
	current_card_scene.show()
	current_card.add_child(current_card_scene)
	
	if _current_player_card_number % 2 != 0:
		var current_spacer = spacer_template.duplicate()
		current_spacer.show()
		current_card.add_child(current_spacer)
		
	_current_player_card_number += 1
	
	return current_card
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
