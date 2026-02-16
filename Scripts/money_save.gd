extends Node
class_name moneySave

signal money_changed(new_amount: int)

var money: int = 0:
	set(value):
		money=max(0,value)
		money_changed.emit(money)


func add_money(delta: int) -> void:
	money+=delta

func spend_money(cost: int) -> bool:
	if money < cost:
		return false
	money-=cost
	return true
