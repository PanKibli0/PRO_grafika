extends Control

@onready var l_name = %Name
@onready var l_CD = %CD
@onready var l_cooldown = %Cooldown
@onready var l_description = %Description
@onready var background = %Background
@onready var button = %Button

var skill: Skill

func setup(s) -> void:
	if not s:
		return
	skill = s

	l_name.text = skill.name
	l_name.modulate = skill.color_text

	l_CD.modulate = skill.color_text

	l_cooldown.text = str(skill.actual_cooldown)
	l_cooldown.modulate = skill.color_text

	l_description.text = skill.description
	l_description.modulate = skill.color_text

	background.color = skill.color_bg

	button.disabled = skill.cant_use()

	if button.pressed.is_connected(try_activate):
		button.pressed.disconnect(try_activate)

	button.pressed.connect(try_activate)

func try_activate() -> void:
	if skill.cant_use(): return
	skill.activate()
	setup(skill)
	button.disabled = true
