extends Node

var can_move = true

var luck : int

var starting_class : int
var sentence : int
var house_id : int
var gold : int

var life : int
var status : String
var can_eat = true

var slot_selector
var current_menu : String = "none"
var inventory = preload("res://Scripts/Systems/Inventory.tres")

var selected : String = "none"
func new_stats():
	life = 1
	status = "Good"
	get_tree().get_root().find_node("Status", true, false).update_display()
	randomize()
	luck = randi() % 100 + 1 #1-100
	print("luck: " + str(luck))
	luck = 80
	if luck < 16:
		starting_class = 3 #Prisoner
		if randi() % 100 < 21:
			sentence = randi() % 4 + 1 #1-4
		else:
			sentence = randi() % 2 + 1 #1-2
		print(str(sentence) + " days sentenced")
	elif luck < 41:
		starting_class = 2 #Homeless
	else:
		starting_class = 1 #Homeowner
		house_id = randi() % 5 + 1 #1-5
		house_id = 1
	preset_inventory(starting_class)
	TownStats.start_market()
	get_tree().get_root().find_node("Player", true, false).set_location()
	
func preset_inventory(preset_id):
	if preset_id < 3:
		for i in 4:
			if i < 3:
				inventory.cards[i] = load("res://Assets/UI/Inventory/Gold.tres")
			else:
				inventory.cards[i] = (load("res://Assets/UI/Inventory/Bread.tres"))
	else:
		for i in 4:
			if i < 3:
				inventory.cards[i] = load("res://Assets/UI/Inventory/Bread.tres")
			else:
				inventory.cards[i] = load("res://Assets/UI/Inventory/Gold.tres")
	count_gold()

func count_gold():
	gold = inventory.cards.count(load("res://Assets/UI/Inventory/Gold.tres"))

func add_card(card):
	var i = 0
	while inventory.cards[i] != null:
		i += 1
		if i > len(inventory.cards) - 1:
			inventory.add_slot()
			break
	inventory.cards[i] = load(card)
	count_gold()

# warning-ignore:unused_argument
func remove_gold(amount):
	for i in amount:
		inventory.cards.erase(load("res://Assets/UI/Inventory/Gold.tres"))
		inventory.cards.append(null)
func remove_card(card):
	var i = len(inventory.cards)
	while inventory.cards[i] == null:
		pass

func update_inventory():
	get_tree().get_root().find_node("InventoryUI", true, false).update()
	count_gold()
func food_eaten(food):
	if not food == "Soup":
		if life < 2:
			life += 1
	else:
		if life < 2:
			life = 2
	get_tree().get_root().find_node("Status", true, false).update_display()
