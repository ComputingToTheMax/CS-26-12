extends Node2D

@export var cell_size = Vector2i(64, 64)

var astar_board = AStarGrid2D.new()
var board_size
func _ready():
	initialize_board()

func initialize_board():
	board_size = Vector2i(get_viewport_rect().size)/cell_size
	astar_board.size = board_size
	astar_board.cell_size = cell_size
	astar_board.offset = cell_size/2
	astar_board.update()

func _draw():
	draw_board()

func draw_board():
	for x in range(board_size.x + 1):
		draw_line(
			Vector2(x * cell_size.x, round(board_size.y/2) * cell_size.y),
			Vector2(x * cell_size.x, round(board_size.y/2) * cell_size.y + cell_size.y),
			Color.WHITE,
			2.0		
		)
	draw_line(
		Vector2(0, round(board_size.y/2) * cell_size.y),
		Vector2(board_size.x * cell_size.x, round(board_size.y/2) * cell_size.y),
		Color.WHITE,
		2.0			
	)
	draw_line(
		Vector2(0, round(board_size.y/2) * cell_size.y + cell_size.y),
		Vector2(board_size.x * cell_size.x, round(board_size.y/2) * cell_size.y + cell_size.y),
		Color.WHITE,
		2.0		
	)		
