extends ColorRect

var shopslot = preload("res://Scenes/UI/Game/ShopItem.tscn")

onready var shop_list = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer
onready var desc = $Tooltip/Margin/VBox/HBox2/Text

onready var type = $Tooltip/Margin/VBox/HBox/Type
onready var Name = $Tooltip/Margin/VBox/HBox/Name

func _ready():
	$Tooltip/Panel/Button.text = "BUY"
	if TownStats.can_steal:
		$Tooltip/Panel2.visible = true
	PlayerStats.slot_selector = null
	TownStats.update_listing()
	for slot in TownStats.item_list.keys():
			if TownStats.item_list[slot][0] == PlayerStats.selected:
				shop_list.add_child(shopslot.instance())
	$MarginContainer/VBoxContainer/Title.text = str(PlayerStats.selected.capitalize()) + " Stall"
func _process(_delta):
	if not PlayerStats.slot_selector == null:
		card_tooltip(TownStats.current_list[PlayerStats.slot_selector])
		if PlayerStats.selected == "item":
			type.add_color_override("font_color", Color("42549c"))
		elif PlayerStats.selected == "food":
			type.add_color_override("font_color", Color("9e3f60"))
		elif PlayerStats.selected == "bank":
			type.add_color_override("font_color", Color("cfa365"))
	else:
		$Tooltip.visible = false
		Name.text = ""
		type.text = ""
		desc.text = ""

func card_tooltip(item):
	$Tooltip.visible = true
	Name.text = item
	type.text = PlayerStats.selected.capitalize()
	desc.text = ""

func update():
	for id in $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child_count():
		var shop_item = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child(id)
		shop_item.update_display()
		TownStats.update_listing()
