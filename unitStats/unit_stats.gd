extends Control

@onready var name_label = $VBoxContainer/Name
@onready var amount_icon = $VBoxContainer/Amount/AmountIcon
@onready var amount_label = $VBoxContainer/Amount/AmountLabel
@onready var hp_label = $VBoxContainer/HP/HPbar/HPlabel
@onready var attack_label = $"VBoxContainer/attack&defense/Attack"
@onready var defense_label = $"VBoxContainer/attack&defense/Defense"
@onready var min_damage_label = $VBoxContainer/damage/MinDamage
@onready var max_damage_label = $VBoxContainer/damage/MaxDamage
@onready var initiative_label = $"VBoxContainer/inititative&movement/Inititative"
@onready var movement_label = $"VBoxContainer/inititative&movement/Movement"
@onready var ammo_label = $"VBoxContainer/Ammo&ButtonEffects/Ammo"


func set_info(unit: Unit):
	if not unit.actual_stats or not unit.stats:
		return

	name_label.text = unit.actual_stats.name

	amount_label.text = str(unit.actual_amount) + " / " + str(unit.amount)
	hp_label.text = str(unit.actual_health) + " / " + str(unit.stats.max_health)
	if unit.player:	
		name_label.modulate = Color("00b3ff")
		amount_icon.modulate = Color("00b3ff")
		amount_label.modulate = Color("00b3ff")
	else:
		name_label.modulate = Color(0.8,0,0)
		amount_icon.modulate = Color(0.8,0,0)
		amount_label.modulate = Color(0.8,0,0)
		
		
	_set_label_value(attack_label, unit.actual_stats.attack, unit.stats.attack)
	_set_label_value(defense_label, unit.actual_stats.defense, unit.stats.defense)
	_set_label_value(min_damage_label, unit.actual_stats.damage_min, unit.stats.damage_min)
	_set_label_value(max_damage_label, unit.actual_stats.damage_max, unit.stats.damage_max)
	_set_label_value(initiative_label, unit.actual_stats.initiative, unit.stats.initiative)
	_set_label_value(movement_label, unit.actual_stats.movement, unit.stats.movement)

	ammo_label.text = str(unit.actual_stats.ammo)
	if unit.actual_stats.ammo == 0:
		ammo_label.modulate = Color(1, 1, 1) 
	else:
		ammo_label.modulate = Color(0, 1, 0) 


func _set_label_value(label: Label, value, standard_value):
	label.text = str(value)
	if value > standard_value:
		label.modulate = Color(0, 1, 0) 
	elif value < standard_value:
		label.modulate = Color(1, 0, 0) 
	else:
		label.modulate = Color(1, 1, 1) 
	
	
