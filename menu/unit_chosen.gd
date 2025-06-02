extends Control

@onready var amount_icon = $HBoxContainer/AmountIcon
@onready var name_label = %Name
@onready var amount_label = %Amount
@onready var hashtag = %Hash


func setup(unit_name: String, amount: int, player:bool):
	name_label.text = unit_name
	amount_label.text = str(amount)
	
	var color = Color("1984c0") if player else Color("FF0000")

	amount_icon.modulate = color
	name_label.modulate = color
	amount_label.modulate = color
	hashtag.modulate = color
