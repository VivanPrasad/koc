extends Control

var cost
var stock

onready var slot_name = $HBoxContainer/TextureRect/HBox/Name
onready var slot_icon = $HBoxContainer/TextureRect/HBox/Icon

onready var slot_cost = $HBoxContainer/TextureRect2/HBoxContainer/Cost
onready var slot_stock = $HBoxContainer/TextureRect3/Stock
func _ready():
	call_deferred("update_display")

func update_display():
	var id = get_index()
	if PlayerStats.selected == "food":
		slot_name.text = TownStats.food_list[id]
		slot_icon.texture = load("res://Assets/UI/Market/" + str(TownStats.food_list[id]) + ".png")
		slot_cost.text = str(TownStats.food_cost[id])
		slot_stock.text = str(TownStats.food_stock[id])
	elif PlayerStats.selected == "item":
		slot_name.text = TownStats.item_list[id]
		slot_icon.texture = load("res://Assets/UI/Market/" + str(TownStats.item_list[id]) + ".png")
		slot_cost.text = str(TownStats.item_cost[id])
		slot_stock.text = str(TownStats.item_stock[id])
		
	elif PlayerStats.selected == "bank":
		slot_name.text = TownStats.bank_list[id]
		slot_icon.texture = load("res://Assets/UI/Market/" + str(TownStats.bank_list[id]) + ".png")
		slot_cost.text = str(TownStats.bank_cost[id])
		slot_stock.text = str(TownStats.bank_stock[id])
	
	if int(slot_cost.text) > PlayerStats.gold:
		slot_name.add_color_override("font_color", Color("696969"))
	if int(slot_stock.text) == 0:
		slot_name.add_color_override("font_color", Color("696969"))
func daily_supply():
	pass

func _on_TextureRect_toggled(_button_pressed):
	if PlayerStats.slot_selector != get_index():
		PlayerStats.slot_selector = get_index()
		$Selector.visible = true
		for slot in get_parent().get_child_count():
			if slot == get_index():
				pass
			else:
				get_parent().get_child(slot).get_child(0).visible = false
	else:
		PlayerStats.slot_selector = null
		$Selector.visible = false
	#slot_stock.text = str(int(slot_stock.text)-1)
	#PlayerStats.gold -= int(slot_cost.text)
