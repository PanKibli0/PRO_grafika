extends Node

func _ready() -> void:
	for d in %Units.get_children():
		#for i in range(10):
		d.effects.add_effect(EffectPoison.new(10,3))
		
