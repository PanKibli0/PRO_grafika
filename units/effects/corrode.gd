class_name EffectCorrode
extends Effect

@export var value_damage : int
@export var value_def : float 

func _init( v_value_def: float, v_value_damage: int, dur: int = 3):
	name = "Corrode"
	value_damage = v_value_damage
	value_def = v_value_def
	duration = dur
	description = "Reduces defense by [b]%s[/b] times.\nDeals [b]%d[/b] damage at the end of each turn." % [str(value_damage), value_def]
	
	color_text = Color.DARK_SLATE_GRAY
	color_bg = Color.DARK_ORANGE

func on_turn_end(unit):
	unit.take_damage(value_damage, true)


func on_apply(unit):
	unit.actual_stats.defense /= value_def


func on_remove(unit):
	if unit.actual_stats.defense == 0: 
		unit.actual_stats.defense = unit.stats.defense
		return
	unit.actual_stats.defense *= value_def
