extends Node2D
class_name AT1

signal finished(result: Dictionary)

func end_game(fin:bool) -> void:
	finished.emit({"finished": fin})
	queue_free()
