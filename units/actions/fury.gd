class_name SkillFury
extends Skill

@export var duration: int
@export var power: int



func _init(v_duration = null, v_power = null, v_cooldown = null) -> void:
	if v_duration != null: duration = v_duration
	if v_power != null: power = v_power
	if v_cooldown != null: cooldown = v_cooldown
	active_cooldown = 0

func activate() -> void:
	unit.effects.add_effect(EffectFury.new(duration, power))
	active_cooldown = cooldown
