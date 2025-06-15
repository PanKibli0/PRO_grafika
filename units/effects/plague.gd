class_name EffectPlague
extends Effect

var damage := 0

func _init():
	name = "Plague"
	color_text = Color.GREEN_YELLOW
	color_bg = Color.WEB_PURPLE
	
	duration = -10
	description = "At the end of each turn, POISONS nearby units for [b]3[/b] turns.\nAlso removes POISON from the host."

func on_apply(unit):
	for effect in unit.effects.active_effects:
		if effect is EffectPoison:
			unit.effects.remove_effect(effect)


func on_turn_end(unit):
	print("PLAGUE")
	var center: Vector3i = GLOBAL.GRID.local_to_map(unit.target_position)
	print(center)
	for x_offset in range(-1, 2):
		for z_offset in range(-1, 2):
			if x_offset == 0 and z_offset == 0:
				continue
			var check_cell = Vector3i(center.x + x_offset, 0, center.z + z_offset)
			var target_unit = GLOBAL.GRID.get_unit(check_cell)
			if target_unit:
				target_unit.effects.add_effect(EffectPoison.new(target_unit.stats.attack, 3))
				
				print(target_unit.effects.active_effects)
