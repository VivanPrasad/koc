extends StaticBody2D

const house_id = [0,1,2,3,4]
var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")

func _on_Area2D_area_entered(_area):
	PlayerStats.selected = "bed"
	
	if PlayerStats.selected != "none":
		if get_tree().get_root().find_node("TileSelect", true, false) == null:
			add_child(tile_select.instance())
		else:
			get_tree().get_root().find_node("TileSelect", true, false).queue_free()
			add_child(tile_select.instance())

func _on_Area2D_area_exited(_area):
	if PlayerStats.selected != "none":
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		PlayerStats.selected = "none"