extends MarginContainer

@onready var add_player_text = $AddPlayer
@onready var player_number_text = $PlayerNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_card_text():
	print("Toggle Called!")
	if add_player_text.visible:
		print("Switch!")
		add_player_text.hide()
		player_number_text.show()
	else:
		print("Nope!")
		add_player_text.show()
		player_number_text.hide()
