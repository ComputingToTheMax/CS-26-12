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
#@onready var player_inventory: InventoryModel = Board.get_node("res://Scenes/UI/Inventory.gd")
@export var shop_scene: PackedScene = preload("res://Scenes/UI/shopscreen.tscn")
@export var offer_scene: PackedScene = preload("res://Scenes/UI/ConfirmSwitch.tscn")
@export var asteroid: PackedScene = preload("res://Scenes/Minigames/AsteroidTargeting/AsteroidTargeting1.tscn")
@export var hanger: PackedScene = preload("res://Scenes/Minigames/hanger_madness/hanger_madness.tscn")
@export var alien: PackedScene = preload("res://Scenes/Minigames/alien_communication/alien_communication.tscn")
@onready var inventory_overlay: InventoryOverlay = Board.get_node("Overlay/OverlayRoot/Inventory")
@export var reward_screen: PackedScene = preload("res://Scenes/reward_screen.tscn")

var initialized: bool = false
var rng := RandomNumberGenerator.new()
var spaces_moved_total: int = 0
var can_roll: bool = true
var roll: int = 0
var busy: bool = false
var current_tile_index: int = 0
var turn:int =0
var minigames: Array = []

func _ready():

	cell_size = Board.get("cell_size")
	minigames = [alien, asteroid]
	snap=cell_size
	rng.randomize()

	if Board.get_tile_count() == 0:
		await Board.board_ready

	current_tile_index = 0
	spaces_moved_total = 0
	global_position = Board.get_start_center()

	if camera_node:
		camera_node.enabled = true
		camera_node.position = Vector2.ZERO

	initialized = true
	_update_turn_label()
func _animate_to_tile(tile_index: int, duration: float = 0.2) -> void:
	var destination: Vector2 = Board.get_tile_center(tile_index)

	var tween := create_tween()
	tween.tween_property(self, "global_position", destination, duration) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

	await tween.finished
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
		await _open_shop()
		can_roll = true
		_update_turn_label()
		return

	var destination_index: int = (current_tile_index + roll) % board_count

	spaces_moved_total += roll
	current_tile_index = destination_index

	await _animate_to_tile(current_tile_index, 0.2)

	_update_turn_label()

	var landed_on_shop: bool = Board.is_shop_tile(current_tile_index)
	var landed_on_red: bool = Board.is_red_tile(current_tile_index)

	if landed_on_shop:
		await _open_shop()
	elif landed_on_red:
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

	var shop := shop_scene.instantiate()
	Board.overlay_root.add_child(shop)

	var player_inventory: InventoryModel = $InventoryModel
	var inventory_overlay: InventoryOverlay = Board.get_node("Overlay/OverlayRoot/Inventory")

	shop.setup_shop(player_inventory, inventory_overlay)

	await shop.closed

	can_roll = true
	busy = false
func _update_turn_label() -> void:
	turn_label.text = "Turn: %d | Roll: %d | Tile: %d" % [turn, roll, current_tile_index]
	turn+=1
func _offerGame() -> void:
	busy = true
	var offer := offer_scene.instantiate()
	Board.overlay_root.add_child(offer)
	var play: bool = await offer.choice
	if not play:
		busy = false
		return

	var chosen_game_scene: PackedScene = minigames[rng.randi_range(0, minigames.size() - 1)]
	if chosen_game_scene == null:
		push_error("Chosen minigame scene is null!")
		busy = false
		return

	var mg := chosen_game_scene.instantiate()
	Board.game_root.add_child(mg)

	var result: Dictionary = await mg.done
	await _result(result)

	for child in Board.game_root.get_children():
		child.queue_free()

	busy = false

func _result(result: Dictionary) -> void:
	if result.get("status") == "win":
		await _show_reward_screen()

func _show_reward_screen() -> void:
	var screen := reward_screen.instantiate()
	var player_inventory: InventoryModel = $InventoryModel
	screen.setup(player_inventory)
	Board.game_root.add_child(screen)
	await screen.item_chosen
