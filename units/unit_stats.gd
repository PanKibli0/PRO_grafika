class_name UnitStats
extends Resource

@export var name: String = "Unit Name"
@export var max_health: int = 1
@export var attack: int = 1
@export var defense: int = 1
@export var damage_min: int = 1
@export var damage_max: int = 1
@export var initiative: int = 1
@export var movement: int = 1
@export var color: Color

func _to_string() -> String:
	return "[%s] HP: %d | ATK: %d | DEF: %d | DMG: %d-%d | INIT: %d | MOV: %d" % [
		name, max_health, attack, defense, damage_min, damage_max, initiative, movement
	]

func _init(name: String = "Unit Name", max_health: int = 1, attack: int = 1, defense: int = 1, damage_min: int = 1, damage_max: int = 1, initiative: int = 1, movement: int = 1, color: Color = Color(1, 1, 1)):
	if damage_min > damage_max:
		var temp = damage_min
		damage_min = damage_max
		damage_max = temp
	
	self.name = name
	self.max_health = max_health
	self.attack = attack
	self.defense = defense	
	self.damage_min = damage_min
	self.damage_max = damage_max
	self.initiative = initiative
	self.movement = movement
	self.color = color
