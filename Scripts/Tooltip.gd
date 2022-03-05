extends Panel

const markets = ["food", "item", "bank"]

onready var Name = $Margin/VBox/HBox/Name
onready var type = $Margin/VBox/HBox/Type
onready var desc = $Margin/VBox/HBox2/Text

onready var button = $Panel/Button
onready var button2 = $Panel2/Button2

var id

func _ready():
	button.focus_mode = 0
	button2.focus_mode = 0

func _process(_delta):
	id = PlayerStats.slot_selector
	if PlayerStats.current_menu == "inv":
		if not id == null:
			card_info(PlayerStats.inventory.cards[id].name, PlayerStats.current_menu)
			if PlayerStats.inventory.cards[id].type == "Item": type.add_color_override("font_color", Color("42549c"))
			elif PlayerStats.inventory.cards[id].type == "Food": type.add_color_override("font_color", Color("9e3f60"))
			elif PlayerStats.inventory.cards[id].type == "Wealth": type.add_color_override("font_color", Color("cfa365"))
			if PlayerStats.inventory.cards[id].type != "Wealth":
				$Panel2.visible = true
				if PlayerStats.inventory.cards[id].type == "Food":
					button2.text = "EAT"
					if PlayerStats.can_eat:
						button2.disabled = false
					else:
						button2.disabled = true
				elif PlayerStats.inventory.cards[id].type == "Item":
					button2.disabled = false
					button2.text = "USE"
			else:
				$Panel2.visible = false
		else:
			visible = false
			Name.text = ""
			type.text = ""
			desc.text = ""
	elif PlayerStats.current_menu == "market":
		if PlayerStats.selected == "item": type.add_color_override("font_color", Color("42549c"))
		elif PlayerStats.selected == "food": type.add_color_override("font_color", Color("9e3f60"))
		elif PlayerStats.selected == "bank": type.add_color_override("font_color", Color("cfa365"))
		if not PlayerStats.slot_selector == null:
			if PlayerStats.selected != "bank":
				var get_card = load("res://Assets/UI/Inventory/" + str(TownStats.current_list[PlayerStats.slot_selector]) + ".tres")
				card_info(get_card, "market")
			else:
				pass
func card_info(item, menu):
	visible = true
	if menu == "inv":
		Name.text = item
		type.text = PlayerStats.inventory.cards[PlayerStats.slot_selector].type
		desc.text = PlayerStats.inventory.cards[PlayerStats.slot_selector].desc
	elif menu == "market":
		if PlayerStats.selected != "bank":
			Name.text = item.name
			type.text = item.type
			desc.text = item.desc
		else:
			pass
func _on_Button_pressed(): #BUY OR DROP
	id = PlayerStats.slot_selector
	if PlayerStats.current_menu == "inv": 
		PlayerStats.slot_selector = null
		PlayerStats.remove_card(PlayerStats.inventory.cards[id])
	elif PlayerStats.selected in markets:
			if TownStats.item_list[TownStats.current_list[id]][2] > 0:
				if TownStats.item_list[TownStats.current_list[id]][1] > PlayerStats.gold:
					button.disabled = true
				else:
					PlayerStats.remove_gold(TownStats.item_list[TownStats.current_list[id]][1])
					TownStats.item_list[TownStats.current_list[id]][2] -= 1
					if PlayerStats.selected != "bank":
						PlayerStats.add_card(load("res://Assets/UI/Inventory/" + str(TownStats.current_list[id]) + ".tres"))
						TownStats.update_market()
					else:
						if TownStats.current_list[id] == "Old Chest":
							var chest = get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false)
							chest.visible = true
							chest.get_child(0).disabled = false
						elif TownStats.current_list[id] == "New Chest":
							var chest = get_tree().get_root().find_node("Chest" + str(PlayerStats.house_id), true, false)
							chest.get_child(1).frame = 1
						elif TownStats.current_list[id] == "House":
							if len(TownStats.vacant) > 0:
								PlayerStats.house_id = TownStats.vacant[0]
								PlayerStats.starting_class = 1
								get_tree().get_root().find_node("DayInfo", true, false).set_class()
								TownStats.vacant.erase(PlayerStats.house_id)
								get_tree().get_root().find_node("Door" +  str(PlayerStats.house_id), true, false).link_house()
						TownStats.update_listing()
						TownStats.unregister_item(TownStats.current_list[id])
						PlayerStats.slot_selector = null
func _on_Button2_pressed():
	id = PlayerStats.slot_selector
	if not id == null:
		PlayerStats.slot_selector = null
		if button2.text == "EAT":
			PlayerStats.food_eaten(PlayerStats.inventory.cards[id].name)
			PlayerStats.remove_card(PlayerStats.inventory.cards[id])
		elif button2.text == "USE":
			if PlayerStats.inventory.cards[id].name == "Bag":
				PlayerStats.inventory.max_hand = 10
				for i in 5:
					PlayerStats.inventory.add_slot()
				PlayerStats.remove_card(PlayerStats.inventory.cards[id])
