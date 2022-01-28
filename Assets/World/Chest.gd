extends StaticBody2D

var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")

func _on_Area2D_area_entered(_area):
	if get_tree().get_root().find_node("TileSelect", true, false) == null:
		add_child(tile_select.instance())
	else:
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		add_child(tile_select.instance())
	PlayerStats.selected = "chest"

func _on_Area2D_area_exited(_area):
	get_tree().get_root().find_node("TileSelect", true, false).queue_free()
	PlayerStats.selected = "none"
