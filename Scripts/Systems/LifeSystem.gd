extends Node

onready var lifeUI = $Life
onready var animationPlayer = $Life/Player


var dayInfo
var player

func _ready():
	call_deferred("setup")
	call_deferred("update_display")

func setup():
	dayInfo = get_tree().get_root().find_node("DayInfo", true, false)
	dayInfo.connect("new_day", self, "on_new_day")
	PlayerStats.life = 1

func on_new_day(day):
	print(PlayerStats.status)
	print("old life: " + str(PlayerStats.life))
	if PlayerStats.life > 0:
		PlayerStats.life -= int(1 + round(day / 4))
	print("new life: " + str(PlayerStats.life))
	if PlayerStats.life == 0:
		if PlayerStats.status == "Ill":
			randomize()
			if randi() % 100 + 1 < day * 15:
				print("ur dead")
				PlayerStats.status = "Dead"
			else:
				print("live to see another day")
		elif not PlayerStats.status == "Potion":
			PlayerStats.status = "Ill"
	update_display()

func update_display():
	if PlayerStats.status == "Good":
		lifeUI.frame = PlayerStats.life
	elif PlayerStats.status == "Ill":
		lifeUI.frame = PlayerStats.life + 3
	elif PlayerStats.status == "Potion":
		lifeUI.frame = PlayerStats.life + 6
	elif PlayerStats.status == "Unknown":
		lifeUI.frame = 9
	elif PlayerStats.status == "Dead":
		print("you are dead")
		get_tree().quit()
