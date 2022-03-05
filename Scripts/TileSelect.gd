extends AnimatedSprite

func _ready():
	call_deferred("check")

func check():
	if PlayerStats.selected == "chest":
		$Key/Label.text = "Open"
	elif PlayerStats.selected == "royalchest":
		$Key/Label.text = "Steal"
		$Gold.visible = true
		$Gold.text = str(TownStats.royalchest) + "/" + "10"
	elif PlayerStats.selected == "bed":
		$Key.visible = false
	elif PlayerStats.selected != "pot":
		$Key/Label.text = "Buy"
	else:
		$Key/Label.text = "Steal"

func update_value():
	$Gold.text = str(TownStats.royalchest) + "/" + "10"
