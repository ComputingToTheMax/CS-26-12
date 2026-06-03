extends AudioStreamPlayer

@export var starting_volume: float = 1
@export var ending_volume: float = 10
@export var fade_in_time: float = 10
	
func fade_in_play():
	self.volume_db = starting_volume
	self.play()
	var volume_tween = create_tween().tween_property(self, "volume_db", ending_volume, fade_in_time).set_ease(Tween.EASE_IN)

func _on_finished() -> void:
	self.fade_in_play()
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#fade_in_play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
