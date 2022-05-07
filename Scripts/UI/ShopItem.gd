extends Control

var list = []
onready var slot_name = $HBoxContainer/TextureRect/HBox/Name
onready var slot_icon = $HBoxContainer/TextureRect/HBox/Icon

onready var slot_cost = $HBoxContainer/TextureRect2/HBoxContainer/Cost
onready var slot_stock = $HBoxContainer/TextureRect3/Stock
func _ready():
	call_deferred("update_display")

func update_display():
	var id = get_index()
	slot_name.text = TownStats.current_list[id]
	slot_icon.texture = load("res://Assets/UI/Cards/Icon/" + str(TownStats.current_list[id]) + ".png")
	slot_cost.text = str(TownStats.item_list[TownStats.current_list[id]][1])
	slot_stock.text = str(TownStats.item_list[TownStats.current_list[id]][2])
	if int(slot_cost.text) > PlayerStats.gold or int(slot_stock.text) == 0:
		slot_name.add_color_override("font_color", Color("696969"))

func _on_TextureRect_toggled(_button_pressed):
	if PlayerStats.slot_selector != get_index():
		PlayerStats.slot_selector = get_index()
		$Selector.visible = true
		Audio.play_dialogue()
		for slot in get_parent().get_child_count():
			if slot == get_index():
				pass
			else:
				get_parent().get_child(slot).get_child(0).visible = false
	else:
		PlayerStats.slot_selector = null
		$Selector.visible = false
