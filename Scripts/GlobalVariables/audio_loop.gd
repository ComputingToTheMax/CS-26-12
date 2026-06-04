# This script is designed as a utility script to provide simple customizable
# audio controls to a long running audio (such as for background
# soundtracks). Customizable audio levels are intended as a design invariant.
# If you would like more static control of audio, please continue in
# a separate script.
extends AudioStreamPlayer

# Customizable volume dB levels to allow for quick adjustments when
# this script is applied across multiple audio sources.
@export var silent_volume: float = -5
@export var target_volume: float = 10

@export var fade_in_time: float = 10
@export var fade_out_time: float = 1.5

var _volume_tween: Tween

func _ready() -> void:
	# Programatically connect this audio node's "finished" signal
	# to this script so that appliers do not have to do so manually.
	self.finished.connect(_on_finished_playing)

# Automatically loop when playback is finished.
func _on_finished_playing() -> void:
	self.fade_in(true)

func fade_in(start_from_beginning:bool=true) -> void:
	
	# Setup by canceling pending fades and starting at the "silent" volume.
	_cancel_fade()
	self.volume_db = silent_volume
	
	# Either start from the beginning of the audio track or resume playback
	# from the current position.
	if start_from_beginning:
		self.play(0.0)
	else:
		self.play()
		
	_volume_tween = create_tween()
	_volume_tween.tween_property(self, "volume_db", target_volume, fade_in_time).set_ease(Tween.EASE_IN)

# Fade the track down and pause it so it can be resumed later from the same spot.
func fade_out() -> void:
	
	if not playing:
		return
		
	_cancel_fade()
	
	_volume_tween = create_tween()
	_volume_tween.tween_property(self, "volume_db", silent_volume, fade_out_time).set_ease(Tween.EASE_OUT)
	_volume_tween.tween_callback(Callable(self, "set_stream_paused").bind(true))

func _cancel_fade() -> void:
	if _volume_tween != null and _volume_tween.is_valid():
		_volume_tween.kill()
	_volume_tween = null
	
	
## Normalized playback level for music. ~15% linear volume == ~-16.5 dB.
## 20 * log10(0.15) ≈ -16.48, so -16.5 keeps every music source consistent.
#const TARGET_VOLUME_DB: float = -16.5
## Volume treated as "silent" while fading.
#const SILENT_VOLUME_DB: float = -40.0

## Start (or resume) the track and fade it up to the normalized volume.
#func fade_in_play() -> void:
	#_cancel_fade()
	#if not playing:
		#volume_db = SILENT_VOLUME_DB
		#play()
	#stream_paused = false
	#_fade_tween = create_tween()
	#_fade_tween.tween_property(self, "volume_db", TARGET_VOLUME_DB, fade_time).set_ease(Tween.EASE_IN)

# TODO: Add as an optional neatly callable feature.
# A dip in audio volume was specifically implemented for the first track
# this script was applied to as that track began with somewhat harsh Timpani
# drum sounds.
#func _on_finished() -> void:
	## Loop the track without a fade dip when it reaches its natural end.
	#volume_db = TARGET_VOLUME_DB
	#play()
