extends StaticBody2D

var id
func _process(_delta):
	if TownStats.cells[get_index()] > 0:
		$Sprite.frame = 0
		$Collision.disabled = false
	else:
		$Sprite.frame = 1
		$Collision.disabled = true
