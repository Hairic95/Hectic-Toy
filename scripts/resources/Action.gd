extends Resource
class_name Action

export (String) var action_name = "Missing string"
export (String) var description = ""
export (String, "physical", "ranged", "special", "status") var action_type = "physical"
export (int, 0, 200) var power = 0
export (int, 0, 20) var max_uses = 1
#try to make it always equal to max_uses
export (int, 0, 20) var current_uses = 1
export (Array) var effects = []
export (Array) var self_effects = []

func init():
	for i in effects.size():
		effects[i] = effects[i].duplicate()
	for i in self_effects.size():
		self_effects[i] = self_effects[i].duplicate()

func restore_uses():
	current_uses = max_uses
