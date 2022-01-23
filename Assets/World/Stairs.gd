extends Area2D

var in_dungeon = false
signal enter_dungeon()
signal exit_dungeon()

func _on_Stairs_area_entered(_area):
	yield(get_tree().create_timer(0.2), "timeout")
	if in_dungeon:
		emit_signal("exit_dungeon")
	else:
		emit_signal("enter_dungeon")

func _on_Stairs_area_exited(_area):
	pass
