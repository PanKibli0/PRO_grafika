class_name EffectFury
extends Effect

@export var value: float = 1.0


func _init(val = null, dur = null):
	name = "Fury"
	color_text = Color.YELLOW
	color_bg = Color.RED

	if val != null:
		value = val
	if dur != null:
		duration = dur

	description = "[b]ATTACK[/b] increases by [b]%s[/b] times." % str(value)

func on_apply(unit):
	unit.actual_stats.attack *= value

func on_remove(unit):
	unit.actual_stats.attack /= value
