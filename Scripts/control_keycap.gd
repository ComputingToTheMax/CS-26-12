extends Node2D

# How to use:
# - Import a copy of this scene into the place you would like your keycap.
# - Set the keycap properties expored to the Godot editor.

@export
var unpressed_keycap: Texture2D
@export
var pressed_keycap: Texture2D

@export
var key_character: String = "∅"
@export
var blink_delay: float = 0.3
#@export
## Update the presented keycap value if it is changed after instantiation.
#var watch_for_hot_updates = true

@onready
var key_sprite = $Key

var pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
#	# Configure Interface-set Defaults
	$Key/KeyCharacter.text = key_character
	key_sprite.texture = unpressed_keycap
	
	$BlinkTimer.wait_time = blink_delay

func flip_state() -> void:
	if pressed:
		key_sprite.texture = unpressed_keycap
		pressed = false
	else:
		key_sprite.texture = pressed_keycap
		pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Key/KeyCharacter.text = key_character
