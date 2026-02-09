extends Control
@onready var inv_btn: BaseButton = $InvBtn

func _ready() -> void:
	inv_btn.pressed.connect(_on_inv_btn_pressed)

func _on_inv_btn_pressed() -> void:
	Navigator.go_to("res://Scenes/InventoryPanel.tscn")
