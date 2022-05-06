extends Control

func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")
func drop_data(_position, data):
	PlayerStats.inventory.set_item(data.card_index, data.card)
	
func _process(_delta):
	if not PlayerStats.slot_selector == null:
		$Tooltip.visible = true
		$Tooltip/Panel/VBoxContainer.visible = false
	else:
		$Tooltip.visible = false
func update():
	for id in $HBoxContainer/Inventory/CenterContainer/SlotsDisplay.get_child_count():
		var inv_item = $HBoxContainer/Inventory/CenterContainer/SlotsDisplay.get_child(id)
		inv_item.display_card(PlayerStats.inventory.cards[id])
	for id in $HBoxContainer/Chest/CenterContainer/ChestDisplay.get_child_count():
		var inv_item = $HBoxContainer/Chest/CenterContainer/ChestDisplay.get_child(id)
		inv_item.display_card(TownStats.inv_res.inventory.cards[id])
func _on_Button_pressed():
	if not PlayerStats.slot_selector == null:
		var card = PlayerStats.inventory.cards[PlayerStats.slot_selector]
		PlayerStats.inventory.meta_swap(card)
		PlayerStats.slot_selector = null

func _on_Button2_pressed():
	if not PlayerStats.slot_selector == null:
		var card = TownStats.inv_res.inventory.cards[PlayerStats.slot_selector-5]
		PlayerStats.take_card(card)
		PlayerStats.slot_selector = null
