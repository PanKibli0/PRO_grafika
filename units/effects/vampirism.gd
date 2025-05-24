class_name EffectVampirism
extends Effect

@export var value: float

func _init(v_value):
	name = "Vampirism"
	value = v_value
	description = "Heal [b]%s[/b] of deal damage." % value
	duration = -10
	
	color_text = Color.LIGHT_GREEN
	color_bg = Color.PURPLE
	

func on_attack(damage_deal, unit, target = null):
	print(damage_deal)
	unit.heal(value*damage_deal, true)
	print("VAMPIRE")
