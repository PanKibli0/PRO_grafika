class_name UnitStats
extends Resource

@export var name: String = "Unit Name"
@export var max_health: int = 1
@export var attack: int = 1
@export var defense: int = 1
@export var damage_min: int = 1
@export var damage_max: int = 1
@export var ammo: int = 0
@export var initiative: int = 1
@export var movement: int = 1

@export var start_effects: Array[Effect]
#@export var skills: Array[]
@export var color: Color


func _init(v_name: String = "Unit Name", v_max_health: int = 1, v_attack: int = 1, v_defense: int = 1, v_damage_min: int = 1, v_damage_max: int = 1, v_initiative: int = 1, v_movement: int = 1,v_start_effects: Array[Effect] = [], v_color: Color = Color(1, 1, 1)):
	if v_damage_min > v_damage_max:
		var temp = v_damage_min
		v_damage_min = v_damage_max
		v_damage_max = temp
	
	self.name = v_name
	self.max_health = v_max_health
	self.attack = v_attack
	self.defense = v_defense	
	self.damage_min = v_damage_min
	self.damage_max = v_damage_max
	self.initiative = v_initiative
	self.movement = v_movement
	self.color = v_color
	
	self.start_effects = v_start_effects
