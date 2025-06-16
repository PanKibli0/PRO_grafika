class_name SkillMassiveHeal
extends Skill


func _init(v_cooldown = null) -> void:
	name = "Massive Heal"
	color_text = Color.DARK_GREEN
	color_bg = Color.LIGHT_GREEN
	
	
	if v_cooldown != null: cooldown = v_cooldown
	description = "Heals [b]all units[/b] for massive amount of HP.\n [b][u]END TURN[/u][/b]" 
	actual_cooldown = 0

func activate() -> void:
	super.activate()
	
	var power = GLOBAL.active_unit.actual_amount * 25
	
	for unit in GLOBAL.UNITS.get_units(GLOBAL.active_unit.player):
		unit.heal(power)
	
	GLOBAL.UNITS.change_active_unit()
