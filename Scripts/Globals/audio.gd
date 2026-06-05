extends Node

# Invariant: All audio string names listed in the array below
#			 will have correspondingly named nodes that support
#			 standard playback operations guranteed by the audi_loop.gd
#			 script.
const AVAILABLE_AUDIO = [
	"LiftOff!!",
	"Board",
	"Shop",
	#"Soundtrack 1"
]

var currently_playing_audio_name = null

func check_if_audio_exists(audio_name):
	
	if !(audio_name in AVAILABLE_AUDIO):
		push_warning("Oops, an audio soundtrack named " + str(audio_name) + "wasn't found in the list of available audio.")
		return false
	
	# Additional guard clauses above.
	return true

func play_audio(audio_name, start_from_beginning=true, fade_out_previous=true):
	
	print("About to play audio: " + str(audio_name))
	
	if !check_if_audio_exists(audio_name):
		return
		
	if fade_out_previous:
		fade_out_current_audio()
		
	currently_playing_audio_name = audio_name

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

func fade_out_current_audio():
	if currently_playing_audio_name != null:
		print("Fading out previous audio...")
		fade_out_audio(currently_playing_audio_name)
		currently_playing_audio_name = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
