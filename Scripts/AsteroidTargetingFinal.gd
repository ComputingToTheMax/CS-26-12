extends Node2D
signal done(result: Dictionary)

const RESULT_DURATION := 3.0

func _ready():
	_finish_after_delay()

func _finish_after_delay() -> void:
	await get_tree().create_timer(RESULT_DURATION).timeout
	emit_signal("done", {"status": "win", "score": 1})
