extends CharacterBody2D

@onready var snap = get_parent().cell_size

var target
var rng = RandomNumberGenerator.new()

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
	if Input.is_action_just_pressed("ui_accept"):
		rng.randomize()
		var random_int = rng.randi_range(1, 6)
		
		target.x += random_int*snap.x
		global_position = target
		_is_off_board();
