extends Node

var can_move = true
var sleeping : bool = false
var luck : int

var starting_class : int
var sentence : Array
var house_id : int
var gold : int

var life : int
var status : String
var can_eat = true
var can_sleep = false

var slot_selector
var current_menu : String = "none"
var inventory = preload("res://Scripts/Systems/Inventory.tres")
var chest = preload("res://Scripts/Systems/Chest.tres")
var bed : Array
onready var information = preload("res://Scenes/UI/Game/InformationUI.tscn")

var selected : String = "none"


const alerts = [
	"You are hungry",
	"You are ill",
	"You are full",
	"It's getting dark",
	"The market is now open"
]
var alert_id : int

func new_stats():
	life = 1; status = "Good"
	get_tree().get_root().find_node("Status", true, false).update_display()
	randomize()
	luck = randi() % 100+1
	if luck < 16:
		starting_class = 3 #Prisoner
		if randi() %100 < 21:
			sentence = [randi()%4+1,null]
		else:
			sentence = [randi()%2+1,null]
		TownStats.set_sentence(sentence[0])
	elif luck < 41:
		starting_class = 2 #Homeless
	else:
		starting_class = 1 #Homeowner
		house_id = randi() % 5+1 #1-5
	
	TownStats.set_market()
	preset_inventory(starting_class)
	get_tree().get_root().find_node("Player", true, false).set_location()

func preset_inventory(preset_id):
	if preset_id < 3:
		for i in 5:
				inventory.cards[i] = load("res://Assets/UI/Cards/Gold.tres")

	else:
		for i in 3:
				inventory.cards[i] = load("res://Assets/UI/Cards/Bread.tres")
	update_inventory()

func add_card(card):
	var i = 0
	while inventory.cards[i] != null:
		i += 1
		if i > len(inventory.cards) - 1:
			inventory.add_slot()
			break
	inventory.cards[i] = card
	update_inventory()

func add_to_chest(card):
	remove_card(inventory.cards[slot_selector])
	var i = 0
	while chest.cards[i] != null:
		i += 1
		if i > len(chest.cards) - 1:
			chest.add_slot()
			break
	chest.cards[i] = card
	update_inventory()
func take_card(card):
	chest.cards.erase(card)
	chest.cards.append(null)
	add_card(card)
	update_inventory()
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

func food_eaten(food):
	if food in TownStats.item_list: if life < 2: life += 1
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
