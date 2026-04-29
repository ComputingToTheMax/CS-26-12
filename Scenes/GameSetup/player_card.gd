extends VBoxContainer

#
# Code Handling Card Creation
#

@onready var card_background = %CardBackground
@onready var card_foreground = %CardForeground

static var card_number:int = 0

const CARDS_TO_COLORS = {
	0: "res://Scenes/GameSetup/Images/BluePlayerSelect.svg",
	1: "res://Scenes/GameSetup/Images/RedPlayerSelect.svg",
	2: "res://Scenes/GameSetup/Images/GreenPlayerSelect.svg",
	3: "res://Scenes/GameSetup/Images/PurplePlayerSelect.svg"
}

func _set_texture_rect_texture_from_image_path(image_path, target_texture_rect):
	var target_image = Image.load_from_file(image_path)
	var target_texture = ImageTexture.create_from_image(target_image)
	
	target_texture_rect.texture = target_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Each instantiated card should have it's own color. If necessary, repeat colors.
	var target_image_path:String = CARDS_TO_COLORS[card_number % 4]
	_set_texture_rect_texture_from_image_path(target_image_path, card_background)
	card_number += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
#	
# Code Handling Card Interactions
#

@onready var coin_slot = %CoinSlot
func _coin_inserted():
	pass
	
