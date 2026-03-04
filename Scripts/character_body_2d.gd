extends CharacterBody2D
class_name Player
@export var Board: MainBoard
@export var cell_size : Vector2i
@onready var snap:Vector2i
@onready var turn_label: Label = get_parent().get_node("HUD/HUDBase/MarginContainer/HBoxContainer/HBoxContainer/turn counter")
var initialized:= false
var target
var rng = RandomNumberGenerator.new()
var turn_count:=0
var can_roll := true
var roll:=0
var busy:=false
@export var shop_scene: PackedScene = preload("res://Scenes/UI/shopscreen.tscn")
@export var offer_scene: PackedScene = preload("res://Scenes/UI/ConfirmSwitch.tscn")
@export var asteroid: PackedScene = preload("res://Scenes/Minigames/AsteroidTargeting/AsteroidTargeting1.tscn")

func _ready():
	


	cell_size = Board.get("cell_size")
	snap=cell_size
	rng.randomize()
	var board_size = Vector2i(get_viewport_rect().size)/cell_size
	if playerPos.savedPosition != Vector2.ZERO:
		target = playerPos.savedPosition
		global_position = target
		turn_count = playerPos.savedTurn
	else:
		target = Vector2(0, round(board_size.y/2) * cell_size.y)
		global_position = target
	initialized=true

func roll_and_move(amount: int = 0) -> void:
	if not initialized:
		push_error("roll and move called too early")
		return		
	if not can_roll:
		return
	can_roll = false 
	if(amount==0):
		roll = rng.randi_range(1, 6)
	else:
		roll=amount
	target.x += (roll * cell_size.x)
	global_position = target
	turn_count+=roll
	var shop := _check_shop_box()
	if shop:
		Navigator.go_to_packed_scene(shop_scene)
	var triggered := _is_off_board() or _check_red_box()
	if triggered:
		await _offerGame()
	else:
		MoneySave.add_money(3)

	can_roll = true
	_update_turn_label()
func _unhandled_input(event: InputEvent) -> void:
	if busy:
		return
	if event.is_action_pressed("ui_accept"):
		roll_and_move()
func _open_shop() -> void:
	busy = true
	can_roll = false

	get_tree().paused = true

	var shop := shop_scene.instantiate()
	Board.overlay_root.add_child(shop)

	await shop.closed

	get_tree().paused = false
	can_roll = true
	busy = false
func _update_turn_label() -> void:
	turn_label.text = "Turn: %d | Roll: %d" % [turn_count, roll]
func _is_off_board()->bool:
	var board = get_viewport_rect().size.x
	return target.x >board
func _check_shop_box()->bool:
	for pos in Board.shop_box_positions:
		if target.is_equal_approx(pos):
			
			return true
	return false

func _check_red_box()->bool:

	for pos in Board.red_box_positions:
		if target.is_equal_approx(pos):
			
			return true
	return false

func _process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		
		var random_int = rng.randi_range(1, 6)
		target.x += random_int * snap.x
		global_position = target
		playerPos.savedPosition = global_position
		playerPos.savedTurn = turn_count
		
		_is_off_board()
		_check_red_box()
func _offerGame() -> void:
	busy = true

	var offer := offer_scene.instantiate()
	Board.overlay_root.add_child(offer)
	print("Waiting for offerchoice")
	var play : bool = await offer.choice 
	print("Offer returned:",play)

	if not play:
		busy = false
		return

	
	var mg := asteroid.instantiate() 
	Board.game_root.add_child(mg)



	var result_args : Array = await mg.done
	var result: Dictionary = result_args[0]


	_result(result)
	busy = false
func _result(result: Dictionary) -> void:
	print("Result:", result)
