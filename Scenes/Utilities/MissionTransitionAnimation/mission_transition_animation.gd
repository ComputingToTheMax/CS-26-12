extends Control

@export var animation_duration:int = 3

@onready var animation_camera = %AnimationCamera
@onready var holding_timer = $HoldingTimer

const starting_offset: Vector2 = Vector2(4900, 300)
const holding_offset: Vector2 = Vector2(2000, 300)
const target_offset: Vector2 = Vector2(-3400, 300)

var current_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If this scene is run independently, launch the animation.
	if owner == null:
		play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_animation():
	animation_camera.offset = starting_offset
	current_tween = create_tween()
	current_tween.tween_property(animation_camera, "offset", holding_offset, animation_duration * 1 / 3).set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_callback(_end_animation)
	
func _end_animation():
	holding_timer.start()
	await holding_timer.timeout
	create_tween().tween_property(animation_camera, "offset", target_offset, animation_duration * 2 / 3.).set_ease(Tween.EASE_IN_OUT)
