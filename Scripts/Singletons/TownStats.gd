extends Node

var population : int
var max_bank : int

var town_gold : int

var wealth : int

var item_list = {}
var current_list = []

var day = 1
var economy_started = false
var can_steal = true

var royalchest = 10
var vacant = [1, 2, 3, 4, 5]

func update_market():
	get_tree().get_root().find_node("MarketUI", true, false).update()

func start_market():
	yield(get_tree().create_timer(0), "timeout")
	update_bank_shop()
	register_item("Bread", "food", int(1+floor(0.4 * day)), int(population * 2))
	
	register_item("Bag", "item", int(5 - wealth), int(round(0.4*population)))
	register_item("Lantern", "item", int(3 - wealth), int(round(0.8*population)))
	register_item("Key", "item", int(2 + floor(0.4*day) - wealth), int(population - 2))

func update_bank_shop():
	yield(get_tree().create_timer(1), "timeout")
	if PlayerStats.starting_class > 1 and len(vacant) > 0:
		register_item("House", "bank", 8, int(bool(len(vacant))))
	if PlayerStats.starting_class == 1:
		if PlayerStats.house_id > 3:
			if get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false).get_child(0).disabled:
				register_item("Old Chest", "bank", 3, 1)
			elif get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false).get_child(1).frame == 0:
				register_item("New Chest", "bank", 6, 1)
		else:
			if get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false).get_child(1).frame == 0:
				register_item("New Chest", "bank", 6, 1)
func start_town_economy():
	economy_started = true
	population = randi() % 6 + 4 #4-9
	print("population: " + str(population))
	max_bank = population * 5
	town_gold = max_bank
func _physics_process(_delta):
	if economy_started == true:
		if float(town_gold)/max_bank == 0:
			wealth = -3
		elif float(town_gold)/max_bank <= 0.25:
			wealth = -2
		elif float(town_gold)/max_bank <= 0.50:
			wealth = -1
		elif float(town_gold)/max_bank <= 1:
			wealth = 0
		elif float(town_gold)/max_bank <= 1.25:
			wealth = 1
		else:
			wealth = 2
		
		get_tree().get_root().find_node("GoldPot", true, false).get_child(0).frame = wealth + 3
func open_town():
	pass

func register_item(Name, market, cost, stock):
	item_list[Name] = [market,cost,stock]

func unregister_item(Name):
	item_list.erase(Name)

func update_listing():
	current_list = []
	for slot in TownStats.item_list.keys():
		if TownStats.item_list[slot][0] == PlayerStats.selected:
			current_list.append(slot)
