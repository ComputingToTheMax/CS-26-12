extends Sprite2D

var spaceships: Array[Texture2D] = [
	preload("res://Sources/Images/Spaceship 1.png"),
	preload("res://Sources/Images/Spaceship 2.png"),
	preload("res://Sources/Images/Spaceship 3.png"),
	preload("res://Sources/Images/Spaceship 4.png"),
	preload("res://Sources/Images/Spaceship 5.png")
]

var dragging := false
var correct_dock := 0
var hangar: Node2D
	
func _ready() -> void:
	print("Spaceship node:", $Spaceship)
	hangar = get_parent()

func set_ship(index: int, dock: int) -> void:
	texture = spaceships[index]
	correct_dock = dock
	position = Vector2(200, 300) # reset position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			dragging = true
		elif not event.pressed and dragging:
			dragging = false
			check_position()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()

func check_position() -> void:
	var viewport_size := get_viewport_rect().size

	var right_edge := viewport_size.x * 0.75
	if global_position.x < right_edge:
		return

	var third_height := viewport_size.y / 3.0
	var dock := int(global_position.y / third_height) + 1
	dock = clamp(dock, 1, 3)

	if dock == correct_dock:
		hangar.ship_correct()
