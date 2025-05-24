class_name Skill
extends Resource

var name: String = ""
var description: String = ""

var cooldown: int = 0
var active_cooldown: int = 0

var is_activated: bool = false
var unit: Node = BATTLE.active_unit

func can_use() -> bool:
	return active_cooldown == 0

func activate() -> void:
	pass
