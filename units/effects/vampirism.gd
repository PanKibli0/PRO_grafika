class_name EffectVampirism
extends Effect

@export var value: float = 0.1

func _init(v_value = null, dur=null):
	name = "Vampirism"
	if v_value != null: value = v_value
	description = "Heal [b]%s[/b] of deal damage." % value
	if dur != null: duration = dur
	
	color_text = Color.WEB_GRAY
	color_bg = Color.DARK_RED
	

func on_attack(damage_deal, unit, target = null):
	unit.heal(value*damage_deal, true)
