extends CenterContainer

onready var cardTexture = $TextureRect

var id
func _ready():
	if get_index() + 1 > PlayerStats.inventory.max_hand:
		if PlayerStats.inventory.cards[get_index()] == null:
			visible = false
		else:
			set_modulate(Color("ff7f7f"))
func display_card(card):
	if card is Card:
		cardTexture.texture_normal = card.texture
		$Selector.visible = false
	else:
		cardTexture.texture_normal = load("res://Assets/UI/Inventory/Texture/empty.png")
		$Selector.visible = false

func get_drag_data(_position):
	var card_index = get_index()
	var card = PlayerStats.inventory.remove_item(card_index)
	if card is Card:
		var data = {}
		data.card = card
		data.card_index = card_index
		var dragPreview = TextureRect.new()
		$Selector.visible = false
		dragPreview.texture = card.texture
		dragPreview.rect_scale.x = 3
		dragPreview.rect_scale.y = 3
		set_drag_preview(dragPreview)
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")

func drop_data(_position, data):
	var my_card_index = get_index()
	var my_card = PlayerStats.inventory.cards[my_card_index]
	if not my_card == null:
		PlayerStats.inventory.swap_items(my_card_index, data.card_index)
		PlayerStats.inventory.set_item(my_card_index, data.card)
	else:
		PlayerStats.inventory.set_item(data.card_index, data.card)
	$Selector.visible = false

func _on_TextureRect_mouse_exited():
	$Selector.visible = false
	PlayerStats.slot_selector = null
func _on_TextureRect_mouse_entered():
	id = get_index()
	if PlayerStats.inventory.cards[id] != null or not InputEventMouseButton:
		$Selector.visible = true
	PlayerStats.slot_selector = get_index()

func _on_TextureRect_pressed():
	if PlayerStats.slot_selector != get_index():
		if PlayerStats.inventory.cards[get_index()] == null:
			return
		PlayerStats.slot_selector = get_index()
		$Selector.visible = true
		for slot in get_parent().get_child_count():
			if slot == get_index():
				pass
			else:
				get_parent().get_child(slot).get_child(0).visible = false
	else:
		PlayerStats.slot_selector = null
		$Selector.visible = false
