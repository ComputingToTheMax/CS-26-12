extends CharacterBody2D

@onready var snap = get_parent().cell_size

var target

func _ready():
	var cell_size = get_parent().cell_size
	var board_size = Vector2i(get_viewport_rect().size)/cell_size
	target = Vector2(
		round(cell_size.y/2),
		round(board_size.y / 2) * cell_size.y
	)
	global_position = target

func _is_off_board():
	var board = get_viewport_rect().size
	if target.x > board.x:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
		
func _process(event):
	if Input.is_key_pressed(KEY_RIGHT):
		target.x += snap.x
		global_position = target
		_is_off_board();
