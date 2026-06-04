extends CanvasLayer

signal ready_to_transition

@onready var mission_transition_animation = %MissionTransitionAnimation

func play_mission_transition_animation():
	mission_transition_animation.show()
	mission_transition_animation.play_animation()	
	
	await mission_transition_animation.ready_to_transition
	ready_to_transition.emit()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
