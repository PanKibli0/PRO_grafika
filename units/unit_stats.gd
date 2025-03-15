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
