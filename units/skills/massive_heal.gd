class_name SkillMassiveHeal
extends Skill


@export var power: int = 2

func _calculate():
	pass	

func _init(v_power = null, v_cooldown = null) -> void:
	name = "Massive Heal"
	color_text = Color.DARK_GREEN
	color_bg = Color.LIGHT_GREEN

	if v_power != null: power = v_power
	if v_cooldown != null: cooldown = v_cooldown
	description = "Heals [b]all units[/b] for %d HP.\n [b][u]END TURN[/u][/b]" % power
	actual_cooldown = 0

func activate() -> void:
	super.activate()
	
	
	for unit in GLOBAL.UNITS.get_units(GLOBAL.active_unit.player):
		unit.heal(power)
	
	GLOBAL.UNITS.change_active_unit()
