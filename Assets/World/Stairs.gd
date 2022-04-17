extends Area2D

var in_dungeon = false
signal enter_dungeon()
signal exit_dungeon()

func _ready():
	yield(get_tree(), "idle_frame")
	if in_dungeon:
		$Collision.position.y = 7
	else:
		$Collision.position.y = 1
func _on_Stairs_area_entered(_area):
	yield(get_tree(), "idle_frame")
	if in_dungeon:
		emit_signal("exit_dungeon")
		$Collision.position.y = 7
	else:
		emit_signal("enter_dungeon")
		$Collision.position.y = 1
	

func _on_Stairs_area_exited(_area):
	pass
