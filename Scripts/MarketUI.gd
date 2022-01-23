extends ColorRect

var shopslot = preload("res://Scenes/UI/ShopItem.tscn")
const card_types = {"Food": ["Bread", "Berry", "Cookie", "Soup"], "Item": ["Bag", "Lantern", "Key", "Basket", "Medicine", "Potion", "Soulstone"], "Wealth" : ["Gold", "RoyalGold"]}
var info = PlayerStats.slot_selector
var card_name : String
onready var shop_list = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer
onready var tooltip_text = $Tooltip/Margin/VBox/HBox2/Text

func _ready():
	$Tooltip/Panel/Button.text = "BUY"
	if TownStats.can_steal:
		$Tooltip/Panel2.visible = true
	PlayerStats.slot_selector = null
	if PlayerStats.selected == "item":
		$MarginContainer/VBoxContainer/Title.text = "Item Store"
		for slot in TownStats.item_list:
			shop_list.add_child(shopslot.instance())
	elif PlayerStats.selected == "food":
		for slot in TownStats.food_list:
			shop_list.add_child(shopslot.instance())
		$MarginContainer/VBoxContainer/Title.text = "Food Market"
	elif PlayerStats.selected == "bank":
		for slot in TownStats.bank_list:
			shop_list.add_child(shopslot.instance())
		$MarginContainer/VBoxContainer/Title.text = "Bank"
func _process(_delta):
	info = PlayerStats.slot_selector
	if not PlayerStats.slot_selector == null:
		if PlayerStats.selected == "item":
			card_name = TownStats.item_list[info]
			$Tooltip/Margin/VBox/HBox/Type.text = "Item"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("42549c"))
		elif PlayerStats.selected == "food":
			card_name = TownStats.food_list[info]
			$Tooltip/Margin/VBox/HBox/Type.text = "Food"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("9e3f60"))
		elif PlayerStats.selected == "bank":
			card_name = TownStats.bank_list[info]
			$Tooltip/Margin/VBox/HBox/Type.text = "Upgrade"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("cfa365"))
		card_tooltip(card_name)
	else:
		$Tooltip/Margin/VBox/HBox/Name.text = ""
		$Tooltip/Margin/VBox/HBox/Type.text = ""
		tooltip_text.text = ""
		$Tooltip.visible = false
func card_tooltip(info_name):
	$Tooltip.visible = true
	$Tooltip/Margin/VBox/HBox/Name.text = info_name
	if info_name == "Bread":
		tooltip_text.text = "+1 Life"
	elif info_name == "Bag":
		tooltip_text.text = "+5 Inventory Slots."
	elif info_name == "Lantern":
		tooltip_text.text = "Wards off evil spirits."
	elif info_name == "Key":
		tooltip_text.text = "Used to escape the dungeon."
	elif info_name == "House":
		tooltip_text.text = "Obtain a vacant house."
	elif info_name == "Old Chest":
		tooltip_text.text = "Store up to 5 cards."
	elif info_name == "New Chest":
		tooltip_text.text = "Store up to 10 cards."
	else:
		tooltip_text.text = ""

func update():
	for item in $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child_count():
		var shop_item = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child(item)
		shop_item.update_display()
