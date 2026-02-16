extends Node
class_name GameState

@onready var inventory: InventoryModel = InventoryModel.new()

func _ready() -> void:
	add_child(inventory)
	MoneySave.add_money(100)
