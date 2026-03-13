extends RigidBody2D


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
