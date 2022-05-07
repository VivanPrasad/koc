extends ColorRect

var shopslot = load("res://Scenes/UI/Game/ShopItem.tscn")

onready var shop_list = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer
onready var desc = $Tooltip/Panel/Margin/VBox/HBox2/Text

onready var type = $Tooltip/Panel/Margin/VBox/HBox/Type
onready var Name = $Tooltip/Panel/Margin/VBox/HBox/Name

func _ready():
	$Tooltip/Panel/VBoxContainer/Panel/Button.text = "BUY"
	if TownStats.can_steal:
		$Tooltip/Panel/VBoxContainer/Panel2.visible = true
	PlayerStats.slot_selector = null
	TownStats.update_listing()
	for slot in TownStats.item_list.keys():
			if TownStats.item_list[slot][0] == PlayerStats.selected:
				shop_list.add_child(shopslot.instance())
	$MarginContainer/VBoxContainer/Title.text = str(PlayerStats.selected.capitalize()) + " Stall"

func update():
	for id in $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child_count():
		var shop_item = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer.get_child(id)
		shop_item.update_display()
		TownStats.update_listing()
