extends Light2D

var type
func _ready():
	if get_parent().get_parent().name == "Objects":
		type = 1
	elif get_parent().get_parent().name == "Dungeon":
		type = 0
func _process(_delta):
	if type == 1:
		if TownStats.time.hour > 9 and TownStats.time.hour < 18:
			enabled = false
		else:
			enabled = true
	elif type == 0:
		enabled = true
	#energy = rand_range(0.98, 1.02)
