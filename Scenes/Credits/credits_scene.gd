extends Control

@export var scroll_speed: float = 60.0

@onready var vBoxContainer: VBoxContainer = $VBoxContainer
@onready var lastElement: Control = $VBoxContainer.get_child(-1)

var credits_finished: bool = false

func _ready() -> void:
	Audio.play_audio("LiftOff!!")
	vBoxContainer.position.y = get_viewport_rect().size.y

func _process(delta: float) -> void:
	vBoxContainer.position.y -= scroll_speed * delta

	if credits_finished:
		return

	if (lastElement.global_position.y + lastElement.size.y + 50) < 0:
		credits_finished = true
		await get_tree().create_timer(0.3).timeout
		
		StageManager.play_mission_transition_animation()
		await StageManager.ready_to_transition
		
		$ReturnButton.emit_signal("pressed")
