extends AudioStreamPlayer

# Normalized playback level for music. ~15% linear volume == ~-16.5 dB.
# 20 * log10(0.15) ≈ -16.48, so -16.5 keeps every music source consistent.
const TARGET_VOLUME_DB: float = -16.5
# Volume treated as "silent" while fading.
const SILENT_VOLUME_DB: float = -40.0

@export var fade_time: float = 1.5

var _fade_tween: Tween

func _kill_fade() -> void:
	if _fade_tween != null and _fade_tween.is_valid():
		_fade_tween.kill()
	_fade_tween = null

# Start (or resume) the track and fade it up to the normalized volume.
func fade_in_play() -> void:
	_kill_fade()
	if not playing:
		volume_db = SILENT_VOLUME_DB
		play()
	stream_paused = false
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "volume_db", TARGET_VOLUME_DB, fade_time).set_ease(Tween.EASE_IN)

# Fade the track down and pause it so it can be resumed later from the same spot.
func fade_out() -> void:
	if not playing:
		return
	_kill_fade()
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "volume_db", SILENT_VOLUME_DB, fade_time).set_ease(Tween.EASE_OUT)
	_fade_tween.tween_callback(Callable(self, "set_stream_paused").bind(true))

func _on_finished() -> void:
	# Loop the track without a fade dip when it reaches its natural end.
	volume_db = TARGET_VOLUME_DB
	play()
