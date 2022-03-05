extends Control

func _ready():
	$Panel/Button.focus_mode = 0
	$Panel2/Button2.focus_mode = 0

func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")
func drop_data(_position, data):
	PlayerStats.inventory.set_item(data.card_index, data.card)
	
func _process(_delta):
	if not PlayerStats.slot_selector == null:
		if PlayerStats.slot_selector < len(PlayerStats.inventory.cards):
			$Panel/Button.visible = true
			$Panel2/Button2.visible = false
		else:
			$Panel2/Button2.visible = true
			$Panel/Button.visible = false
	else:
		$Panel/Button.visible = false
		$Panel2/Button2.visible = false
func update():
	for id in $HBoxContainer/Inventory/CenterContainer/SlotsDisplay.get_child_count():
		var inv_item = $HBoxContainer/Inventory/CenterContainer/SlotsDisplay.get_child(id)
		inv_item.display_card(PlayerStats.inventory.cards[id])
	for id in $HBoxContainer/Chest/CenterContainer/ChestDisplay.get_child_count():
		var inv_item = $HBoxContainer/Chest/CenterContainer/ChestDisplay.get_child(id)
		inv_item.display_card(PlayerStats.chest.cards[id])
func _on_Button_pressed():
	if not PlayerStats.slot_selector == null:
		var card = PlayerStats.inventory.cards[PlayerStats.slot_selector]
		PlayerStats.add_to_chest(card)
		PlayerStats.slot_selector = null

func _on_Button2_pressed():
	if not PlayerStats.slot_selector == null:
		var card = PlayerStats.chest.cards[PlayerStats.slot_selector-5]
		PlayerStats.take_card(card)
		PlayerStats.slot_selector = null
