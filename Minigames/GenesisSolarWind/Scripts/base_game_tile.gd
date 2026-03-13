class_name GenesisSolarWindMinigameTile
extends Node2D

enum CURRENT_PATH { TO_ORBIT, ELLIPTICAL_ORBIT, FROM_ORBIT, NONE=-1}
enum SOLAR_WIND_REGIMES { FAST_CORONAL_HOLE, SLOW_INTERSTREAM, RANDOM_CME}

@export var genesis_spacecraft:CharacterBody2D
@onready var player_keycap = $GenesisSpacecraft/Keycap


@export var particle:RigidBody2D


@onready var historical_trajectory = $"HistoricalTrajectory"
@export var particle_path:PathFollow2D

@onready
var to_orbit = $ToOrbit/PathFollow2D
@onready
var elliptical_orbit = $EllipticalOrbit/PathFollow2D
@onready
var from_orbit = $FromOrbit/PathFollow2D

#var current_state = CURRENT_PATH.NONE
var current_state = CURRENT_PATH.TO_ORBIT
var current_solar_wind_regime = SOLAR_WIND_REGIMES.SLOW_INTERSTREAM
var next_solar_wind_regime = SOLAR_WIND_REGIMES.SLOW_INTERSTREAM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	assert(genesis_spacecraft != null,)
	assert(particle != null,)
	assert(particle_path != null,)
	
	# Move the spacecraft to the first orbit path.
	#genesis_spacecraft.get_parent().remove_child(genesis_spacecraft)
	#to_orbit.call_deferred("add_child", genesis_spacecraft)
	genesis_spacecraft.reparent(to_orbit)
	#to_orbit.add_child(genesis_spacecraft)
	
	
	# Pre-trace Genesis Spacecraft Paths
	var points = to_orbit.get_parent().curve.tessellate()
	points.append_array(elliptical_orbit.get_parent().curve.tessellate())
	points.append_array(from_orbit.get_parent().curve.tessellate())
	
	historical_trajectory.points = points
	
	#Line2D.new().points.append_array()
	
	pass

var player:GlobalSettings.PlayerConfiguration
# Custom initialization function to handle custom tiling logic.
func __init(player: GlobalSettings.PlayerConfiguration, viewport_size: Vector2i):
	self.player = player
	
	player_keycap.key_character = player.buttons[0]
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	match current_state:
		CURRENT_PATH.TO_ORBIT:
			
			# TODO: Time Orbit Progress to the Countdown
			to_orbit.progress += 75 * delta
			
			if(to_orbit.progress_ratio >= 0.99):
				genesis_spacecraft.reparent(elliptical_orbit, true)
				current_state = CURRENT_PATH.ELLIPTICAL_ORBIT
			
		CURRENT_PATH.ELLIPTICAL_ORBIT:
			elliptical_orbit.progress += 50 * delta
			
			if(elliptical_orbit.progress_ratio >= 0.99):
				genesis_spacecraft.reparent(from_orbit, true)
				current_state = CURRENT_PATH.FROM_ORBIT
			
		CURRENT_PATH.FROM_ORBIT:
			player_keycap.visible = true
			from_orbit.progress += 50 * delta
	
	
	
func launch_game():
	current_state = CURRENT_PATH.TO_ORBIT
	
func update_solar_wind_regime():
	current_solar_wind_regime = next_solar_wind_regime
	
	
func spawn_particle():
	pass
