extends Control

@onready var money_label = [%MoneyPlayer, %MoneyEnemy]

func _enter_tree():
	GLOBAL.MENU = self


func update_money_label(player_index):
	money_label[player_index].text = str(GLOBAL.money[player_index])
