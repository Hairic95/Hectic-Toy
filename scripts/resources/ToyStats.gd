extends Resource
class_name ToyStats

export (String) var toy_name

export (Texture) var toy_sprite

export (int) var max_hit_points = 100
export (int) var hit_points = 100

export (int) var physical_defense = 1
export (int) var ranged_defense = 1
export (int) var special_defense = 1

export (int) var speed = 1

export (Array) var actions = []

var status : Array = []

var buffs : Array = [
	{
		stat = "attack",
		variation = 0
	},
	{
		stat = "defense",
		variation = 0
	},
	{
		stat = "speed",
		variation = 0
	}
]

func init():
	for i in actions.size():
		var new_action = actions[i].duplicate()
		new_action.init()
		actions[i] = new_action

func add_status(status_effect):
	
	for i in range(status.size()):
		if status[i].status == status_effect.status:
			status[i].duration += status_effect.duration
			return status[i]
	
	status.append(status_effect.duplicate())
	return status_effect

func add_buff(stat, value):
	for i in range(buffs.size()):
		if buffs[i].stat == stat:
			buffs[i].variation = clamp(buffs[i].variation + value, -4, 4)
			return

func get_buff_variation(stat):
	for buff in buffs:
		if buff.stat == stat:
			return buff.variation
	return 0

func has_status(searched_status):
	for effect in status:
		if effect.status == searched_status:
			return true
	return false

func fully_heal():
	hit_points = max_hit_points
	
	for action in actions:
		action.restore_uses()
	
	status = []
	buffs = [
		{
			stat = "attack",
			variation = 0
		},
		{
			stat = "defense",
			variation = 0
		},
		{
			stat = "speed",
			variation = 0
		}
	]
