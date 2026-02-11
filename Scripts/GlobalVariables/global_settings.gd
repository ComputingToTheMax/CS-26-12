extends Node

# Public Global Settings Variables

var number_of_players : int


# Setup and Configuration

static var global_settings_instance = null

# Automatically delete new instances of global settings if a single instance already exists.
func _init() -> void:
	if global_settings_instance == null:
		global_settings_instance = self
	else:
		printerr("Oops,it looks like something unexpectedly tried to creat a copy of the global settings. This isn't supported at the moment, so the copy will be deleted.")
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
