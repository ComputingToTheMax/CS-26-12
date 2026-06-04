extends Control

signal ready_to_transition

@export var animation_duration:float = 2.5

@onready var animation_camera = %AnimationCamera
@onready var animation_video = %AnimationVideo

@onready var holding_timer = $HoldingTimer
@onready var transition_timer = $TransisionTimer

@onready var spaceship_sound = $SpaceshipSound

#const starting_offset: Vector2 = Vector2(4500, 300)
const starting_offset: Vector2 = Vector2(4900, 300)
const holding_offset: Vector2 = Vector2(2000, 300)
const target_offset: Vector2 = Vector2(-3400, 300)

var current_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If this scene is run independently, launch the animation.
	if owner == null:
		play_animation()
	
	#var root = get_tree().root
	#if get_parent() != root:
		#reparent(root)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_animation():
	self.show()
	animation_video.stop()
	animation_video.play()
	
	spaceship_sound.play()
	
	animation_camera.offset = starting_offset
	current_tween = create_tween()
	current_tween.tween_property(animation_camera, "offset", holding_offset, animation_duration * 1. / 3).set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_callback(_end_animation)
	
func _end_animation():
	
	holding_timer.start()
	await holding_timer.timeout
	current_tween = create_tween()
	
	var exit_duration: float = animation_duration * 3 / 4.
	current_tween.tween_property(animation_camera, "offset", target_offset, exit_duration).set_ease(Tween.EASE_IN_OUT)
	
	transition_timer.wait_time = exit_duration * 3. / 7
	transition_timer.start()
	await transition_timer.timeout
	ready_to_transition.emit()
	
	current_tween.tween_callback(self.hide)

#func _queue_free():
	#queue_free()

# Emit the transition signal when the viewport is hidden and we can
# safely transition.
func _emit_transition_signal():
	ready_to_transition.emit()
