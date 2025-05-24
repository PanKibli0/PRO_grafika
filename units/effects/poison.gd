class_name EffectPoison
extends Effect

@export var value: int = 3


func _init(val = null, dur = null):
	name = "Poison"
	color_text = Color.LIGHT_GREEN
	color_bg = Color.PURPLE

	if val != null: value = val
	if dur != null: duration = dur

	description = "Deals [b]%d[/b] damage at the end of each turn." % value


func on_turn_end(unit):
	unit.take_damage(value, true)
