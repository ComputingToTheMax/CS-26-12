extends Button

@export var player_path: NodePath
@onready var player: CharacterBody2D = get_node(player_path)

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	player.roll_and_move()
