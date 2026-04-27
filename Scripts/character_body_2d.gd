extends CharacterBody2D
class_name Player

const MAX_BOARD_ITERATIONS: int = 15

@export var Board: MainBoard
@export var cell_size: Vector2i

@onready var turn_label: Label = get_parent().get_node("HUD/HUDBase/MarginContainer/HBoxContainer/HBoxContainer/turn counter")
@onready var inventory_overlay: InventoryOverlay = Board.get_node("Overlay/OverlayRoot/Inventory")
@onready var camera_node: Camera2D = $Camera2D

@export var shop_scene: PackedScene = preload("res://Scenes/UI/shopscreen.tscn")
@export var offer_scene: PackedScene = preload("res://Scenes/UI/ConfirmSwitch.tscn")
@export var asteroid: PackedScene = preload("res://Scenes/Minigames/AsteroidTargeting/AsteroidTargeting1.tscn")
@export var alien: PackedScene = preload("res://Scenes/Minigames/alien_communication/alien_communication.tscn")
@export var reward_screen: PackedScene = preload("res://Scenes/reward_screen.tscn")

var initialized: bool = false
var rng := RandomNumberGenerator.new()
var spaces_moved_total: int = 0
var can_roll: bool = true
var roll: int = 0
var busy: bool = false
var current_tile_index: int = 0
var turn: int = 0
var minigames: Array[PackedScene] = []
var ending_triggered: bool = false
var active_offer: Control = null
func _ready() -> void:
	if Board == null:
		push_error("Player Board reference is missing.")
		return
	if offer_scene == null:
		offer_scene = preload("res://Scenes/UI/ConfirmSwitch.tscn")
	cell_size = Board.cell_size
	minigames.clear()

	rng.randomize()
	_configure_minigames()


	if Board.has_method("get_total_drawn_tile_count"):
		if Board.get_total_drawn_tile_count() == 0:
			await Board.board_ready
	elif Board.get_tile_count() == 0:
		await Board.board_ready

	await get_tree().process_frame

	current_tile_index = 0
	spaces_moved_total = 0
	global_position = Board.get_start_center()

	if camera_node:
		camera_node.enabled = true
		camera_node.position = Vector2.ZERO

	initialized = true
	_update_turn_label()

func _animate_to_tile(tile_index: int, duration: float = 0.2) -> void:
	var destination: Vector2 = Board.get_tile_center_global(tile_index) if Board.has_method("get_tile_center_global") else Board.get_tile_center(tile_index)

	var tween := create_tween()
	tween.tween_property(self, "global_position", destination, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await tween.finished

func roll_and_move(amount: int = 0) -> void:
	if not initialized:
		push_error("roll_and_move called too early")
		return

	if not can_roll or busy or ending_triggered:
		return

	can_roll = false
	busy = true

	roll = rng.randi_range(1, 6) if amount == 0 else amount

	var steps_remaining: int = roll

	while steps_remaining > 0:
		var next_tile_index: int = Board.get_next_tile_index(current_tile_index)

		if next_tile_index == current_tile_index:
			if Board.should_show_path_choice(current_tile_index):
				await Board.request_branch_choice(current_tile_index)
				next_tile_index = Board.get_next_tile_index(current_tile_index)
			else:
				break

		if next_tile_index == current_tile_index:
			break

		current_tile_index = next_tile_index
		spaces_moved_total += 1
		steps_remaining -= 1


		if Board.should_show_path_choice(current_tile_index):
			await Board.request_branch_choice(current_tile_index)
	await _animate_to_tile(current_tile_index, 0.2)

	_update_turn_label()

	if _has_reached_iteration_limit():
		_trigger_credits_end()
		return


	if Board.is_shop_tile(current_tile_index):
		await _open_shop()
	elif Board.is_red_tile(current_tile_index):
		await _offer_game()
	else:
		MoneySave.add_money(3)

	can_roll = true
	busy = false
func _unhandled_input(event: InputEvent) -> void:
	if busy or ending_triggered:
		return

	if event.is_action_pressed("ui_accept"):
		roll_and_move()

func _open_shop() -> void:
	busy = true
	can_roll = false
	if shop_scene == null:
		shop_scene = load("res://Scenes/UI/shopscreen.tscn")

	if shop_scene == null:
		push_error("shop_scene is not assigned and could not be loaded.")
		busy = false
		can_roll = true
		return
	if Board.overlay_root != null:
		Board.overlay_root.visible = true

	var shop := shop_scene.instantiate()
	Board.overlay_root.add_child(shop)

	var player_inventory: InventoryModel = $InventoryModel
	var overlay: InventoryOverlay = Board.get_node("Overlay/OverlayRoot/Inventory")

	shop.setup_shop(player_inventory, overlay)

	await shop.closed

	if ending_triggered:
		return

	can_roll = true
	busy = false

func _update_turn_label() -> void:
	var board_iterations: int = _get_board_iterations_completed()
	turn_label.text = "Turn: %d | Roll: %d | Tile: %d | Laps: %d/%d" % [
		turn,
		roll,
		current_tile_index,
		board_iterations,
		MAX_BOARD_ITERATIONS
	]
	turn += 1

func _set_board_ui_visible(is_visible: bool) -> void:
	var hud := Board.get_node_or_null("HUD")
	if hud != null:
		hud.visible = is_visible

	if Board.overlay_root != null:
		Board.overlay_root.visible = is_visible

	if inventory_overlay != null and not is_visible:
		inventory_overlay.hide()
func _configure_minigames() -> void:
	minigames.clear()

	if asteroid == null:
		asteroid = load("res://Scenes/Minigames/AsteroidTargeting/AsteroidTargeting1.tscn")

	if alien == null:
		alien = load("res://Scenes/Minigames/alien_communication/alien_communication.tscn")

	if asteroid != null:
		minigames.append(asteroid)

	if alien != null:
		minigames.append(alien)
func _offer_game() -> void:
	busy = true
	can_roll = false

	if offer_scene == null:
		push_error("offer_scene is not assigned!")
		busy = false
		can_roll = true
		return

	if Board.overlay_root != null:
		Board.overlay_root.visible = true

	var offer := offer_scene.instantiate()

	offer.title_text = "Do you want to play this minigame?"
	offer.play_text = "Play"
	offer.skip_text = "Skip"
	

	Board.overlay_root.add_child(offer)
	var play: bool = await offer.choice



	if not play:
		busy = false
		can_roll = true
		return
	_configure_minigames()
	if minigames.is_empty():
		
		push_error("No minigames configured.")
		busy = false
		can_roll = true
		return

	var chosen_game_scene: PackedScene = minigames[rng.randi_range(0, minigames.size() - 1)]
	if chosen_game_scene == null:
		push_error("Chosen minigame scene is null.")
		busy = false
		can_roll = true
		return

	_set_board_ui_visible(false)

	var mg := chosen_game_scene.instantiate()
	Board.game_root.add_child(mg)

	var result: Dictionary = await mg.done
	await _result(result)
	await get_tree().process_frame

	for child in Board.game_root.get_children():
		child.queue_free()

	await get_tree().process_frame

	if not ending_triggered:
		_set_board_ui_visible(true)
		busy = false
		can_roll = true

func _result(result: Dictionary) -> void:
	if result.get("status") == "win":
		await _show_reward_screen()

func _show_reward_screen() -> void:
	var screen := reward_screen.instantiate()
	var player_inventory: InventoryModel = $InventoryModel
	screen.setup(player_inventory)
	Board.overlay_root.add_child(screen)
	Board.overlay_root.visible = true
	await screen.item_chosen

	if ending_triggered:
		return

	Board.overlay_root.visible = false

func _get_board_iterations_completed() -> int:
	var board_count: int = Board.get_tile_count()
	if board_count <= 0:
		return 0

	return int(spaces_moved_total / board_count)

func _has_reached_iteration_limit() -> bool:
	return _get_board_iterations_completed() >= MAX_BOARD_ITERATIONS

func _trigger_credits_end() -> void:
	if ending_triggered:
		return

	ending_triggered = true
	can_roll = false
	busy = true

	_set_board_ui_visible(false)

	for child in Board.game_root.get_children():
		child.queue_free()

	if has_node("/root/Navigator"):
		Navigator.call_deferred("go_to_scene_by_path", "res://Scenes/credits.tscn")
