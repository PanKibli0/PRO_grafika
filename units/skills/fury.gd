class_name SkillFury
extends Skill

@export var duration: int = 2
@export var power: int = 2

func _init(v_power = null,v_duration = null, v_cooldown = null) -> void:
	name = "Full Fury"
	color_text = Color.YELLOW
	color_bg = Color.DARK_RED

	if v_duration != null: duration = v_duration
	if v_power != null: power = v_power
	if v_cooldown != null: cooldown = v_cooldown

	description = "Grants [b]FURY[/b] effect for %d turns." % duration
	actual_cooldown = 0

func activate() -> void:
	if cant_use(): return
	super.activate()
	#unit.effects.add_effect(EffectFury.new(power, duration))
	actual_cooldown = cooldown
