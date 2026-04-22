extends Node2D

signal done(result: Dictionary)

const SIZE: int = 4
const FREQ_PATH: String = "res://Scenes/Minigames/alien_communication/letter_frequency.txt"
const WORD_PATH: String = "res://Scenes/Minigames/alien_communication/word_list.txt"

var board: Array = []
var trie: Trie
var found_words: Array[String] = []
var words_needed: int = 3

var timer_label: Label
var input_box: LineEdit
var board_container: VBoxContainer
var info_label: Label
var words_found_label: Label
var timer: Timer

var base_time: float = 20.0
var time_left: float = 0.0

class TrieNode:
	var children: Dictionary = {}
	var is_word: bool = false

class Trie:
	var root: TrieNode = TrieNode.new()

	func insert(word: String) -> void:
		var node: TrieNode = root
		for c in word:
			var char_key: String = str(c)
			if not node.children.has(char_key):
				node.children[char_key] = TrieNode.new()
			node = node.children[char_key] as TrieNode
		node.is_word = true

	func has_prefix(prefix: String) -> bool:
		var node: TrieNode = root
		for c in prefix:
			var char_key: String = str(c)
			if not node.children.has(char_key):
				return false
			node = node.children[char_key] as TrieNode
		return true

	func is_word(word: String) -> bool:
		var node: TrieNode = root
		for c in word:
			var char_key: String = str(c)
			if not node.children.has(char_key):
				return false
			node = node.children[char_key] as TrieNode
		return node.is_word

func _ready() -> void:
	randomize()
	board = generate_board(FREQ_PATH)
	trie = build_trie(WORD_PATH)
	_create_ui()
	_start_timer()

func load_frequencies(path: String) -> Array[String]:
	if not FileAccess.file_exists(path):
		push_error("Missing alien frequency file: " + path)
		return ["A", "E", "I", "O", "U", "R", "S", "T", "L", "N"]

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open alien frequency file: " + path)
		return ["A", "E", "I", "O", "U", "R", "S", "T", "L", "N"]

	var letters: Array[String] = []

	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line == "":
			continue

		var letter: String = line.left(1)
		var percent_text: String = line.substr(1).strip_edges()
		var percent: float = 1.0

		if percent_text.is_valid_float():
			percent = float(percent_text)

		var count: int = maxi(1, int(round(percent * 10.0)))
		for i in range(count):
			letters.append(letter)

	file.close()

	if letters.is_empty():
		letters = ["A", "E", "I", "O", "U", "R", "S", "T", "L", "N"]

	return letters

func generate_board(freq_file: String) -> Array:
	var letters: Array[String] = load_frequencies(freq_file)
	var generated_board: Array = []

	for i in range(SIZE):
		var row: Array[String] = []
		for j in range(SIZE):
			var r: int = randi() % letters.size()
			row.append(letters[r])
		generated_board.append(row)

	return generated_board

func build_trie(word_file: String) -> Trie:
	var built_trie: Trie = Trie.new()

	if not FileAccess.file_exists(word_file):
		push_error("Missing alien word file: " + word_file)
		for fallback_word in ["STAR", "MARS", "MOON", "ROVER", "SOLAR", "SPACE", "ALIEN", "ORBIT"]:
			built_trie.insert(str(fallback_word))
		return built_trie

	var file: FileAccess = FileAccess.open(word_file, FileAccess.READ)
	if file == null:
		push_error("Could not open alien word file: " + word_file)
		for fallback_word in ["STAR", "MARS", "MOON", "ROVER", "SOLAR", "SPACE", "ALIEN", "ORBIT"]:
			built_trie.insert(str(fallback_word))
		return built_trie

	while not file.eof_reached():
		var word: String = file.get_line().strip_edges().to_upper()
		if word.length() >= 3:
			built_trie.insert(word)

	file.close()
	return built_trie

func _create_ui() -> void:
	var canvas: CanvasLayer = CanvasLayer.new()
	canvas.layer = 210
	add_child(canvas)

	var root: Control = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	canvas.add_child(root)

	var dim: ColorRect = ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.35)
	root.add_child(dim)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var panel: PanelContainer = PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 560)
	center.add_child(panel)

	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(margin)

	var layout: VBoxContainer = VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	margin.add_child(layout)

	var title: Label = Label.new()
	title.text = "Alien Communication"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	layout.add_child(title)

	info_label = Label.new()
	info_label.text = "Find %d valid words from the letters on the screen." % words_needed
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_label.add_theme_font_size_override("font_size", 18)
	layout.add_child(info_label)

	board_container = VBoxContainer.new()
	board_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	board_container.alignment = BoxContainer.ALIGNMENT_CENTER
	board_container.add_theme_constant_override("separation", 8)
	layout.add_child(board_container)

	for i in range(SIZE):
		var row_box: HBoxContainer = HBoxContainer.new()
		row_box.alignment = BoxContainer.ALIGNMENT_CENTER
		row_box.add_theme_constant_override("separation", 8)
		board_container.add_child(row_box)

		var row_data: Array = board[i]
		for j in range(SIZE):
			var letter_panel: PanelContainer = PanelContainer.new()
			letter_panel.custom_minimum_size = Vector2(84, 84)
			row_box.add_child(letter_panel)

			var letter: Label = Label.new()
			letter.text = str(row_data[j])
			letter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			letter.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			letter.add_theme_font_size_override("font_size", 28)
			letter.custom_minimum_size = Vector2(84, 84)
			letter.size_flags_horizontal = Control.SIZE_FILL
			letter.size_flags_vertical = Control.SIZE_FILL
			letter_panel.add_child(letter)

	input_box = LineEdit.new()
	input_box.placeholder_text = "Type a word and press Enter"
	input_box.custom_minimum_size = Vector2(0, 46)
	layout.add_child(input_box)
	input_box.text_submitted.connect(_on_word_entered)

	words_found_label = Label.new()
	words_found_label.text = "Words found: none"
	words_found_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	words_found_label.add_theme_font_size_override("font_size", 16)
	layout.add_child(words_found_label)

	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 18)
	layout.add_child(timer_label)

	input_box.call_deferred("grab_focus")

func _build_board_letter_counts() -> Dictionary:
	var counts: Dictionary = {}

	for row_variant in board:
		var row: Array = row_variant
		for letter_variant in row:
			var letter: String = str(letter_variant).to_upper()
			if not counts.has(letter):
				counts[letter] = 0
			counts[letter] = int(counts[letter]) + 1

	return counts

func can_form_word_from_board(word: String) -> bool:
	var remaining: Dictionary = _build_board_letter_counts()

	for c in word:
		var letter: String = str(c).to_upper()

		if not remaining.has(letter):
			return false

		remaining[letter] = int(remaining[letter]) - 1
		if int(remaining[letter]) < 0:
			return false

	return true

func _on_word_entered(text: String) -> void:
	var word: String = text.strip_edges().to_upper()
	input_box.text = ""
	input_box.call_deferred("grab_focus")

	if word == "":
		info_label.text = "Enter a word from the grid."
		return

	if word in found_words:
		info_label.text = "Already found: " + word
		return

	if not can_form_word_from_board(word):
		info_label.text = "Word cannot be formed from the letters on the board."
		return

	if trie.is_word(word):
		found_words.append(word)
		words_found_label.text = "Words found: " + ", ".join(found_words)
		info_label.text = "Good. %d / %d words found." % [found_words.size(), words_needed]

		if found_words.size() >= words_needed:
			_finish("win")
	else:
		info_label.text = "Not a valid word."

func _start_timer() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_tick)

	var time_bonus: int = 0
	if has_node("/root/CurGameState"):
		time_bonus = CurGameState.total_time_bonus

	time_left = base_time + float(time_bonus * 3)
	_update_timer_label()
	timer.start()

func _on_timer_tick() -> void:
	time_left -= 1.0
	_update_timer_label()

	if time_left <= 0.0:
		timer.stop()
		_finish("loss")

func _update_timer_label() -> void:
	timer_label.text = "Time left: " + str(maxi(0, int(ceil(time_left))))

func _finish(status: String) -> void:
	if timer != null:
		timer.stop()

	if input_box != null:
		input_box.editable = false

	if info_label != null:
		if status == "win":
			info_label.text = "Signal decoded."
		else:
			info_label.text = "Time is up."

	done.emit({"status": status, "score": found_words.size()})
	queue_free()