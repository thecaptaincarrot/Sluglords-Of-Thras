extends Node

export (PackedScene) var Attack

var gold_production = 0
var corpse_production = 0
var contagion_production = 0

var gold
var corpses
var contagion

var color = Color(1.0,0,1.0,0.25)

var avatar = {"Eyes" : 0, "Mouth" : 0, "Hat" : 0, "Clothes" : 0}
var sloadname = "N'gasta"

var is_player = false

var territory_islands = []
var territory_hexes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	name = sloadname


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initialize_new_faction():
	gold = 5000
	corpses = 5000
	contagion = 5000


func clear_faction():
	gold = 5000
	corpses = 5000
	contagion = 5000
	
	for island in territory_islands:
		island.clear_owner()
	
	territory_islands.clear()
	territory_hexes.clear()

func take_ownership(island):
	island.faction_owner = self
	territory_islands.append(island)
	
	var hexes = island.hexes
	for hex in hexes:
		hex.faction_owner = self
		territory_hexes.append(hex)
		hex.ColorHex.color = color
		
		
	print(sloadname + " took control of " + island.name + " island.")


func update_production():
	
	for hex in territory_hexes:
		hex.update_production()


func collect_production():
	for hex in territory_hexes:
		hex.update_production()
		gold += hex.gold_production
		corpses += hex.corpse_production
		contagion += hex.contagion_production


func end_of_turn():
	#check timed events
	#generate an event maybe -- do NPCs get events?
	#move armies and resolve battles
	update_production()
	collect_production()
	#construct buildings - done on island level


func build_payment(building):
	#should we double check right now to make sure the resources are available?
	#Maybe
	gold = gold - building.gold_cost
	corpses = corpses - building.corpse_cost
	contagion = contagion - building.contagion_cost


func recruit_payment(undead):
	#should we double check right now to make sure the resources are available?
	#Maybe
	gold = gold - undead.gold_cost
	corpses = corpses - undead.corpses_cost
	contagion = contagion - undead.contagion_cost

#this returns the attack so it can be parented elsewhere
func create_new_attack():
	var new_attack = Attack.instance()
	new_attack.faction = self
	if is_player:
		new_attack.is_player = true
	
	return new_attack
	
