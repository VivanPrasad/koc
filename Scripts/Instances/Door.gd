extends StaticBody2D

var owned : bool

var type : int
func _physics_process(_delta):
	if $Sprite.frame == 1 + type:
		if get_parent().get_parent().visible and get_parent().get_parent().get_parent().visible:
			$Collision.disabled = false
		else:
			$Collision.disabled = true
	else:
		$Collision.disabled = true

func _ready():
	position = Vector2(position.x +4,position.y +5)
	type *= 2
	$Sprite.frame = type + 1

func _on_Area2D_body_entered(body):
	if body.name:
		$Sprite.frame = 0 + type
		if get_parent().get_parent().visible and get_parent().get_parent().get_parent().visible:	
			Audio.play_door_open()

func _on_Area2D_body_exited(body):
	if body.name:
		$Sprite.frame = 1 + type
		if get_parent().get_parent().get_parent().visible and get_parent().get_parent().visible:
			Audio.play_door_close()
