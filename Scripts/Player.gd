extends KinematicBody2D

const speed = 127.5
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	if PlayerStats.starting_class == 1:
		if PlayerStats.house_id == 1:
			self.position = Vector2(-512, -518)
		elif PlayerStats.house_id == 2:
			self.position = Vector2(512, -358)
		elif PlayerStats.house_id == 3:
			self.position = Vector2(-288, -102)
		elif PlayerStats.house_id == 4:
			self.position = Vector2(-448, 442)
		elif PlayerStats.house_id == 5:
			self.position = Vector2(544, 474)
	elif PlayerStats.starting_class == 2:
		self.position = Vector2(32, 282)
	else:
		position = Vector2(64, -486)
		get_tree().get_root().find_node("World", true, false).enter_dungeon()
	animationTree.active = true
	Audio.play_town()
	PlayerStats.current_menu = "none"

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
		animationState.travel("Idle")
func _input(_event):
	if Input.is_action_just_pressed("map"):
		print(PlayerStats.current_menu)
		if PlayerStats.current_menu == "none":
			PlayerStats.current_menu = "map"
			if $Camera2D.zoom == Vector2(1.2, 1.2):
				$Camera2D.zoom = Vector2(4,4)
		elif PlayerStats.current_menu == "map":
				$Camera2D.zoom = Vector2(1.2, 1.2)
				PlayerStats.current_menu = "none"
