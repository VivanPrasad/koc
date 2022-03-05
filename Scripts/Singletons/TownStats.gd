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

var vacant = [1,2,3,4,5]
var cells = [0,0,0,0]

const events = [
	"food_bank",
	"festival",
	"tax",
	"birthday",
	"bounty",
	"werewolves",
	"outbreak",
	"triple_triumph",
	"the_culling",
	"double_event",
	"new_order",
	"blood_moon",
	"plague",
]
const forecast = [
	"clear",
	"snowstorm",
	"heat_wave",
	"thunderstorm",
]
func update_market():
	if get_tree().get_root().find_node("MarketUI", true, false) != null:
		get_tree().get_root().find_node("MarketUI", true, false).update()
func set_market():
	yield(get_tree().create_timer(0), "timeout")
	set_bank_shop()
	register_item("Bread", "food", int(2 + floor(0.4 * day) - wealth), int(population * 2))
	register_item("Bag", "item", int(5 - wealth), int(round(0.4*population)))
	register_item("Lantern", "item", int(3 - wealth), int(round(0.8*population)))
	register_item("Key", "item", int(1 + floor(0.4*day) - wealth), int(population - 2))

func set_bank_shop():
	yield(get_tree().create_timer(0), "timeout")
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
		
		if get_tree().get_root().find_node("World", true, false) != null:
			get_tree().get_root().find_node("GoldPot", true, false).get_child(0).frame = wealth + 3

func open_town():
	set_market()
	for item in item_list:
		pass
		#print(item)
	update_item_cost("Bread", int(2+floor(0.4 * day) - wealth))
	
	if day == 2:
		register_item("Berry", "food", int(2 + floor(0.4 * day) - wealth), 1)

func register_item(Name, market, cost, stock):
	item_list[Name] = [market,cost,stock]

func unregister_item(Name):
	item_list.erase(Name)

func update_item_cost(Name, value):
	item_list[Name][1] = value

func update_listing():
	current_list = []
	for slot in TownStats.item_list.keys():
		if TownStats.item_list[slot][0] == PlayerStats.selected:
			current_list.append(slot)

func update_sentence(time, cell):
	cells[cell] = time
	if time == 0:
		PlayerStats.sentence[1] = null
		PlayerStats.starting_class = 2

func set_sentence(time):
	if cells.has(0):
		for i in cells:
			print(i)
			if i == 0:
				cells[i] = time
				PlayerStats.sentence[1] = i
				break
