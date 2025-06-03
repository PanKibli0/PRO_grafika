extends Control

@onready var money_label = [%MoneyPlayer, %MoneyEnemy]

func _enter_tree():
	GLOBAL.MENU = self


func update_money_label(player_index):
	money_label[player_index].text = str(GLOBAL.money[player_index])
	update_start_button()

func update_start_button():
	for i in range(2):
		if len(GLOBAL.players_units_list[i]) == 0: 
			%Start.disabled = true
			return
	
	%Start.disabled = false
	 
