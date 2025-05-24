extends Control

@onready var l_duration = %Duration
@onready var l_name = %Name
@onready var l_description = %Description
@onready var background = %Background


func setup(effect: Effect) -> void:
	l_name.text = effect.name
	l_name.modulate = effect.color_text
	l_description.text = effect.description
	l_description.modulate = effect.color_text
	var dur = str(effect.duration) if effect.duration > 0 else "A"
	l_duration.text = dur
	l_duration.modulate = effect.color_text
	
	background.color = effect.color_bg
