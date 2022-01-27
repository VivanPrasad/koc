extends Panel

var id
var menu
func _ready():
	$Panel/Button.focus_mode = 0
	$Panel2/Button2.focus_mode = 0
	id = PlayerStats.slot_selector
	menu = PlayerStats.selected
func _on_Button_pressed():
	id = PlayerStats.slot_selector
	if menu == "none" and PlayerStats.current_menu == "inv":
		PlayerStats.inventory.cards.erase(PlayerStats.inventory.cards[id])
		PlayerStats.inventory.cards.append(null)
		PlayerStats.update_inventory()
	elif menu != "none" and PlayerStats.current_menu == "market":
		if menu == "food":
			if TownStats.food_stock[id] > 0:
				if TownStats.food_cost[id] > PlayerStats.gold:
					$Panel/Button.disabled = true
				else:
					PlayerStats.gold -= TownStats.food_cost[id]
					PlayerStats.remove_gold(TownStats.food_cost[id])
					TownStats.food_stock[id] -= 1
					PlayerStats.add_card("res://Assets/UI/Inventory/" + str(TownStats.food_list[id]) + ".tres")
					TownStats.update_market()
		elif menu == "item":
			if TownStats.item_stock[id] > 0:
				if TownStats.item_cost[id] > PlayerStats.gold:
					$Panel/Button.disabled = true
				else:
					PlayerStats.gold -= TownStats.item_cost[id]
					PlayerStats.remove_gold(TownStats.item_cost[id])
					TownStats.item_stock[id] -= 1
					PlayerStats.add_card("res://Assets/UI/Inventory/" + str(TownStats.item_list[id]) + ".tres")
					TownStats.update_market()
		elif menu == "bank":
			PlayerStats.gold -= TownStats.bank_cost[id]
			TownStats.bank_stock[id] -= 1
			PlayerStats.remove_gold(TownStats.bank_cost[id])
			if TownStats.bank_list[id] == "Old Chest":
				var chest = get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false)
				chest.visible = true
				chest.get_child(0).disabled = false
			elif TownStats.bank_list[id] == "New Chest":
				var chest = get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false)
				chest.get_child(1).frame = 1
			elif TownStats.bank_list[id] == "House":
				if len(TownStats.vacant) > 0:
					PlayerStats.house_id = TownStats.vacant[0]
					PlayerStats.starting_class = 1
					get_tree().get_root().find_node("DayInfo", true, false).set_class()
					TownStats.vacant.erase(PlayerStats.house_id)
					get_tree().get_root().find_node("Door" +  str(PlayerStats.house_id), true, false).link_house()
			TownStats.update_bank_shop()
			PlayerStats.slot_selector = null
			TownStats.bank_list.erase(TownStats.bank_list[id])
			TownStats.bank_cost.erase(TownStats.bank_cost[id])
			TownStats.bank_stock.erase(TownStats.bank_stock[id])
func _on_Button2_pressed():
	id = PlayerStats.slot_selector
	if $Panel2/Button2.text == "EAT":
		PlayerStats.food_eaten(PlayerStats.inventory.cards[id].name)
		PlayerStats.inventory.cards.erase(PlayerStats.inventory.cards[id])
		PlayerStats.inventory.cards.append(null)
		PlayerStats.update_inventory()

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Q:
			if PlayerStats.slot_selector != null:
				_on_Button_pressed()
