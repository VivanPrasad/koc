extends Node

onready var lifeUI = $Life
onready var animationPlayer = $Life/Player


var dayInfo
var player

func _ready():
	PlayerStats.life = 1
	call_deferred("setup")
	call_deferred("update_display")

func setup():
	dayInfo = get_tree().get_root().find_node("DayInfo", true, false)
	dayInfo.connect("new_day", self, "on_new_day")

func on_new_day(day):
	if PlayerStats.life > 1:
		PlayerStats.life -= 1
	elif PlayerStats.life == 1:
		if PlayerStats.status == "Ill":
			randomize()
			if randi() % 100 + 1 < day * 15:
				PlayerStats.life -= 1
				PlayerStats.status = "Dead"
			else:
				print("you live to see another day...")
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
		#get_tree().get_root().find_node("World", true, false).queue_free()
		Audio.play_death()
		print("you are dead")
