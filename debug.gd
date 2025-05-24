extends Node

func _ready() -> void:
	
	
	#$"../Units/Unit3".effects.add_effect(EffectBleed.new(100,10))
	
	for d in %Units.get_children():
		pass
		d.effects.add_effect(EffectPoison.new(10,3))
		#d.effects.add_effect(EffectFury.new(1.5,3))
		#d.effects.add_effect(EffectCorrode.new(10,1.5,1))
		#d.effects.add_effect(EffectVampirism.new(1))
		
	
			
