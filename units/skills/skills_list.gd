extends VBoxContainer

@onready var unit = $".."

var skills : Array[Skill]


var skill_info = preload("res://units/skills/skill_info.tscn")

func skills_list():
	self.visible = !self.visible
	if self.visible:
		for skill in skills:
			var i = skill_info.instantiate()
			self.add_child(i)
			i.setup(skill)
	else:
		for child in self.get_children():
			child.queue_free()
