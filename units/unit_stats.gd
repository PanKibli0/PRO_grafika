class_name UnitStats
extends Resource

@export var name: String = "Unit Name"
@export var cost: int = 10
@export var max_health: int = 1
@export_range(1, 100) var attack: int = 1
@export_range(1, 100) var defense: int = 1
@export_range(1, 100) var damage_min: int = 1
@export_range(1, 100) var damage_max: int = 1
@export_range(0, 100) var ammo: int = 0
@export_range(1, 100) var initiative: int = 1
@export_range(0, 19) var movement: int = 1

@export var start_effects: Array[Effect]
@export var skills: Array[Skill]
@export var color: Color


func _init(
	v_name: String = "Unit Name", 
	v_cost: int = 10,
	v_max_health: int = 1,
	v_attack: int = 1,
	v_defense: int = 1,
	v_damage_min: int = 1,
	v_damage_max: int = 1,
	v_initiative: int = 1,
	v_movement: int = 1,
	v_start_effects: Array[Effect] = [],
	v_skills: Array[Skill] = [],
	v_color: Color = Color(1, 1, 1)
):
	if v_damage_min > v_damage_max:
		var temp = v_damage_min
		v_damage_min = v_damage_max
		v_damage_max = temp

	self.name = v_name
	self.cost = v_cost
	self.max_health = v_max_health
	self.attack = v_attack
	self.defense = v_defense
	self.damage_min = v_damage_min
	self.damage_max = v_damage_max
	self.initiative = v_initiative
	self.movement = v_movement
	self.color = v_color

	self.start_effects = v_start_effects
	self.skills = v_skills


func ensure_positive_stats():
	attack = max(attack, 1)
	defense = max(defense, 1)
	damage_min = max(damage_min, 1)
	damage_max = max(damage_max, 1)
	initiative = max(initiative, 1)
	movement = max(movement, 0)
	ammo = max(ammo, 0)
	

func _to_string() -> String:
	var effects_text := ""
	for i in start_effects.size():
		var effect = start_effects[i]
		effects_text += (effect.name if effect else "null")
		if i < start_effects.size() - 1:
			effects_text += ", "

	var skills_text := ""
	for i in skills.size():
		var skill = skills[i]
		skills_text += (skill.name if skill else "null")
		if i < skills.size() - 1:
			skills_text += ", "

	return """[UnitStats]
Name: %s
Cost: %d
Max Health: %d
Attack: %d
Defense: %d
Damage: %d - %d
Ammo: %d
Initiative: %d
Movement: %d
Color: %s
Start Effects: %s
Skills: %s
""" % [
		name,cost, max_health, attack, defense,
		damage_min, damage_max, ammo,
		initiative, movement, str(color),
		effects_text, skills_text
	]
