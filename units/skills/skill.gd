class_name Skill
extends Resource

var name: String = "Unnamed Skill"
var description: String = "DESC"
var color_text: Color = Color.WHITE
var color_bg: Color = Color.DIM_GRAY


@export var cooldown: int = 0
@export var actual_cooldown: int = 0



func cant_use() -> bool:
	return actual_cooldown != 0

func activate() -> void:
	print_rich("[color=gray]Activate skill: [/color] %s" % name)
