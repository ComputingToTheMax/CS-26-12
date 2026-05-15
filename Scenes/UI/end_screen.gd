extends Control
class_name EndScreen

@onready var title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var subtitle_label: Label = $CenterContainer/VBoxContainer/SubtitleLabel
@onready var quest_list: VBoxContainer = $CenterContainer/VBoxContainer/QuestList
@onready var credits_btn: Button = $CornerButtons/HBoxContainer/CreditsBtn
@onready var restart_btn: Button = $CornerButtons/HBoxContainer/RestartBtn

var is_win: bool = false

func _ready() -> void:
	var vbox: VBoxContainer = $CenterContainer/VBoxContainer
	vbox.custom_minimum_size = Vector2(500, 0)

	for child in vbox.get_children():
		if child is Label:
			child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			child.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
		

func setup(won: bool) -> void:
	is_win = won

	if title_label != null:
		title_label.text = "MISSION COMPLETE" if won else "MISSION FAILED"

	if subtitle_label != null:
		subtitle_label.text = (
			"You arrive at the NASA board meeting, papers in hand, and you present your new discovery mission. Everyone there is entranced by your mission and everyone signs on"
			if won else
			"You arrive at the NASA board meeting, you got so close to realizing your mission but you sadly failed. Better luck next time"
		)

	_populate_quest_status()

func _populate_quest_status() -> void:
	if quest_list == null:
		return

	for child in quest_list.get_children():
		child.queue_free()

	for i in range(1, 4):
		var q: Quest = QuestManager.get_quest(i)
		if q == null:
			continue

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)

		var icon := Label.new()
		icon.text = "COMPLETE" if q.is_complete else "incomplete"
		icon.add_theme_font_size_override("font_size", 18)
		icon.add_theme_color_override(
			"font_color",
			Color(0.2, 0.9, 0.3) if q.is_complete else Color(0.9, 0.2, 0.2)
		)
		row.add_child(icon)

		var desc := Label.new()
		desc.text = q.print_quests()
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(desc)

		quest_list.add_child(row)

func _on_credits_pressed() -> void:
	if has_node("/root/Navigator"):
		Navigator.call_deferred("go_to_scene_by_path", "res://Scenes/Credits/credits.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Credits/credits.tscn")
