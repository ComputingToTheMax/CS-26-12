extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func disable_collisions():
	$CollisionShape2D.call_deferred("set_disabled", true)
	
func enable_collisions():
	$CollisionShape2D.call_deferred("set_disabled", false)
