extends Control

@export var scroll_speed: float = 40.0

@onready var vBoxContainer: VBoxContainer = $VBoxContainer

@onready var lastElement = $VBoxContainer.get_child(-1)

func _ready():
	vBoxContainer.position.y = get_viewport_rect().size.y


func _process(delta):
	vBoxContainer.position.y -= scroll_speed * delta

	# Looparound code
	#if vBoxContainer.position.y < -vBoxContainer.size.y:
		#vBoxContainer.position.y = get_viewport_rect().size.y


	# Temporarily use the position of the last element. The main container
	# seems to be unreasonably expanding in size.
	if (lastElement.global_position.y + lastElement.size.y + 50) < 0: 
		OS.delay_msec(500)
		$Button.emit_signal("pressed")
