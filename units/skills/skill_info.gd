extends Control

@onready var l_name = %Name
@onready var l_CD = %CD
@onready var l_cooldown = %Cooldown
@onready var l_description = %Description
@onready var background = %Background
@onready var button = %Button

@onready var lines = [%Line, %Line2]

var skill: Skill
var active: bool 

func setup(s, v_active) -> void:
	if not s: return
	skill = s
	active = v_active
	
	l_name.text = skill.name
	l_name.modulate = skill.color_text

	l_CD.modulate = skill.color_text

	l_cooldown.text = str(skill.actual_cooldown)
	l_cooldown.modulate = skill.color_text

	l_description.text = skill.description
	l_description.modulate = skill.color_text

	background.color = skill.color_bg

	button.disabled = skill.cant_use()

	
	if not active or button.disabled: 
		for l in lines:
			l.visible = true
		return 
	else:
		for l in lines:
			l.visible = false


	
	if button.pressed.is_connected(try_activate):
		button.pressed.disconnect(try_activate)

	button.pressed.connect(try_activate)

func try_activate() -> void:
	if skill.cant_use(): return
	skill.activate()
	button.disabled = true
	if skill.uses != 0: setup(skill, active)
	else: queue_free()
	
