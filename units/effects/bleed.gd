class_name EffectBleed
extends Effect


@export var value : int


func _init(v_value, dur=3):
	name = "Bleed"
	value = v_value
	description = "Deals [b]%d[/b] damage at the start of each turn." % value
	duration = dur
	
	color_text = Color.RED
	color_bg = Color.INDIAN_RED
	
func on_turn_start(unit):
	unit.take_damage(value, true)
