extends Node2D

@export var cell_size = Vector2i(64, 64)

var board_size
var red_box_positions = []

func _ready() -> void:
	
	initialize_board()

func initialize_board():
	board_size = Vector2i(get_viewport_rect().size) / cell_size

	var mid_y = round(board_size.y / 2) * cell_size.y
	for x in range(board_size.x + 1):
		if x % 2 == 1:
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
	
	# Vertical lines
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
