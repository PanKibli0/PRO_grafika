extends VBoxContainer

@onready var unit = $".."

var skills : Array[Skill]


var skill_info = preload("res://units/skills/skill_info.tscn")

func create_list(active=true):
	skills = skills.filter(func(s):
		return s.uses != 0
	)
	
	self.visible = !self.visible
	if self.visible:
		for skill in skills:
			var i = skill_info.instantiate()
			self.add_child(i)
			i.setup(skill, active)
	else:
		for child in self.get_children():
			child.queue_free()
			
func tick_cooldown() -> void:
	for sk in skills:
		if sk.actual_cooldown > 0:
			sk.actual_cooldown -= 1
