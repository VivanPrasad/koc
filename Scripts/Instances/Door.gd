extends StaticBody2D

var owned : bool

func _physics_process(_delta):
	if $Sprite.frame == 0:
		$Collision.disabled = false
	else:
		$Collision.disabled = true

func _ready():
	call_deferred("link_house")
	if str(name).begins_with("c"):
		$Sprite.region_rect = Rect2(0,56,16,8)
	elif str(name).begins_with("b"):
		$Sprite.region_rect = Rect2(0,64,16,8)
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
		$Sprite.frame = 1
		Audio.play_door_open()

func _on_Area2D_area_exited(_area):
	if owned:
		$Sprite.frame = 0
		Audio.play_door_close()
