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
