extends CenterContainer

onready var cardTexture = $TextureRect
onready var cardIcon = $TextureRect/Icon

var id

var mode = 0
func _ready():
	#display_card
	#if get_index() + 1 > PlayerStats.inventory.max_hand:
	#	if PlayerStats.inventory.cards[get_index()] == null:
	#		queue_free()
	#	else:
	#		set_modulate(Color("ff7f7f"))
	if get_parent().name != "SlotsDisplay":
		mode = 1

func display_card(card):
	if get_index() + 1 > PlayerStats.inventory.max_hand:
		if PlayerStats.inventory.cards[get_index()] == null:
			visible = false
		else:
			set_modulate(Color("ff7f7f"))
			visible = true
	$Selector.visible = false
	if card is Card:
		cardIcon.visible = true
		if card.type != "Role":
			cardTexture.texture_normal = load("res://Assets/UI/Cards/Texture/card.png")
		else:
			cardTexture.texture_normal = load("res://Assets/UI/Cards/Texture/role.png")
		if File.new().file_exists("res://Assets/UI/Cards/Icon/" + str(card.name) + ".png"):
			cardIcon.texture = load("res://Assets/UI/Cards/Icon/" + str(card.name) + ".png")
			cardIcon.modulate = Color(1,1,1,1)
		else:
			cardIcon.texture = load("res://Assets/UI/Cards/Icon/Card.png")
			cardIcon.modulate = Color(0.8,0.8,0.8,1)
	else:
		cardTexture.texture_normal = load("res://Assets/UI/Cards/Texture/empty.png")
		cardIcon.visible = false

func get_drag_data(_position):
	var card
	if PlayerStats.current_menu != "":
		PlayerStats.slot_selector = null
		var card_index = get_index()
		if mode == 0:
			card = PlayerStats.inventory.remove_item(card_index)
		else:
			card = TownStats.inv_res.remove_item(card_index)
		if card is Card:
			cardTexture.texture_normal = load("res://Assets/UI/Cards/Texture/empty.png")
			Audio.take_card()
			cardIcon.visible = false
			var data = {}
			data.card = card
			data.card_index = card_index
			var dragPreview = TextureRect.new()
			$Selector.visible = false
			if card.type != "Role":
				dragPreview.texture = load("res://Assets/UI/Cards/Icon/Card.png")
			else:
				dragPreview.texture = load("res://Assets/UI/Cards/Icon/Role.png")
			dragPreview.rect_scale.x = 4
			dragPreview.rect_scale.y = 4
			set_drag_preview(dragPreview)
			return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("card")

func drop_data(_position, data):
	var my_card_index = get_index()
	var my_card
	if mode == 0:
		my_card = PlayerStats.inventory.cards[my_card_index]
		if not my_card == null:
			PlayerStats.inventory.swap_items(my_card_index, data.card_index)
			PlayerStats.inventory.set_item(my_card_index, data.card)
		else:
			PlayerStats.inventory.set_item(data.card_index, data.card)
		$Selector.visible = false
	else:
		my_card = TownStats.inv_res.cards[my_card_index]
		if not my_card == null:
			TownStats.inv_res.swap_items(my_card_index, data.card_index)
			TownStats.inv_res.set_item(my_card_index, data.card)
		else:
			TownStats.inv_res.set_item(data.card_index, data.card)

func _process(_delta):
	if not PlayerStats.slot_selector == null:
		if mode == 0:
			if PlayerStats.slot_selector > len(PlayerStats.inventory.cards)-1:
				$Selector.visible = false
		else:
			if PlayerStats.slot_selector < len(TownStats.inv_res.cards)-1:
				$Selector.visible = false

func _on_TextureRect_pressed():
	if cardTexture.texture_normal.resource_path == "res://Assets/UI/Cards/Texture/empty.png":
		return
	$Selector.visible = true
	if PlayerStats.slot_selector != get_index() + int(mode*5):
		if mode == 0:
			if PlayerStats.inventory.cards[get_index()] == null:
				$Selector.visible = false
		else:
			if TownStats.inv_res.cards[get_index()] == null:
				$Selector.visible = false
		PlayerStats.slot_selector = get_index() + int(mode*PlayerStats.inventory.cards.size())
		$Selector.visible = true
		Audio.play_select()
		for slot in get_parent().get_child_count():
			if slot == get_index():
				pass
			else:
				get_parent().get_child(slot).get_child(0).visible = false
	else:
		PlayerStats.slot_selector = null
		$Selector.visible = false
