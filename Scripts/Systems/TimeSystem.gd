extends Node

signal new_day(day)

const am_pm = ["am", "pm"]
const interval = ["00", "30"]

export (int) var second = 21600
export (int) var minute = 0
export (int) var hour = 6

export (int) var speed = 192
#s300 1 irl minute : 5 in-game hours
#s192 daytime
#s480 nighttime

var processed = false

export (String) var splitter = "am"
export (String) var minute_interval = "00"
export (String) var time_cycle = "Morning"

func _ready():
	call_deferred("set_class")

func set_class():
	yield(get_tree().create_timer(0), "timeout")
	if PlayerStats.starting_class == 1:
		$Class.text = "Homeowner " + "(" + str(PlayerStats.house_id) + ")"
		get_tree().get_root().find_node("Markers", true, false).get_child(PlayerStats.house_id - 1).add_color_override("font_color", Color("ffad00"))
	elif PlayerStats.starting_class == 2:
		$Class.text = "Homeless"
	else:
		if PlayerStats.sentence != 1:
			$Class.text = "Prisoner " + "(" + (str(PlayerStats.sentence) + " day remaining)")
		else:
			$Class.text = "Prisoner " + "(" + (str(PlayerStats.sentence) + " days remaining)")
func _process(delta):
	if hour == 0 and processed == false:
		start_new_day()
	if hour > 0:
		processed = false
	if hour > 3 and hour < 22:
		speed = 320*2 #day
		if hour < 8:
			time_cycle = "Early Morning"
		elif hour < 12:
			time_cycle = "Morning"
		elif hour < 18:
			time_cycle = "Afternoon"
		else:
			time_cycle = "Evening"
	else:
		speed = 480*2 #night
		time_cycle = "Night"
	
	if time_cycle == "Morning" and processed == false and TownStats.can_steal:
		TownStats.open_town()
		TownStats.can_steal = false
		processed = true
	if time_cycle == "Night" and processed == false and TownStats.can_steal == false:
		TownStats.can_steal = true
		processed = true
	update_labels()
	second += int(floor(delta * speed))
	minute = int(second / 60) % 60
	hour = int(second / (3600)) % 24
	splitter = am_pm[hour/12]
	minute_interval = interval[minute/30]
	
	if PlayerStats.life != 2:
		PlayerStats.can_eat = true
	else:
		PlayerStats.can_eat = false

func update_labels():
	$Gold/HBoxContainer/Amount.text = str(PlayerStats.gold)
	$Margin/Box/Day.text = "Day " + str(TownStats.day)
	if hour < 13:
		$Margin/Box/Time.text = str(hour) + ":00" + " " + splitter
	elif hour == 0:
		$Margin/Box/Time.text = str(12) + ":00" + " " + splitter
	else:
		$Margin/Box/Time.text = str(hour-12) + ":00" + " " + splitter
	
	$Margin/Box/Cycle.text = time_cycle
	if time_cycle == "Early Morning":
		$Margin/Box/Cycle.add_color_override("font_color", Color("ffae70"))
	elif time_cycle == "Morning":
		$Margin/Box/Cycle.add_color_override("font_color", Color("ffd885"))
	elif time_cycle == "Afternoon":
		$Margin/Box/Cycle.add_color_override("font_color", Color("cccccc"))
	elif time_cycle == "Evening":
		$Margin/Box/Cycle.add_color_override("font_color", Color("ffae70"))
	elif time_cycle == "Night":
		$Margin/Box/Cycle.add_color_override("font_color", Color("9789ff"))

func start_new_day():
	second = 0
	minute = 0
	hour = 0
	TownStats.day += 1
	processed = true
	emit_signal("new_day", TownStats.day)
	configure_day()
	if TownStats.day == 7:
		print("Day 7 Reached, you win")
		get_tree().quit()
	if PlayerStats.starting_class == 3:
		if PlayerStats.sentence > 0:
			PlayerStats.sentence -= 1
		else:
			PlayerStats.starting_class = 2
		set_class()
func configure_day():
	pass

#int(floor(delta * speed)) = 2
	#2 * 60-75 = 120-150 in a second
	#_process runs 120-150 times in a second depending on FPS
	#10pm -> 4am nighttime (6 hours in 45 seconds, speed = 480)
	#4am -> 10pm daytime (18 hours in 3 minutes, speed = 270)
	
	#formula: speed = (in-game hour * 60) / irl minutes
var inventory = preload("res://Scenes/UI/InventoryUI.tscn")
