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

onready var information = preload("res://Scenes/UI/Game/InformationUI.tscn")

var selected : String = "none"

const skins = [
	"res://Assets/Player/Base Skins/KoC_female1-Sheet.png",
	"res://Assets/Player/Base Skins/KoC_male1-Sheet.png",
	"res://Assets/Player/Base Skins/KoC_male2-Sheet.png",
	"res://Assets/Player/Base Skins/KoC_male3-Sheet.png"
]

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
	
	
	preset_inventory(starting_class)
	TownStats.set_market()
	get_tree().get_root().find_node("Player", true, false).set_location()
	change_skin(skins[randi() % 3])

func preset_inventory(preset_id):
	if preset_id < 3:
		for i in 5:
				inventory.cards[i] = load("res://Assets/UI/Inventory/Gold.tres")
	else:
		for i in 3:
				inventory.cards[i] = load("res://Assets/UI/Inventory/Bread.tres")
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
	if inventory.cards.has(load("res://Assets/UI/Inventory/RoyalGold.tres")):
		for i in round(amount / 3) + 1:
			remove_card(load("res://Assets/UI/Inventory/RoyalGold.tres"))
			for e in 3:
				add_card(load("res://Assets/UI/Inventory/Gold.tres"))
	for i in amount:
		remove_card(load("res://Assets/UI/Inventory/Gold.tres"))
	update_inventory()

func remove_card(card):
	inventory.cards.erase(card)
	inventory.cards.append(null)
	update_inventory()

func update_inventory():
	if get_tree().get_root().find_node("InventoryUI", true, false) != null:
		get_tree().get_root().find_node("InventoryUI", true, false).update()
	if get_tree().get_root().find_node("ChestUI", true, false) != null:
		get_tree().get_root().find_node("ChestUI", true, false).update()
	count_gold()

func count_gold():
	gold = inventory.cards.count(load("res://Assets/UI/Inventory/Gold.tres")) + inventory.cards.count(load("res://Assets/UI/Inventory/RoyalGold.tres")) * 3

func food_eaten(food):
	if food in TownStats.item_list: if life < 2: life += 1
	get_tree().get_root().find_node("Status", true, false).update_display()
	show_alert(2)
func change_skin(skinPath):
	get_tree().get_root().find_node("Player", true, false).update_skin(skinPath)

func show_alert(id):
	alert_id = id
	get_tree().get_root().find_node("World", true, false).add_child(information.instance())
