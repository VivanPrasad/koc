extends GridContainer

var slot = preload("res://Scenes/UI/Game/Slot.tscn")
var resource
func _ready():
	resource = TownStats.inv_res
	resource.connect("cards_changed", self, "on_cards_changed")
	get_hand()
	update_inventory_display()
func get_hand():
	for cards in resource.cards.size():
		add_child(slot.instance())

func update_inventory_display():
	for card_index in resource.cards.size():
		update_slot_display(card_index)

func update_slot_display(card_index):
	var slotDisplay = get_child(card_index)
	var card = resource.cards[card_index]
	slotDisplay.display_card(card)

func on_cards_changed(indexes):
	for card_index in indexes:
		update_inventory_display()
