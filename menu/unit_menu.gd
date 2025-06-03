extends Control

signal S_add_unit_to_list(unit)
@onready var button = %Button

@onready var cost_label = %Cost
@onready var name_label = %Name
@onready var hp_label = %HPlabel
@onready var attack_label = %Attack
@onready var defense_label = %Defense
@onready var min_damage_label = %MinDamage
@onready var max_damage_label = %MaxDamage
@onready var initiative_label = %Inititative
@onready var movement_label = %Movement
@onready var ammo_label = %Ammo

@onready var space = %SPACE
@onready var effect_icon = %EffectsIcon
@onready var effect_label = %Effects
@onready var skills_icon = %SkillIcon
@onready var skills_label = %Skills


func init_unit(u: UnitStats) -> void:
	cost_label.text = str(u.cost)
	name_label.text = u.name
	hp_label.text = str(u.max_health)
	attack_label.text = str(u.attack)
	defense_label.text = str(u.defense)
	min_damage_label.text = str(u.damage_min)
	max_damage_label.text = str(u.damage_max)
	initiative_label.text = str(u.initiative)
	movement_label.text = str(u.movement)
	ammo_label.text = str(u.ammo)
	
	
	var effects_count = len(u.start_effects)
	var skills_count = len(u.skills)

	effect_label.text = str(effects_count)
	skills_label.text = str(skills_count)
	
	space.visible = effects_count > 0 or skills_count > 0
	effect_label.visible = effects_count > 0
	effect_icon.visible = effects_count > 0


	skills_label.visible = skills_count > 0
	skills_icon.visible = skills_count > 0
	
	button.pressed.connect(func():emit_signal("S_add_unit_to_list", u))
	
