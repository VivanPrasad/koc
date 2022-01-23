extends GridContainer

var slot = preload("res://Scenes/UI/Slot.tscn")

func _ready():
	PlayerStats.inventory.connect("cards_changed", self, "on_cards_changed")
	get_hand()
	yield(get_tree().create_timer(0), "timeout")
	update_inventory_display()

func get_hand():
	for cards in PlayerStats.inventory.cards.size():
		add_child(slot.instance())

func update_inventory_display():
	for card_index in PlayerStats.inventory.cards.size():
		update_slot_display(card_index)

func update_slot_display(card_index):
	var slotDisplay = get_child(card_index)
	var card = PlayerStats.inventory.cards[card_index]
	slotDisplay.display_card(card)

func on_cards_changed(indexes):
	for card_index in indexes:
		update_inventory_display()
