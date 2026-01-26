extends Node2D

enum CURRENT_PATH { TO_ORBIT, ELLIPTICAL_ORBIT, FROM_ORBIT, NONE=-1}

@onready
var genesis_spacecraft = $GenesisSpacecraft

@onready
var to_orbit = $ToOrbit/PathFollow2D
@onready
var elliptical_orbit = $EllipticalOrbit/PathFollow2D
@onready
var from_orbit = $FromOrbit/PathFollow2D

var current_state = CURRENT_PATH.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Move the spacecraft to the first orbit path.
	genesis_spacecraft.get_parent().remove_child(genesis_spacecraft)
	to_orbit.call_deferred("add_child", genesis_spacecraft)
	#to_orbit.add_child(genesis_spacecraft)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	match current_state:
		CURRENT_PATH.TO_ORBIT:
			
			# Time Orbit Progress to the Countdown
			to_orbit.progress += 50 * delta
			
		CURRENT_PATH.ELLIPTICAL_ORBIT:
			
		CURRENT_PATH.FROM_ORBIT:
	
	
	
func launch_game():
	current_state = CURRENT_PATH.TO_ORBIT
	
	
