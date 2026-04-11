extends Node2D
class_name MainBoard

signal board_ready

@export var cell_size: Vector2i = Vector2i(64, 64)
@export var tile_count: int = 18
@export var tile_spacing_x: int = 24

@export var min_special_spacing: int = 2
@export var red_tile_target: int = 4
@export var shop_tile_target: int = 3

@onready var overlay_root: Control = get_node_or_null("Overlay/OverlayRoot") as Control
@onready var game_root: Control = $GameOverlay/GameRoot

var rng := RandomNumberGenerator.new()

var tile_positions: Array[Vector2] = []
var red_tile_indices: Array[int] = []
var shop_tile_indices: Array[int] = []
var start_tile_index: int = 0

func _ready() -> void:
	rng.randomize()
	_setup_board_delayed()

func _setup_board_delayed() -> void:
	await get_tree().process_frame
	initialize_board()
	queue_redraw()
	board_ready.emit()

func initialize_board() -> void:
	tile_positions.clear()
	red_tile_indices.clear()
	shop_tile_indices.clear()

	_generate_positions()
	_generate_special_tiles()

func _generate_positions() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var y: float = floor(viewport_size.y * 0.5) - cell_size.y / 2.0
	var current_x: float = 40.0

	for i in range(tile_count):
		tile_positions.append(Vector2(current_x, y))
		current_x += cell_size.x + tile_spacing_x

func _generate_special_tiles() -> void:
	var usable_indices: Array[int] = []

	for i in range(1, tile_count):
		usable_indices.append(i)

	usable_indices.shuffle()

	var red_count: int = 0
	var shop_count: int = 0

	for idx in usable_indices:
		if red_count >= red_tile_target:
			break
		if _can_place_special(idx):
			red_tile_indices.append(idx)
			red_count += 1

	usable_indices.shuffle()

	for idx in usable_indices:
		if shop_count >= shop_tile_target:
			break
		if red_tile_indices.has(idx):
			continue
		if _can_place_special(idx):
			shop_tile_indices.append(idx)
			shop_count += 1

	red_tile_indices.sort()
	shop_tile_indices.sort()

func _can_place_special(index: int) -> bool:
	if index == start_tile_index:
		return false

	for red_idx in red_tile_indices:
		if abs(index - red_idx) < min_special_spacing:
			return false

	for shop_idx in shop_tile_indices:
		if abs(index - shop_idx) < min_special_spacing:
			return false

	return true

func get_tile_center(index: int) -> Vector2:
	if index < 0 or index >= tile_positions.size():
		return Vector2.ZERO
	return tile_positions[index] + Vector2(cell_size.x / 2.0, cell_size.y / 2.0)

func get_start_center() -> Vector2:
	if tile_positions.is_empty():
		return Vector2.ZERO
	return get_tile_center(start_tile_index)

func is_shop_tile(index: int) -> bool:
	return shop_tile_indices.has(index)

func is_red_tile(index: int) -> bool:
	return red_tile_indices.has(index)

func is_valid_tile(index: int) -> bool:
	return index >= 0 and index < tile_positions.size()

func get_tile_count() -> int:
	return tile_positions.size()

func _draw() -> void:
	if tile_positions.is_empty():
		return


	for i in range(tile_positions.size()):
		var pos: Vector2 = tile_positions[i]
		var rect := Rect2(pos, Vector2(cell_size))

		var tile_color := Color(0.45, 0.45, 0.45)

		if i == start_tile_index:
			tile_color = Color(0.2, 0.85, 0.2)
		elif red_tile_indices.has(i):
			tile_color = Color(0.9, 0.2, 0.2)
		elif shop_tile_indices.has(i):
			tile_color = Color(0.2, 0.65, 1.0)

		draw_rect(rect, tile_color, true)
		draw_rect(rect, Color.WHITE, false, 2.0)
