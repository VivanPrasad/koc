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
#10pm-2am Night (4 hours)
#2-6am Early Morning (4 hours)
#6am-12pm Morning (6 hours)
#12pm-6pm Noon (6 hours)
#6pm-10pm Evening (4 hours)

var processed = false

export (String) var splitter = "am"
export (String) var minute_interval = "00"
export (String) var time_cycle = "Morning"

func _ready():
	call_deferred("set_class")

func set_class():
	yield(get_tree().create_timer(0), "timeout")
	if PlayerStats.starting_class == 1:
		$Class.text = "Homeowner"
	elif PlayerStats.starting_class == 2:
		$Class.text = "Homeless"
	else:
		$Class.text = "Prisoner"
func _process(delta):
	if hour == 0 and processed == false:
		start_new_day()
	if hour > 0:
		processed = false
	if hour > 7 and hour < 22:
		speed = 203 #192 #day
		if hour < 12:
			time_cycle = "Morning"
		elif hour > 11 and hour < 18:
			time_cycle = "Afternoon"
		elif hour > 17:
			time_cycle = "Evening"
	else: #elif hour > 21 or hour < 6:
		speed = 508 #480 #night
		if hour > 3 and hour < 8:
			time_cycle = "Early Morning"
		elif hour > 21 and hour < 25 or hour < 4:
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
		$Margin/Box/Time.text = str(hour) + ":" + str(minute_interval) + " " + splitter
	elif hour == 0:
		$Margin/Box/Time.text = str(12) + ":" + str(minute_interval) + " " + splitter
	else:
		$Margin/Box/Time.text = str(hour-12) + ":" + str(minute_interval) + " " + splitter
	
	$Margin/Box/Cycle.text = str(time_cycle)
	if str(time_cycle) == "Early Morning" or "Evening":
		$Margin/Box/Cycle.add_color_override("font_color", Color("ffae70"))
	elif str(time_cycle) == "Morning":
		$Margin/Box/Cycle.add_color_override("font_color", Color("ffd885"))
	elif str(time_cycle) == "Afternoon":
		$Margin/Box/Cycle.add_color_override("font_color", Color("aaaaaa"))
	elif str(time_cycle) == "Night":
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

func configure_day():
	pass

#int(floor(delta * speed)) = 2
	#2 * 60-75 = 120-150 in a second
	#_process runs 120-150 times in a second depending on FPS
	
	#300 in-game seconds for every realtime second
	#5 in-game minutes for every realtime second	
	#5 in-game hours for every realtime minute
	#therefore, 5 hour = 1 minute
	#10pm -> 6am nighttime (8 hours in 1 minute, speed = 480)
	#6am -> 10pm daytime (16 hours in 5 minutes, speed = 192)

var inventory = preload("res://Scenes/UI/InventoryUI.tscn")
