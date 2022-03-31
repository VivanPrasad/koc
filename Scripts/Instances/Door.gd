extends StaticBody2D

var owned : bool

var type : int
func _physics_process(_delta):
	if $Sprite.frame == 1 + type:
		$Collision.disabled = false
	else:
		$Collision.disabled = true

func _ready():
	position = Vector2(position.x +4,position.y +5)
	type *= 2
	$Sprite.frame = type + 1
	call_deferred("link_house")
func link_house():
	yield(get_tree().create_timer(0.5), "timeout")
	if get_index() > 4:
		owned = true
	if PlayerStats.starting_class == 1:
		if int(PlayerStats.house_id) - 1 == int(get_index()):
			owned = true
		else:
			pass
func _on_Area2D_area_entered(_area):
	if owned:
		$Sprite.frame = 0 + type
		Audio.play_door_open()

func _on_Area2D_area_exited(_area):
	if owned:
		$Sprite.frame = 1 + type
		Audio.play_door_close()
