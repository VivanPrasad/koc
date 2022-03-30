extends KinematicBody2D

const speed = 127.5
const house_location = [
	Vector2(-512, -518), 
	Vector2(512, -358), 
	Vector2(-288, -102), 
	Vector2(-448, 442),
	Vector2(544, 474)
	]
const cell_location = [
	Vector2(32, -486),
	Vector2(128, -486),
	Vector2(224, -486),
	Vector2(320, -486)
]

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	Audio.play_town()
	PlayerStats.current_menu = "none"

func set_location():
	if PlayerStats.starting_class == 1:
		position = house_location[PlayerStats.house_id - 1]
	elif PlayerStats.starting_class == 2:
		self.position = Vector2(32, 282)
	else:
		yield(get_tree().create_timer(0), "timeout")
		position = cell_location[PlayerStats.sentence[1]]
		get_tree().get_root().find_node("World", true, false).enter_dungeon()
func _physics_process(_delta):
	if PlayerStats.current_menu == "none":
		PlayerStats.can_move = true
	else:
		PlayerStats.can_move = false
	if PlayerStats.can_move:
		var input_vector := Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
		var move_direction = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Walk/blend_position", input_vector)
			animationState.travel("Walk")
		else:
			animationState.travel("Idle")
		
	# warning-ignore:return_value_discarded
		move_and_slide(speed * move_direction)
	else:
		if not PlayerStats.sleeping:
			animationState.travel("Idle")
		else:
			animationState.travel("Sleep-Work")
			position = Vector2(PlayerStats.bed[0].x * 4 + 16, PlayerStats.bed[0].y * 4 + 10)
			z_index = 2
func _input(_event):
	if Input.is_action_just_pressed("map"):
		if PlayerStats.current_menu == "none":
			PlayerStats.current_menu = "map"
			if $Camera2D.current:
				$Camera2D.zoom = Vector2(8,8)#Vector2(3.6,3.75)
		elif PlayerStats.current_menu == "map":
				$Camera2D.zoom = Vector2(1.2,1.25)
				PlayerStats.current_menu = "none"

func update_skin(_skinPath):
	pass #$Sprite.texture = load(skinPath)
	#$Sprite.hframes = 12
