extends Button

# Specify one of the below options using the editor to select button properties.
@export var target_scene: PackedScene
@export var target_scene_path: String

var click_sound_player: AudioStreamPlayer

func _ready() -> void:
	if (target_scene == null) and (target_scene_path == "" or target_scene_path == null):
		push_error("Oops! It looks like the button titled {name} wasn't given a target scene to switch too. Please select the node in the editor and provide one.".format({"name":self.name}))

	if (target_scene != null) and (target_scene_path != "" or target_scene_path != null):
		push_warning("Oops! Both a target (packed) scene and a target scene path (string) were specified. Only one option will be used.\n\tNode: %s" % [self.name])

	self.pressed.connect(_on_press)
	
	# Initialize the click player if it has not been initialized already by a previous button.
	if click_sound_player == null:
		click_sound_player = AudioStreamPlayer.new()
		click_sound_player.stream = load("res://Sources/Sounds/click.wav")
		add_child(click_sound_player)
		
	
		
func _on_press():
	_play_click_sound()
	
	await get_tree().create_timer(click_sound_player.stream.get_length()).timeout
	
	_switch_scenes()
	
func _switch_scenes():
	
	if (target_scene != null):
		Navigator.go_to_packed_scene(target_scene)
	
	elif (target_scene_path != null):
		Navigator.go_to_scene_by_path(target_scene_path)

func _play_click_sound():
	
	if click_sound_player.playing:
		click_sound_player.stop()
	
	if GlobalSettings.click_sound_enabled:
		click_sound_player.play()
