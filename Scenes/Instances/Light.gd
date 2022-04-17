extends Light2D

func _process(_delta):
	if TownStats.time.hour > 9 and TownStats.time.hour < 18:
		enabled = false
	else:
		enabled = true
	#energy = rand_range(0.98, 1.02)
