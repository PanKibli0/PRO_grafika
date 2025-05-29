extends Node

func add_all_effects_to_unit(unit):
	var path = "res://units/effects"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".gd"):
			var script = load(path + "/" + file_name)
			if script != null:
				var effect = script.new()
				if effect is Effect:
					unit.effects.add_effect(effect)
		file_name = dir.get_next()
	dir.list_dir_end()



func _ready() -> void:
	
	#$"../Units/Unit5".skillsList.skills.append(SkillFury.new(3,2,5))
	#$"../Units/Unit4".skillsList.skills.append(SkillFury2.new(10,2,5))
	#$"../Units/Unit5".skillsList.skills.append(SkillFury.new(3,2,5))
	#$"../Units/Unit5".skillsList.skills.append(SkillFury.new(3,2,5))
	#$"../Units/Unit5".skillsList.skills_list()
	#return
	
	for d in %Units.get_children():
		pass
		
		add_all_effects_to_unit(d)
		
		#d.skillsList.skills.append(SkillFury.new(3,2,5))
		#d.skillsList.skills_list()
		#print(d.skillsList.skills)
		
		
		
		
		#d.effects.add_effect(EffectPoison.new(10,3))
		#d.effects.add_effect(EffectFury.new(1.5,3))
		#d.effects.add_effect(EffectCorrode.new(10,1.5,1))
		#d.effects.add_effect(EffectVampirism.new(1))
		#d.effects.add_effect(EffectBrokenAttack.new(2, 1.5))


		
		
	
			
