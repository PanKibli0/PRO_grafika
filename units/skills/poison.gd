class_name SkillPoison
extends Skill

@export var power: int = 2
@export var duration: int = 2

func _init(v_power = null, v_duration = null, v_cooldown = null) -> void:
	name = "Poison"
	color_text = Color.LIGHT_GREEN
	color_bg = Color.PURPLE

	if v_duration != null: duration = v_duration
	if v_power != null: power = v_power
	if v_cooldown != null: cooldown = v_cooldown

	description = "Applies [b]POISON[/b] for [b]%d[/b] turns, dealing [b]%d[/b] damage per turn." % [duration, power]
	actual_cooldown = 0

func activate() -> void:
	super.activate()
	GLOBAL.set_active_skill(self)
	GLOBAL.GRID.draw_all_enemies()
	GLOBAL.targets = []
	
	
func real_work() -> void:
	if GLOBAL.targets:
		for target in GLOBAL.targets:
			target.effects.add_effect(EffectPoison.new(power, duration))

		actual_cooldown = cooldown
		GLOBAL.reset_skill()
