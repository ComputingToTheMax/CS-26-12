extends Node3D

var target_rotation = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	#var x_rotation = 0
	#var z_rotation = 0
	#
	#var current_x_rotation = rotation_degrees.x
	#var current_z_rotation = rotation_degrees.z
	#
	#if current_x_rotation < target_rotation.x:
		#x_rotation = min(target_rotation.x - current_x_rotation, target_rotation.x - current_x_rotation * delta)
	#elif current_x_rotation > target_rotation.x:
		#x_rotation = min(current_x_rotation - target_rotation.x, current_x_rotation - target_rotation.x * delta)
		#
	#if current_z_rotation < target_rotation.z:
		#z_rotation = min(target_rotation.z - current_z_rotation, target_rotation.z - current_z_rotation * delta)
	#elif current_z_rotation > target_rotation.x:
		#z_rotation = min(current_z_rotation - target_rotation.z, current_z_rotation - target_rotation.z * delta)
		#
	#print(x_rotation, z_rotation)
	#rotation_degrees += Vector3(x_rotation, 0, z_rotation)
		

func set_target_rotation(target_rotation:Vector3):
	#print(target_rotation)
	target_rotation = target_rotation
	self.rotation_degrees = target_rotation
