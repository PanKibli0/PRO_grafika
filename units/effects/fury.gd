class_name EffectFury
extends Effect

var value : int

func _init(v_value, dur=3):
	name = "Fury"
	value = v_value 
	description = "[b]ATTACK[/b] increases by [b]%d[/b] times." % value
	duration = dur
	color_text = Color.YELLOW
	color_bg = Color.RED

func on_apply(unit):
	unit.actual_stats.attack *= value


func on_remove(unit):
	unit.actual_stats.attack /= value
