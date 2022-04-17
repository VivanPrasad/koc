extends Node2D

func _ready():
	call_deferred("check")

func check():
	$Key.text = OS.get_scancode_string(Settings.keybinds["interact"])
	if PlayerStats.selected.begins_with("chest"):
		$Key/Label.text = "Open"
	elif PlayerStats.selected == "bed":
		$Key/Label.text = "Sleep"
	elif PlayerStats.selected != "pot":
		$Key/Label.text = "Buy"
	else:
		$Key/Label.text = "Steal"

func update_value():
	$Gold.text = str(TownStats.royalchest) + "/" + "10"
