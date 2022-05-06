extends CanvasLayer

var dialogue = []

var world = load("res://Scenes/World.tscn")
var dialogue_index = 0
var finished = false

func _ready():
	PlayerStats.current_menu = "dialogue"
	tutorial(0)
	load_dialogue()

func tutorial(act):
	if act == 0:
		dialogue = ["You start as a [u]" + PlayerStats.names[PlayerStats.starting_class] + "[u].",
		#"You have a Bed and a Chest.",
		#"You must pay rent to the bank on Day 3 and 6.",
		"There are " + str(TownStats.population) + " citizens.",
		"You think today will be a good day."
		]
	elif act == 1:
		dialogue = ["Kingdom of Cards is a strategic game.",
		"One with many scenarios, many outcomes.",
		"To the hand of cards, vital to all.",
		"Yet, medieval and erstwhile, it is not without its goals.",
		"In this game, thee will venture many towns across the kingdom.",
		"Thy circumstances will vary.",
		"Imprisoned in a dungeon,",
		"...or without shelter.",
		"Ye who yearns the end, will survive.",
		]
	elif act == 2:
		dialogue = ["Each town is different. However, all of them contain the same things, more or less.",
		"There is a castle, where the royal is.",
		"The royal is the ruler of the town, and has total power.",
		"Royals differ in moral and judgement. One day thee might very be one!",
		"There is a bank, that holds the town's riches.",
		"There, you can buy a house need be.",
		"You can upgrade your chest or loan gold.",
		"The bank is an essential part of the game, as its wealth has an impact on the prices.",
		"Speaking of prices, there are the item shop and the food market located in town square.",
		"You are fortunate enough to begin in a house.",
		"Use your starting to your advantage.",
		"All houses contain a bed. Some contain a chest.",
		"Old chests can store 5 cards.",
		"However, if upgraded, new chests can store 10."
		]
	elif act == 4:
		dialogue = [
			"Your goal is up to you.",
			"You can either try to survive until the 7th day,",
			"Accumulate the most gold,",
			"You can check all win conditions on the main menu.",
		]
func reset():
	dialogue_index = 0
	finished = false
func _process(_delta):
	if not finished:
		Audio.play_dialogue()
	$Indicator.visible = finished

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			load_dialogue()
			Audio.play_back2()
		else:
			$Tween.seek(1)
			finished = true
	if event is InputEventMouseButton and finished:
		load_dialogue()
		Audio.play_back2()
	if Input.is_action_just_pressed("interact") and finished:
		load_dialogue()
		Audio.play_back2()
func load_dialogue():
	if dialogue_index < dialogue.size():
		finished = false
		$Text.bbcode_text = dialogue[dialogue_index]
		$Text.percent_visible = 0
		$Tween.interpolate_property($Text, "percent_visible", 0, 1, 1, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		PlayerStats.current_menu = "none"
		#Transition.change_scene("res://Scenes/World.tscn", self, "QuickFade")
		#yield(get_tree().create_timer(0), "timeout")
		reset()
		queue_free()
		#tutorial(2)
	dialogue_index += 1

func _on_Tween_tween_completed(_object, _key):
	finished = true
