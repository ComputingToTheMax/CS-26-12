extends Node2D

@onready var spaceship: Sprite2D = $Spaceship
@onready var label: Label = $Label

var rng := RandomNumberGenerator.new()

var current_ship := 0
var correct_count := 0

var ship_targets: Array[int] = [] # dock numbers (1–3)

var clues := [
	"If your spaceship is triangular shaped then it goes into dock ",
	"If your spaceship has 2 shades of green then it goes into dock ",
	"If your spaceship has a circular top then it goes into dock ",
	"If your spaceship has less than three colors then it goes into dock ",
	"If your spaceship has purple then it goes into dock "
]

func _ready() -> void:
	rng.randomize()

	for i in range(5):
		ship_targets.append(rng.randi_range(1, 3))

	update_label()

	load_ship()


func load_ship() -> void:
	if current_ship >= 5:
		get_tree().change_scene_to_file("res://Scenes/main_board.tscn")
		return

	spaceship.set_ship(current_ship, ship_targets[current_ship])


func ship_correct() -> void:
	correct_count += 1
	current_ship += 1
	load_ship()


func update_label() -> void:
	var all_text := ""
	for i in range(5):
		all_text += "Ship %d: %s%d\n" % [i + 1, clues[i], ship_targets[i]]
	label.text = all_text
