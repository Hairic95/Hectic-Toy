extends Node

var toy_references = {
	"astroshot": "res://resources/toys/AstroShot.tres",
	"beltedtraveller": "res://resources/toys/BeltedTraveller.tres",
	"demonknight": "res://resources/toys/DemonKnight.tres",
	"flogger": "res://resources/toys/Flogger.tres",
	"fungproof": "res://resources/toys/Fungproof.tres",
	"maskedgolem": "res://resources/toys/MaskedGolem.tres",
	"moonsaint": "res://resources/toys/MoonSaint.tres",
	"scarydino": "res://resources/toys/ScaryDino.tres",
	"twoofpentacles": "res://resources/toys/TwoOfPentacles.tres",
	"wingedshadow": "res://resources/toys/WingedShadow.tres"
}

var current_team = []

var stored_toys = []

var current_enemy_team = []

func _ready():
	#add_toy("astroshot")
	
	for toy in toy_references:
		add_toy(toy)
	set_current_toy(stored_toys[0])

func add_toy_from_resource(toy):
	var new_toy = toy.duplicate()
	new_toy.init()
	stored_toys.append(new_toy)

func add_toy(toy_id):
	var new_toy = load(toy_references[toy_id]).duplicate()
	new_toy.init()
	if current_team.size() >= 4:
		stored_toys.append(new_toy)
	else:
		stored_toys.append(new_toy)

func heal_team():
	for toy in current_team:
		toy.fully_heal()
	for toy in stored_toys:
		toy.fully_heal()

func set_current_toy(toy):
	current_team = []
	current_team.append(toy.duplicate())

var current_opponent = null
