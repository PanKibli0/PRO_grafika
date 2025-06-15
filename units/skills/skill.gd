class_name Skill
extends Resource

var name: String = "Unnamed Skill"
var description: String = "DESC"
var color_text: Color = Color.WHITE
var color_bg: Color = Color.DIM_GRAY


@export var cooldown: int = 5
@export var actual_cooldown: int = 0

func tick_cooldown() -> void:
	if actual_cooldown > 0:
		actual_cooldown -= 1

func cant_use() -> bool:
	return actual_cooldown != 0

func activate() -> void:
	if cant_use(): return
	print_rich("[color=pink]Activate skill: [/color] %s" % name)
	actual_cooldown = cooldown
