class_name EffectFireBomb
extends Effect

var damage := 0

func _init():
	name = "FireBomb"
	color_text = Color.ORANGE_RED
	color_bg = Color.DARK_RED
	
	duration = -10
	description = "Upon death, explodes dealing %d DAMAGE to nearby units." % damage

func on_apply(unit):
	damage = max(1,unit.amount*unit.stats.attack/2)

func on_remove(unit):
	var center: Vector3i = GLOBAL.GRID.local_to_map(unit.global_transform.origin)
	for x_offset in range(-1, 2):
		for z_offset in range(-1, 2):
			if x_offset == 0 and z_offset == 0:
				continue
			var check_cell = Vector3i(center.x + x_offset, 0, center.z + z_offset)
			var target_unit = GLOBAL.GRID.get_unit(check_cell)
			if target_unit:
				target_unit.take_damage(damage)



	
