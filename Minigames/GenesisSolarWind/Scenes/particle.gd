class_name Particle
extends RigidBody2D

enum ParticleTypes { ALPHA_PARTICLE=0, ELECTRON=1, PROTON=2 }

@onready var PARTICLE_TYPE_TO_NAME: Dictionary = {
	ParticleTypes.ALPHA_PARTICLE : "alpha_particle",
	ParticleTypes.ELECTRON : "electron",
	ParticleTypes.PROTON : "proton",
}

var PARTICLE_TYPE_TO_NAME_LIST = ["alpha_particle", "electron", "proton"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var particle_types = Array($ParticleSprite.sprite_frames.get_animation_names())
	$ParticleSprite.animation = particle_types.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Freeing!")
	queue_free()

func change_particle_type(particle_type:ParticleTypes):
	$ParticleSprite.animation = PARTICLE_TYPE_TO_NAME_LIST[particle_type]
