extends Control
@onready var inv_btn: BaseButton = $InvBtn


func _on_inv_btn_pressed() -> void:
	Navigator.go_to("res://Scenes/UI/Inventory.tscn")
