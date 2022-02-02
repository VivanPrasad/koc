extends Control


func _ready():
	$Panel/Button.focus_mode = 0
	$Panel2/Button2.focus_mode = 0

func _process(_delta):
	if not PlayerStats.slot_selector == null:
		if PlayerStats.slot_selector < len(PlayerStats.inventory.cards):
			$Panel/Button.disabled = false
			$Panel2/Button2.disabled = true
		else:
			$Panel2/Button2.disabled = false
			$Panel/Button.disabled = true
	else:
		$Panel/Button.disabled = true
		$Panel2/Button2.disabled = true
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
