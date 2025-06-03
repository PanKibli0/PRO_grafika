extends Control
@onready var cost_label = %Cost
@onready var amount_icon = $HBoxContainer/AmountIcon
@onready var name_label = %Name
@onready var amount_label = %Amount
@onready var hashtag = %Hashtag

@onready var button_delete = %ButtonDelete
@onready var button_inc1 = %ButtonInc1
@onready var button_inc10 = %ButtonInc10
@onready var button_dec1 = %ButtonDec1
@onready var button_dec10 = %ButtonDec10

var unit
var amount = 1
var player_index

func setup(u: UnitStats, amount_val: int, player: bool):
	unit = u
	amount = amount_val
	player_index = 1 if player else 0
	name_label.text = u.name

	var color = Color("FF0000") if player else Color("1984c0")
	amount_icon.modulate = color
	name_label.modulate = color
	amount_label.modulate = color
	hashtag.modulate = color

	update_amount_display()

func update_amount_display():
	amount_label.text = str(amount)
	cost_label.text = str(amount*unit.cost)


func set_amount(new_amount):
	if new_amount < 0:
		new_amount = 0

	var delta = new_amount - amount
	var cost = delta * unit.cost

	if cost > 0 and GLOBAL.money[player_index] < cost: return

	GLOBAL.money[player_index] -= cost
	amount = new_amount

	if amount == 0: remove_unit()
	else:
		GLOBAL.players_units_list[player_index][unit] = amount
		update_amount_display()

	GLOBAL.MENU.update_money_label(player_index)



func remove_unit():
	GLOBAL.money[player_index] += unit.cost * amount
	GLOBAL.MENU.update_money_label(player_index)
	GLOBAL.players_units_list[player_index].erase(unit)
	queue_free()

# --- PRZYCISKI ---

func _on_button_delete_pressed():
	remove_unit()

func _on_button_inc_1_pressed():
	set_amount(amount + 1)

func _on_button_inc_10_pressed():
	set_amount(amount + 10)

func _on_button_dec_1_pressed():
	set_amount(amount - 1)

func _on_button_dec_10_pressed():
	set_amount(amount - 10)
