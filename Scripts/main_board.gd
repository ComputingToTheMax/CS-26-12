extends Node2D

@export var cell_size = Vector2i(64, 64)

var board_size
var red_box_positions = []

var last_roll: int = 0
var roll_label: Label

func _ready() -> void:
	roll_label = Label.new()
	roll_label.position = Vector2(10, 10)
	roll_label.text = "Roll: 0"
	add_child(roll_label)
	initialize_board()
	
func set_dice_result(value: int):
	last_roll = value
	roll_label.text = "Roll: %d" % value

func initialize_board():
	board_size = Vector2i(get_viewport_rect().size) / cell_size

	var mid_y = round(board_size.y / 2) * cell_size.y
	for x in range(board_size.x + 1):
		if x % 4 == 1:
			var pos = Vector2(x * cell_size.x, mid_y)
			red_box_positions.append(pos)
			
			var box = ColorRect.new()
			box.position = pos
			box.size = Vector2(cell_size.x, cell_size.y)
			box.color = Color(1, 0, 0)
			add_child(box)

	_draw()

func _draw():
	var mid_y = round(board_size.y / 2) * cell_size.y
	
	for x in range(board_size.x + 1):
		draw_line(
			Vector2(x * cell_size.x, mid_y),
			Vector2(x * cell_size.x, mid_y + cell_size.y),
			Color.WHITE,
			2.0
		)

	draw_line(
		Vector2(0, mid_y),
		Vector2(board_size.x * cell_size.x, mid_y),
		Color.WHITE,
		2.0
	)

	draw_line(
		Vector2(0, mid_y + cell_size.y),
		Vector2(board_size.x * cell_size.x, mid_y + cell_size.y),
		Color.WHITE,
		2.0
	)
