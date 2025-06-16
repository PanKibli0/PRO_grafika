class_name SkillPoison
extends Skill

@export var targets_number = 3


var power: int = 1
var turns: int = 1
var total_available: int = 0

func _init(v_cooldown = null) -> void:
	name = "Poison"
	color_text = Color.LIGHT_GREEN
	color_bg = Color.PURPLE

	if v_cooldown != null: cooldown = v_cooldown

	description = "Applies [b]POISON[/b] few turns, dealing damage per turn. \n [b][u]END TURN[/u][/b]" 
	actual_cooldown = 0




func activate() -> void:
	super.activate()
	total_available = GLOBAL.UNITS.get_units(!GLOBAL.active_unit.player).size()
	
	power = GLOBAL.active_unit.actual_amount/5
	turns = GLOBAL.active_unit.actual_amount/25
	
	
	if total_available <= targets_number:
		for unit in GLOBAL.UNITS.get_units(!GLOBAL.active_unit.player):
			unit.effects.add_effect(EffectPoison.new(power, turns))
		actual_cooldown = cooldown
		GLOBAL.UNITS.change_active_unit()
	else:
		GLOBAL.set_active_skill(self)
		GLOBAL.GRID.draw_all_enemies()
		GLOBAL.targets = []
		
	
func real_work() -> void:
	if GLOBAL.targets:
		for target in GLOBAL.targets:
			target.effects.add_effect(EffectPoison.new(power, turns))
		actual_cooldown = cooldown
		GLOBAL.reset_skill()
		GLOBAL.UNITS.change_active_unit()
