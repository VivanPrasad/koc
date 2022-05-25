extends KinematicBody2D

var AI
var starting_class : int
var house_id : int

var locative : String
var luck
var sentence
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var path = []
var threshhold = 100
var nav = null
func _ready():
	AI = Citizen.new()
	animationTree.active = true
	new_stats()
	set_location()
	nav = get_parent().get_parent()
func new_stats():
		randomize()
		luck = randi() % 100 + 1 #1-100
		if luck < 16:
			starting_class = 3
			if randi() %100 < 21:
				sentence = [randi()%4+1,null]
			else:
				sentence = [randi()%2+1,null]
			TownStats.set_sentence(sentence[0], self)
			#prisoner
		elif luck < 41:
			starting_class = 2
			#start out as homeless
		else:
			starting_class = 1
			house_id = randi() % 6 + 1 #1-6
			if TownStats.vacant.has(0):
				while TownStats.vacant[house_id-1] == 1:
					house_id = randi() % 6 + 1 #1-6
				#homeowner
			else:
				starting_class = 2
				#all houses are taken, start as homeless

func set_location():
	if starting_class == 1:
		position = TownStats.house_location[house_id - 1]
		TownStats.vacant[house_id - 1] = 1
		locative = "town"
	elif starting_class == 2:
		position = Vector2(32 + randi()% 10-5 * 10, 282 + randi()% 10-6 * 10)
		locative = "town"
	elif starting_class == 3:
		yield(get_tree(), "idle_frame")
		position = TownStats.cell_location[sentence[1]]
		locative = "dungeon"

func _physics_process(_delta):
	if locative != PlayerStats.locative:
		visible = false
	else:
		visible = true
	if path.size() > 0:
		move_to_target()
	else:
		get_target_path(Vector2(0,0))

func move_to_target():
	if global_position.distance_to(path[0]) < threshhold:
		path.remove(0)
		animationState.travel("Idle")
	else:
		var direction = global_position.direction_to(path[0])
# warning-ignore:return_value_discarded
		if direction != Vector2.ZERO:
			animationTree.set("parameters/Walk/blend_position", direction)
			animationState.travel("Walk")

		move_and_slide(direction * AI.speed)
		return

func get_target_path(target):
	path = nav.get_simple_path(global_position, target, false)
