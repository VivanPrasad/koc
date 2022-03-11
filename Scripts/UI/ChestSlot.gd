extends CenterContainer

onready var cardTexture = $TextureRect

var id
func _ready():
	if get_index() + 1 > PlayerStats.chest.max_hand:
		if PlayerStats.chest.cards[get_index()] == null:
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

func _process(_delta):
	if not PlayerStats.slot_selector == null:
		if PlayerStats.slot_selector < len(PlayerStats.inventory.cards):
			$Selector.visible = false

func _on_TextureRect_pressed():
	if PlayerStats.slot_selector != get_index() + 5:
		if PlayerStats.chest.cards[get_index()] == null:
			return
		PlayerStats.slot_selector = get_index()+5
		$Selector.visible = true
		for slot in get_parent().get_child_count():
			if slot == get_index():
				pass
			else:
				get_parent().get_child(slot).get_child(0).visible = false
	else:
		PlayerStats.slot_selector = null
		$Selector.visible = false
