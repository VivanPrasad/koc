extends Node

var population : int
var max_bank : int

var town_gold : int

var wealth : int
var food_list = ["Bread"]
var food_cost = []
var food_stock = []

var item_list = ["Bag", "Lantern", "Key"]
var item_cost = []
var item_stock = []

var bank_list = []
var bank_cost = []
var bank_stock = []

var day = 1
var economy_started = false
var can_steal = true

var vacant = 5

func update_market():
	get_tree().get_root().find_node("MarketUI", true, false).update()

func start_market():
	yield(get_tree().create_timer(0), "timeout")
	if PlayerStats.starting_class > 1 and vacant > 0:
		bank_list.append("House")
	if PlayerStats.starting_class == 1:
		if PlayerStats.house_id > 3:
			bank_list.append("Old Chest")
		else:
			bank_list.append("New Chest")
	
	food_cost = [int(1 + floor(0.4*day) - wealth)]
	food_stock = [int(population * 2)]
	item_cost = [int(5 - wealth),int(3 - wealth), int(2 + floor(0.4*day) - wealth)]
	item_stock = [int(round(0.4*population)), int(round(0.8*population)), int(population - 2)]
	
	for item in bank_list:
		if item == "House":
			bank_cost.append(8)
			bank_stock.append(vacant)
		if item == "Old Chest":
			bank_cost.append(3)
			bank_stock.append(1)
		elif item == "New Chest":
			bank_cost.append(6)
			bank_stock.append(1)

func start_town_economy():
	economy_started = true
	population = randi() % 2 + 4 #4-5
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
	else:
		pass
func new_day():
	pass
func open_town():
	print("open_town recieved")
	if day == 2:
		food_list.append("Berry")
		food_cost.append(int(2 - wealth))
		food_stock.append(population)
	elif day == 3:
		food_list.append("Soup")
		food_cost.append()
		food_stock.append()
		
		item_list.append("Basket")
		item_cost.append(int(2 + floor(0.4*day) - wealth))
		item_stock.append(int(population - 1))
	elif day == 6:
		food_list.append("Cookie")
		food_cost.append()
		food_stock.append()
