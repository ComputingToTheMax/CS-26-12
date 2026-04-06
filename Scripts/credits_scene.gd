extends Control

@export var scroll_speed: float = 40.0

@onready var vBoxContainer: VBoxContainer = $VBoxContainer


func _ready():
	vBoxContainer.position.y = get_viewport_rect().size.y


func _process(delta):
	vBoxContainer.position.y -= scroll_speed * delta

	if vBoxContainer.position.y < -vBoxContainer.size.y:
		vBoxContainer.position.y = get_viewport_rect().size.y
