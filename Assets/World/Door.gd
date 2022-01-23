extends StaticBody2D

onready var animationPlayer = $AnimationPlayer
onready var collision = $Collision
onready var sprite = $Sprite

var owned 

func _process(_delta):
	if sprite.frame == 0:
		collision.disabled = false
	else:
		collision.disabled = true

func _ready():
	call_deferred("link_house")

func link_house():
	yield(get_tree().create_timer(1), "timeout")
	if get_index() > 4:
		owned = true
	if PlayerStats.starting_class == 1:
		if int(PlayerStats.house_id) - 1 == int(get_index()):
			owned = true
		else:
			pass
func _on_Area2D_area_entered(_area):
	if owned:
		animationPlayer.play("Door Open")

func _on_Area2D_area_exited(_area):
	if owned:
		animationPlayer.play("Door Close")
