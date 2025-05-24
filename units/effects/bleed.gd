class_name EffectBleed
extends Effect


@export var value : int = 10


func _init(v_value = null, dur=null):
	name = "Bleed"
	if v_value != null: value = v_value
	
	if dur != null: duration = dur
	
	description = "Deals [b]%d[/b] damage at the start of each turn." % value
	color_text = Color.DARK_RED
	color_bg = Color.PALE_VIOLET_RED
	
func on_turn_start(unit):
	unit.take_damage(value, true)
