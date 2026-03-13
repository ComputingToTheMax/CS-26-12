extends SubViewport


#enum Sun { NORMAL, CORONAL_HOLE, CME }

#enum SOLAR_WIND_REGIMES { FAST_CORONAL_HOLE, SLOW_INTERSTREAM, RANDOM_CME}

@export var sun_normal_stream: VideoStreamTheora
@export var sun_coronal_hole_stream: VideoStreamTheora
@export var sun_cme_stream: VideoStreamTheora

@onready var SUN_STATE_TO_STREAM: Dictionary = {
	GenesisSolarWindMinigameTile.SOLAR_WIND_REGIMES.SLOW_INTERSTREAM : sun_normal_stream,
	GenesisSolarWindMinigameTile.SOLAR_WIND_REGIMES.FAST_CORONAL_HOLE : sun_coronal_hole_stream,
	GenesisSolarWindMinigameTile.SOLAR_WIND_REGIMES.RANDOM_CME : sun_cme_stream,
}

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_solar_video_player_finished() -> void:
	
	#_play_random_solar_video()
	#return
	
	var player = $SolarVideoPlayer
	
	self.parent.update_solar_wind_regime()
	player.stream = SUN_STATE_TO_STREAM[parent.current_solar_wind_regime]
	#player.stop()
	player.play()
	
	
func _play_random_solar_video() -> void:
	
	var player = $SolarVideoPlayer
	var selected_state = SUN_STATE_TO_STREAM.keys().pick_random()
	
	player.stream = SUN_STATE_TO_STREAM[selected_state]
	player.play()
	parent.current_solar_wind_regime = selected_state
	
	
