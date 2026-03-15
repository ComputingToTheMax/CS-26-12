extends Node
class_name ItemDatabase


var items : Dictionary = {}

func load_items(json_path:String):

	var file = FileAccess.open(json_path, FileAccess.READ)
	if file == null:
		print("Failed to load items")
		return

	var text = file.get_as_text()
	var data = JSON.parse_string(text)

	if data == null:
		print("Invalid JSON")
		return

	for item_data in data["items"]:

		var item := ItemData.new()

		item.id = item_data["ID"]
		item.display_name = item_data["Name"]
		item.description = item_data["Description"]
		item.value = item_data["Price"]
		item.max_stack = item_data["MaxStack"]
		item.icon = load(item_data["Icon"])
		item.speed = item_data["Speed"]
		item.durability = item_data["Durability"]
		item.efficiency = item_data["Efficiency"]
		item.time_bonus = item_data["Time bonus"]
		item.difficulty_reduction = item_data["Difficulty reduction"]

		items[item.id] = item

	print("Loaded ", items.size(), " items")

func get_item(id:String) -> ItemData:
	return items.get(id)
