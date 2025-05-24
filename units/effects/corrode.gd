class_name EffectCorrode
extends Effect

@export var value_damage : int = 10
@export var value_def : float = 2

func _init(v_value_def = null, v_value_damage = null, dur = null):
	name = "Corrode"
	
	if v_value_def != null: value_def = v_value_def
	if v_value_damage != null: value_damage = v_value_damage
	if dur != null: duration = dur
	
	description = "Reduces [b]DEFENCE[/b] by [b]%s[/b] times.\nDeals [b]%d[/b] damage at the end of each turn." % [str(value_damage), value_def]
	
	color_text = Color.DARK_SLATE_GRAY
	color_bg = Color.DARK_ORANGE

func on_turn_end(unit):
	unit.take_damage(value_damage, true)


func on_apply(unit):
	unit.actual_stats.defense /= value_def


func on_remove(unit):
	unit.actual_stats.defense *= value_def
