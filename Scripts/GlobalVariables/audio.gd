extends Node

const AVAILABLE_AUDIO = [
	"LiftOff!!",
]

func play_audio(audio_name, start_from_beginning=true):

	if !(audio_name in AVAILABLE_AUDIO):
		push_warning("Oops, an audio soundtrack named " + str(audio_name) + "wasn't found.")
		return

	var target_audio_node = get_node(audio_name)
	if target_audio_node.has_method("fade_in_play"):
		target_audio_node.fade_in_play()

# Fade a soundtrack back in (alias of play_audio for readability at call sites).
func fade_in_audio(audio_name) -> void:
	play_audio(audio_name)

# Fade a soundtrack out and pause it so it can be resumed later.
func fade_out_audio(audio_name) -> void:
	var target_audio_node = get_node_or_null(audio_name)
	if target_audio_node != null and target_audio_node.has_method("fade_out"):
		target_audio_node.fade_out()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
