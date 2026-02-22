extends SubViewport


enum Sun { NORMAL, CORONAL_HOLE, CME }

@export var sun_normal_stream: VideoStreamTheora
@export var sun_coronal_hole_stream: VideoStreamTheora
@export var sun_cme_stream: VideoStreamTheora

@onready var SUN_STATE_TO_STREAM: Dictionary = {
	Sun.NORMAL : sun_normal_stream,
	Sun.CORONAL_HOLE : sun_coronal_hole_stream,
	Sun.CME : sun_cme_stream,
}

var current_sun_state:Sun = Sun.NORMAL
var next_sun_state:Sun = Sun.CME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	


func _on_solar_video_player_finished() -> void:
	print("Finished!")
	
	var player = $SolarVideoPlayer
	
	player.stream = SUN_STATE_TO_STREAM[next_sun_state]
	#player.stop()
	player.play()
	current_sun_state = next_sun_state
