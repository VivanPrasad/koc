extends Node

var can_move = true
var sleeping : bool = false
var luck : int

var starting_class : int
var names = ["","Homeowner","Housekeeper","Prisoner","Undead","Spirit"]
var sentence : Array
var house_id : int
var gold : int

var life : int
var status : String
const base_speed = 127.5
var input_vector = Vector2.ZERO

var speed = base_speed
var can_eat = true
var can_sleep = false

var slot_selector
var current_menu : String = "none"
onready var inventory = preload("res://Scripts/Systems/Inventory.tres")
var bed : Array
onready var information = preload("res://Scenes/UI/Game/InformationUI.tscn")

var selected : String = "none"
var locative : String

const alerts = [
	"You are hungry",
	"You are ill",
	"You are full",
	"It's getting dark",
	"The market is now open",
	"You feel better",
	"You have a bad feeling..."
]
var alert_id : int

func new_stats():
	life = 1; status = "Good"
	get_tree().get_root().find_node("Status", true, false).update_display()
	randomize()
	luck = randi() % 100+1
	luck = 90
	if luck < 16:
		starting_class = 3 #Prisoner
		if randi() %100 < 21:
			sentence = [randi()%4+1,null]
		else:
			sentence = [randi()%2+1,null]
		TownStats.set_sentence(sentence[0], self)
		locative = "dungeon"
	elif luck < 41:
		starting_class = 2 #Homeless
		locative = "town"
	else:
		starting_class = 1 #Homeowner
		house_id = randi() % 6+1 #1-6
		locative = "town"

	preset_inventory(starting_class)
	get_tree().get_root().find_node("Player", true, false).set_location()

func preset_inventory(preset_id):
	if preset_id == 3:
		for i in 3:
				inventory.cards[i] = load("res://Assets/UI/Cards/Bread.tres")
	else:
		var starter = Card.new()
		starter.name = "Starter Kit"; starter.type = "Item"; starter.desc = "Gives 1 bread and 4 gold. Good Luck.";
		starter.properties["use"] = {"get_cards":{"Bread":1,"Gold":4}}
		inventory.cards[0] = starter
	update_inventory()

func add_variant_card(card):
	var starter = card["properties"]["variant"]
	print(starter)
func get_cards(cards):
	for card in cards:
		var i = 0
		while inventory.cards[i] != null:
			i += 1
			if i > len(inventory.cards) - 1:
				inventory.add_slot()
				break
		for amount in cards[card]:
			add_card(card)
	update_inventory()
func add_card(card):
	var i = 0
	while inventory.cards[i] != null:
		i += 1
		if i > len(inventory.cards) - 1:
			inventory.add_slot()
			break
	if card is Card:
		inventory.cards[i] = card
	else:
		inventory.cards[i] = load("res://Assets/UI/Cards/" + str(card) + ".tres")
	update_inventory()

func mod_inv(value):
	inventory.call_deferred(value[0], value[1])
func max_hand(value):
	inventory.max_hand += value
	for i in value:
		inventory.add_slot()
func remove_gold(amount):
	for i in amount:
		remove_card(load("res://Assets/UI/Cards/Gold.tres"))
	update_inventory()

func remove_card(card):
	inventory.cards.erase(card)
	inventory.cards.append(null)
	update_inventory()

func update_inventory():
	if get_node_or_null("/root/World/UI/InventoryUI/") != null:
		get_node_or_null("/root/World/UI/InventoryUI/").update()
	if get_node_or_null("/root/World/UI/ChestUI/") != null:
		get_node_or_null("/root/World/UI/ChestUI/").update()
	count_gold()

func count_gold():
	gold = inventory.cards.count(load("res://Assets/UI/Cards/Gold.tres"))

func change_status(o):
	status = str(o)
	show_alert(5)
	print(status)
	
func gain_life(value):
	if life < 2: life += value
	if get_node_or_null("/root/World/UI/DayInfo/Status/") != null:
		get_node_or_null("/root/World/UI/DayInfo/Status/").update_display()
	show_alert(2)

func change_skin(skinPath):
	get_tree().get_root().find_node("Player", true, false).update_skin(skinPath)

func show_alert(id):
	alert_id = id
	get_tree().get_root().find_node("World", true, false).add_child(information.instance())

func good_night():
	Transition.sleep_blackout()
	print("good night my little one...")
	bed[1].get_child(3).queue_free()
	current_menu = "sleep"
	sleeping = true
