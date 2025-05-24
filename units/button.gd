extends Button


	

func _on_pressed() -> void:
	print("SKILL1")
	%SkillsList.skills[0].activate()
	self.disabled = true
