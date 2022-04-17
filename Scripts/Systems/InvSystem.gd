extends Resource
class_name Inventory

signal cards_changed()
export (Array, Resource) var cards = [
	null, null, null, null, null
]

var max_hand = 5

func add_slot():
	cards.append(null)

func set_item(card_index, card):
	var previousCard = cards[card_index]
	cards[card_index] = card
	emit_signal("cards_changed", [card_index])
	return previousCard

func swap_items(card_index, target_card_index):
	var targetCard = cards[target_card_index]
	var card = cards[card_index]
	cards[target_card_index] = card
	cards[card_index] = targetCard
	emit_signal("cards_changed", card_index)

func remove_item(card_index):
	var previousCard = cards[card_index]
	cards[card_index] = null
	emit_signal("cards_changed", card_index)
	return previousCard

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func swap_meta_items(card_index, target_card_index, resource):
	var targetCard = resource.inventory.cards[target_card_index]
	var card = cards[card_index]
	resource.inventory.cards[target_card_index] = card
	cards[card_index] = targetCard
