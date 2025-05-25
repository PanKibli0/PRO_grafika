class_name EffectBrokenAttack
extends Effect

var attack: int = 2
var def: float = 1.5
var damage: int = 10
var turns: int = 1

func _calculate_var(unit = GLOBAL.active_unit):
	if unit and unit.actual_stats:
		damage = max(1, unit.actual_amount * unit.actual_stats.attack / 10)
		turns = max(1, unit.actual_amount / 20)
		
		description = """Reduces own [b]ATTACK[/b] by [b]%d[/b].
Applies a [b]CORRODE[/b] effect with [b]%s DEFENSE reduction[/b] and [b]%d damage[/b] for [b]%d[/b] turns.""" % [
		attack, str(def), damage, turns]

func _init(v_attack = null, v_def = null, dur = null):
	name = "Broken Attack"

	if v_attack != null: attack = v_attack
	if v_def != null: def = v_def
	if dur != null: duration = dur

	_calculate_var()

	description = """Reduces own [b]ATTACK[/b] by [b]%d[/b].
Applies a [b]CORRODE[/b] effect with [b]%s DEFENSE reduction[/b] and [b]%d damage[/b] for [b]%d[/b] turns.""" % [
		attack, str(def), damage, turns]

	color_text = Color.DARK_SLATE_GRAY
	color_bg = Color.DARK_GOLDENROD

func on_apply(unit):
	unit.actual_stats.attack -= attack
	_calculate_var(unit)

func on_turn_start(unit):
	_calculate_var(unit)

func _on_attack(unit, target):
	target.effects.add_effect(EffectCorrode.new(def, damage, turns))
	
	if unit.stats.attack - unit.actual_stats.attack >= 2:
		unit.actual_stats.attack += 1
