extends Node

func _ready() -> void:
	for d in %Units.get_children():
		d.effects.add_effect(EffectPoison.new(10,3))
		d.effects.add_effect(EffectFury.new(2,3))
		
