extends KinematicBody2D

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
		position = TownStats.house_location[PlayerStats.house_id - 1]
		TownStats.vacant[PlayerStats.house_id - 1] = 1
	elif PlayerStats.starting_class == 2:
		self.position = Vector2(32, 282)
	else:
		yield(get_tree().create_timer(0), "timeout")
		position = TownStats.cell_location[PlayerStats.sentence[1]]
		get_tree().get_root().find_node("World", true, false).enter_dungeon()
func _physics_process(_delta):
	z_index = 0
	if PlayerStats.current_menu == "none":
		PlayerStats.can_move = true
	else:
		PlayerStats.can_move = false
	if PlayerStats.can_move:
		var input_vector
		if PlayerStats.input_vector == Vector2.ZERO:
			input_vector = Vector2(
				Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
				Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			).normalized()
		else:
			input_vector = PlayerStats.input_vector
		var move_direction = input_vector
		
		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Walk/blend_position", input_vector)
			animationState.travel("Walk")
		else:
			animationState.travel("Idle")
		
	# warning-ignore:return_value_discarded
		move_and_slide(PlayerStats.speed * move_direction)
	else:
		if not PlayerStats.sleeping:
			animationState.travel("Idle")
		else:
			animationState.travel("Sleep-Work")
			position = Vector2(PlayerStats.bed[0].x * 4 + 18, PlayerStats.bed[0].y * 4 + 9)
			z_index = 2
