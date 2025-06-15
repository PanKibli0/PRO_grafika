class_name SkillNecromancy
extends Skill

var zombie_stats = preload("res://units/variants/Zombie.tres")
var unit_scene = preload("res://units/Unit.tscn")

func tick_cooldown():
	tick_cooldown().super()
	pass	
	


func _init(v_power = null, v_cooldown = null) -> void:
	name = "Necromancy"
	color_text = Color.WHEAT
	color_bg = Color.SEA_GREEN


	if v_cooldown != null: cooldown = v_cooldown
	description = "Summon a few Zombies. \n [b][u]END TURN[/u][/b]"
	actual_cooldown = 0

func activate() -> void:
	super.activate()
	
	var center: Vector3i = GLOBAL.GRID.local_to_map(GLOBAL.active_unit.target_position)
	var insert_index = GLOBAL.UNITS.active_unit_index

	
	var directions = [
		Vector3i(1 if GLOBAL.active_unit.player else -1, 0, 0),
		Vector3i(0, 0, 1),  
		Vector3i(0, 0, -1)
	]

	for offset in directions:
		var check_cell = center + offset
		
		if check_cell.x < 0 or check_cell.x >= GLOBAL.GRID.grid_size[0]: continue
		if check_cell.z < 0 or check_cell.z >= GLOBAL.GRID.grid_size[1]: continue


		if not GLOBAL.GRID._is_cell_occupied(check_cell):
			var new_unit = unit_scene.instantiate()
			new_unit.stats = zombie_stats
			new_unit.player = GLOBAL.active_unit.player

			var base_amount = GLOBAL.active_unit.actual_amount
			if base_amount >= 10:
				new_unit.amount = randi_range(3, 8) * max(1, base_amount - 10)
			else:
				new_unit.amount = randi_range(10, 35)

			new_unit.visible = false
			
			new_unit.target_position = check_cell
			GLOBAL.UNITS.add_child(new_unit)
			GLOBAL.GRID.occupy_cell(check_cell, new_unit)
			GLOBAL.UNITS.units_list.insert(insert_index, new_unit)

			var target_pos = GLOBAL.GRID.map_to_local(check_cell) + Vector3(1 if new_unit.player else -1, 0, 0)
			target_pos.y = 0
			new_unit.look_at(target_pos)
			GLOBAL.UNITS.change_active_unit()
			
			new_unit.visible = true
			return 

	
