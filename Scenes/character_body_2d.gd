extends CharacterBody2D

@onready var snap = get_parent().cell_size
var target
var rng = RandomNumberGenerator.new()

func _ready():
	var cell_size = get_parent().cell_size
	var board_size = Vector2i(get_viewport_rect().size)/cell_size
	target = Vector2(0, round(board_size.y/2) * cell_size.y)
	global_position = target

func _is_off_board():
	var board = get_viewport_rect().size
	if target.x > board.x:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

func _check_red_box():
	var red_positions = get_parent().red_box_positions
	for pos in red_positions:
		if target.is_equal_approx(pos):
			get_tree().change_scene_to_file("res://Scenes/Minigames/hanger_madness.tscn")
			return

func _process(event):
	if Input.is_action_just_pressed("ui_accept"):
		rng.randomize()
		var random_int = rng.randi_range(1, 6)
		get_parent().set_dice_result(random_int)
		target.x += random_int * snap.x
		global_position = target
		
		_is_off_board()
		_check_red_box()
