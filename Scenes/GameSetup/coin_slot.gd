extends Control

signal token_dropped(token:DiscoveryToken)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is DiscoveryToken:
		data.rotate_to_side()
		
		print("Token rotated!")
		
		return true

	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	if data is DiscoveryToken:
		
		# Request the token to preform drop animations and behavior itself.
		data.drop_coin()
		token_dropped.emit(data)
