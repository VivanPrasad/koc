extends Control

onready var Name = $Panel/Margin/VBox/HBox/Name
onready var type = $Panel/Margin/VBox/HBox/Type
onready var desc = $Panel/Margin/VBox/HBox2/Text

onready var button = $Panel/VBoxContainer/Panel/Button
onready var button2 = $Panel/VBoxContainer/Panel2/Button2

const color_type = {"Item":"42549c", "Food":"9e3f60", "Wealth":"cfa365", "Role":"386e4b", "Special":"cccccc", "":""}
var id

var mode = 0
func _ready():
	PlayerStats.slot_selector = null
	button.focus_mode = 0
	button2.focus_mode = 0
	if get_parent().name == "ChestUI":
		pass#mode = 0

func _process(_delta):
	id = PlayerStats.slot_selector
	if not PlayerStats.current_menu in ["bank","market"]:
		if not id == null:
			if PlayerStats.current_menu.begins_with("chest"):
				$Shadow/Panel3.visible = false
				$Panel/VBoxContainer.visible = false
			if id < len(PlayerStats.inventory.cards):
				card_info(PlayerStats.inventory.cards[id])
				if not PlayerStats.inventory.cards[id].properties["use"].empty():
					$Panel/VBoxContainer/Panel2.visible = true
					if PlayerStats.inventory.cards[id].properties["use"].has("gain_life"):
						button2.text = "EAT"
						if PlayerStats.can_eat:
							button2.disabled = false
						else:
							button2.disabled = true
					elif PlayerStats.inventory.cards[id].type == "Item":
						button2.disabled = false
						button2.text = "USE"
				else:
					$Panel/VBoxContainer/Panel2.visible = false
			else:
				card_info(TownStats.inv_res.cards[id - len(PlayerStats.inventory.cards)])
		else:
			visible = false
	elif PlayerStats.current_menu == "market":
		if not id == null:
				var get_card = load("res://Assets/UI/Cards/" + str(TownStats.current_list[PlayerStats.slot_selector]) + ".tres")
				card_info(get_card)
func card_info(item):
	if item != null:
		visible = true
		if not PlayerStats.current_menu in ["bank",null]:
				Name.text = item.name
				type.text = item.type
				desc.text = item.desc
				type.add_color_override("font_color", Color(color_type[item.type]))
func _on_Button_pressed(): #BUY OR DROP
	id = PlayerStats.slot_selector
	if PlayerStats.current_menu == "inv": 
		PlayerStats.slot_selector = null
		PlayerStats.remove_card(PlayerStats.inventory.cards[id])
	elif PlayerStats.selected in ["food", "item", "bank", "role"]:
			if TownStats.item_list[TownStats.current_list[id]][2] > 0:
				if TownStats.item_list[TownStats.current_list[id]][1] > PlayerStats.gold:
					button.disabled = true
				else:
					PlayerStats.remove_gold(TownStats.item_list[TownStats.current_list[id]][1])
					TownStats.item_list[TownStats.current_list[id]][2] -= 1
					if PlayerStats.selected != "bank":
						PlayerStats.add_card(load("res://Assets/UI/Cards/" + str(TownStats.current_list[id]) + ".tres"))
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
		print(PlayerStats.inventory.cards[id].properties["use"])
		for command in PlayerStats.inventory.cards[id].properties["use"]:
			if PlayerStats.has_method(command):
				PlayerStats.call_deferred(command, PlayerStats.inventory.cards[id].properties["use"][command])
		PlayerStats.remove_card(PlayerStats.inventory.cards[id])
