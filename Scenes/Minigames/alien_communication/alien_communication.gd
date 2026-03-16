extends Node2D
signal done(result)

const SIZE = 4
var board = []
var trie
var found_words = []
var words_needed = 10-CurGameState.total_time_bonus

var timer_label: Label
@onready var timer: Timer = Timer.new()

var base_time := 20.0
var time_left := 0.0
var bonus =.5

var input_box
var board_container
var info_label

class TrieNode:
	var children = {}
	var is_word = false


class Trie:
	var root = TrieNode.new()

	func insert(word: String):
		var node = root
		for c in word:
			if not node.children.has(c):
				node.children[c] = TrieNode.new()
			node = node.children[c]
		node.is_word = true

	func has_prefix(prefix: String) -> bool:
		var node = root
		for c in prefix:
			if not node.children.has(c):
				return false
			node = node.children[c]
		return true

	func is_word(word: String) -> bool:
		var node = root
		for c in word:
			if not node.children.has(c):
				return false
			node = node.children[c]
		return node.is_word

func load_frequencies(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	var letters = []

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "":
			continue

		var letter = line[0]
		var percent = float(line.substr(1, line.length() - 2))

		var count = int(percent * 10)
		for i in range(count):
			letters.append(letter)

	file.close()
	return letters


func generate_board(freq_file: String) -> Array:
	var letters = load_frequencies(freq_file)
	var b = []

	for i in range(SIZE):
		b.append([])
		for j in range(SIZE):
			var r = randi() % letters.size()
			b[i].append(letters[r])

	return b


func build_trie(word_file: String) -> Trie:
	var t = Trie.new()

	var file = FileAccess.open(word_file, FileAccess.READ)

	while not file.eof_reached():
		var word = file.get_line().strip_edges().to_upper()
		if word.length() >= 3:
			t.insert(word)

	file.close()
	return t

var DIRS = [
	Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),
	Vector2(0, -1),                Vector2(0, 1),
	Vector2(1, -1),  Vector2(1, 0), Vector2(1, 1)
]

func find_words(board: Array, trie: Trie) -> Array:
	var found = {}
	var visited = []

	for i in range(SIZE):
		visited.append([])
		for j in range(SIZE):
			visited[i].append(false)

	for i in range(SIZE):
		for j in range(SIZE):
			_dfs(board, i, j, "", trie, visited, found)

	return found.keys()


func _dfs(board, x, y, current, trie, visited, found):

	if x < 0 or y < 0 or x >= SIZE or y >= SIZE:
		return

	if visited[x][y]:
		return

	current += board[x][y]

	if not trie.has_prefix(current):
		return

	if trie.is_word(current):
		found[current] = true

	visited[x][y] = true

	for d in DIRS:
		_dfs(board, x + d.x, y + d.y, current, trie, visited, found)

	visited[x][y] = false

func create_ui():
	board_container = VBoxContainer.new()
	board_container.position = Vector2(40, 40)
	add_child(board_container)
	timer_label = Label.new()
	timer_label.position = Vector2(40, 300)
	timer_label.text = "Time:"
	add_child(timer_label)

	for i in range(SIZE):
		var row = HBoxContainer.new()
		board_container.add_child(row)

		for j in range(SIZE):
			var lab = Label.new()
			lab.text = board[i][j]
			lab.custom_minimum_size = Vector2(40, 40)
			row.add_child(lab)

	input_box = LineEdit.new()
	input_box.position = Vector2(40, 220)
	input_box.placeholder_text = "Word"
	add_child(input_box)

	input_box.connect("text_submitted", Callable(self, "_on_word_entered"))

	info_label = Label.new()
	info_label.position = Vector2(40, 260)
	info_label.text = "Find 10 words!"
	add_child(info_label)

func _on_word_entered(text):
	var word = text.strip_edges().to_upper()
	input_box.text = ""

	if word in found_words:
		info_label.text = "Already found: " + word
		return

	if trie.is_word(word):
		found_words.append(word)
		info_label.text = "Good! " + str(found_words.size()) + " / " + str(words_needed)

		if found_words.size() >= words_needed:
			var result := {"status":"done", "score": words_needed}
			emit_signal("done", result)

	else:
		info_label.text = "Not a valid word"

func update_timer_label():
	timer_label.text = "Time: " + str(int(time_left))
	
func _on_timer_tick():
	time_left -= 1
	update_timer_label()

	if time_left <= 0:
		timer.stop()
		var result := {"status":"fail", "score": found_words.size()}
		emit_signal("done", result)
		
func start_timer():
	add_child(timer)

	var bonus = CurGameState.total_time_bonus
	time_left = base_time + (bonus * 3)

	timer.wait_time = 1
	timer.timeout.connect(_on_timer_tick)
	timer.start()

	update_timer_label()
	
func _ready():
	randomize()

	board = generate_board("res://Scenes//Minigames//alien_communication//letter_frequency.txt")
	trie = build_trie("res://Scenes//Minigames//alien_communication//word_list.txt")
	create_ui()

	print("BOARD:")
	for row in board:
		print(row)

	var all = find_words(board, trie)
	print("Possible words:", all.size())
	start_timer()
	
