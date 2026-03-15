extends Resource
class_name ItemData

@export var id: String
@export var display_name: String
@export var mission : String

@export var speed : int
@export var durability : int
@export var efficiency : int
@export var time_bonus : int
@export var difficulty_reduction : int
@export var icon: Texture2D
@export var value: int = 10
@export var max_stack: int = 99
@export var buy_price: int=10
@export var sell_price: int=5
@export_multiline var description: String = ""
