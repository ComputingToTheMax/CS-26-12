extends Node

# Invariant: All audio string names listed in the array below
#			 will have correspondingly named nodes that support
#			 standard playback operations guranteed by the audi_loop.gd
#			 script.
const AVAILABLE_AUDIO = [
	"LiftOff!!",
]

func check_if_audio_exists(audio_name):
	
	if !(audio_name in AVAILABLE_AUDIO):
		push_warning("Oops, an audio soundtrack named " + str(audio_name) + "wasn't found in the list of available audio.")
		return false
	
	# Additional guard clauses above.
	return true

func play_audio(audio_name, start_from_beginning=true):
	if !check_if_audio_exists(audio_name):
		return

	var target_audio_node = get_node(audio_name)
	if target_audio_node.has_method("fade_in"):
		target_audio_node.fade_in(start_from_beginning)

# Fade a soundtrack back in (alias of play_audio for readability at call sites).
func fade_in_audio(audio_name, start_from_beginning=true) -> void:
	play_audio(audio_name, start_from_beginning)

# Fade a soundtrack out and pause it so it can be resumed later.
func fade_out_audio(audio_name) -> void:
	
	if !check_if_audio_exists(audio_name):
		return
	
	var target_audio_node = get_node(audio_name)
	if target_audio_node.has_method("fade_out"):
		target_audio_node.fade_out()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
