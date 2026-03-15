extends Node2D
signal done(result)

@onready var spaceship: Sprite2D = $Spaceship
@onready var label: Label = $Label

var rng := RandomNumberGenerator.new()

var current_ship := 0
var correct_count := 0

var ship_targets: Array[int] = [] # dock numbers (1–3)
var dock_color: Array[String] = ["red dock", "green dock", "blue dock"]
var clues := [
	"If your spaceship is triangular shaped then it goes into the ",
	"If your spaceship has 2 shades of green then it goes into the ",
	"If your spaceship has a circular top then it goes into the ",
	"If your spaceship has less than three colors then it goes into the ",
	"If your spaceship has purple then it goes into the "
]

func _ready() -> void:
	rng.randomize()

	for i in range(5):
		ship_targets.append(rng.randi_range(1, 3))

	update_label()

	load_ship()


func load_ship() -> void:
	if current_ship >= 5:
		var result := {"status":"done", "score":5}
		emit_signal("done", result)

	spaceship.set_ship(current_ship, ship_targets[current_ship])


func ship_correct() -> void:
	correct_count += 1
	current_ship += 1
	update_label()
	load_ship()

func _draw():
	var board_size = Vector2i(get_viewport_rect().size)
	draw_rect(Rect2(board_size[0]-50, 0, 50, board_size[1]/3), Color(1.0, 0.0, 0.0, 1.0))
	draw_rect(Rect2(board_size[0]-50, board_size[1]/3, 50, board_size[1]/3), Color(0.0, 1.0, 0.0, 1.0))
	draw_rect(Rect2(board_size[0]-50, board_size[1]*2/3, 50, board_size[1]/3), Color(0.0, 0.0, 1.0, 1.0))

func update_label() -> void:
	var all_text := "Get five spaceships into their correct docks to pass the minigame\nCurrently you have completed %d ships\n" % correct_count
	for i in range(5):
		all_text += "Ship %d: %s%s\n" % [i + 1, clues[i], dock_color[ship_targets[i]-1]]
	label.text = all_text
