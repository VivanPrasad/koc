extends Control

onready var Name = $Tooltip/Panel/Margin/VBox/HBox/Name
onready var type = $Tooltip/Panel/Margin/VBox/HBox/Type
onready var desc = $Tooltip/Panel/Margin/VBox/HBox2/Text

onready var tooltip_text = $Tooltip/Panel/Margin/VBox/HBox2/Text
var card_name : String

func _ready():
	$Tooltip/Panel/VBoxContainer/Panel/Button.text = "DROP"
	PlayerStats.slot_selector = null

func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")
func drop_data(_position, data):
	PlayerStats.inventory.set_item(data.card_index, data.card)
	
func update():
	for id in $CenterContainer/SlotsDisplay.get_child_count():
		var inv_item = $CenterContainer/SlotsDisplay.get_child(id)
		inv_item.display_card(PlayerStats.inventory.cards[id])
		
