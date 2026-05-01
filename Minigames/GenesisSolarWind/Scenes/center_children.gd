extends Node2D

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global_position)
	print(parent.size)
	
	var scale_factor:float = parent.size.x / 652.0 + 2
	scale = Vector2(1, 1) * scale_factor
	position *= Vector2(-10.83, -0.789)
	
	print(scale)
	print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
