extends Control

@onready var l_duration = %Duration
@onready var l_name = %Name
@onready var l_description = %Description
@onready var background = %Background


func setup(name_text: String, description_text: String, duration_text: String, color_var: bool) -> void:
	l_name.text = name_text
	l_description.text = description_text
	l_duration.text = duration_text
	background.color = Color("5B3E96") if color_var else Color("#7D63C1")
