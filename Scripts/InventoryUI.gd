extends ColorRect

var inventory = preload("res://Scripts/Systems/Inventory.tres")

const card_types = {"Food": ["Bread", "Berry", "Cookie", "Soup"], "Item": ["Bag", "Lantern", "Key", "Basket", "Medicine", "Potion", "Soulstone"], "Wealth" : ["Gold", "RoyalGold"]}
var info = PlayerStats.slot_selector

onready var tooltip_text = $Tooltip/Margin/VBox/HBox2/Text
var card_name : String

func _ready():
	$Tooltip.visible = false
	PlayerStats.slot_selector = null
	$Tooltip/Panel/Button.text = "DROP"
func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")
func drop_data(_position, data):
	inventory.set_item(data.card_index, data.card)

func _process(_delta):
	info = PlayerStats.slot_selector
	if not PlayerStats.slot_selector == null and inventory.cards[info] != null:
		$Tooltip/Margin/VBox/HBox/Name.text = inventory.cards[info].name
		if inventory.cards[info].name in card_types["Food"]:
			card_name = inventory.cards[info].name
			$Tooltip/Margin/VBox/HBox/Type.text = "Food"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("9e3f60"))
			$Tooltip/Panel2.visible = true
			$Tooltip/Panel2/Button2.text = "EAT"
		elif inventory.cards[info].name in card_types["Item"]:
			card_name = inventory.cards[info].name
			$Tooltip/Margin/VBox/HBox/Type.text = "Item"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("42549c"))
			$Tooltip/Panel2.visible = true
			$Tooltip/Panel2/Button2.text = "USE"
		elif inventory.cards[info].name in card_types["Wealth"]:
			card_name = inventory.cards[info].name
			$Tooltip/Margin/VBox/HBox/Type.text = "Wealth"
			$Tooltip/Margin/VBox/HBox/Type.add_color_override("font_color", Color("cfa365"))
			$Tooltip/Panel2.visible = false
		card_tooltip(card_name)
	else:
		$Tooltip/Margin/VBox/HBox/Name.text = ""
		$Tooltip/Margin/VBox/HBox/Type.text = ""
		tooltip_text.text = ""
		$Tooltip.visible = false
		$Tooltip/Panel2.visible = false
	
	if PlayerStats.can_eat and $Tooltip/Panel2/Button2.text == "EAT":
		$Tooltip/Panel2/Button2.disabled = false
	else:
		$Tooltip/Panel2/Button2.disabled = true

func card_tooltip(info_name):
	$Tooltip.visible = true
	if info_name == "Gold":
		tooltip_text.text = "Used to purchase things."
	elif info_name == "Bread":
		tooltip_text.text = "+1 Life"
	elif info_name == "Bag":
		tooltip_text.text = "+5 Inventory Slots"
	elif info_name == "Lantern":
		tooltip_text.text = "Wards off evil spirits."
	elif info_name == "Key":
		tooltip_text.text = "Used to escape the dungeon."

func update():
	for item in $CenterContainer/SlotsDisplay.get_child_count():
		var inv_item = $CenterContainer/SlotsDisplay.get_child(item)
		inv_item.display_card(PlayerStats.inventory.cards[item])
		PlayerStats.slot_selector = null
