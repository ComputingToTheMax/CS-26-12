extends HBoxContainer

@export var player: Node
@onready var roll: Button = $roll
@onready var roll1: Button = $roll1

func _ready() -> void:
	if player == null:
		push_error("Roll UI: player is not assigned.")
		return

	if not player.has_method("roll_and_move"):
		push_error("Roll UI: assigned node '%s' does not have roll_and_move(). You likely dragged the wrong node." % player.name)
		return
	roll.pressed.connect(_on_pressed)
	roll1.pressed.connect(_on_one_pressed)

func _on_pressed() -> void:
	player.roll_and_move()
func _on_one_pressed()->void:
	player.roll_and_move(1)
