extends StaticBody2D

var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")

const market = ["item", "food", "bank"]
func _ready():
	if name == "food":
		$Sprite.frame = 1
func _on_Area2D_area_exited(_area):
	get_tree().get_root().find_node("TileSelect", true, false).queue_free()
	PlayerStats.selected = "none"

func _on_Area2D_area_entered(_area):
	if get_tree().get_root().find_node("TileSelect", true, false) == null:
		add_child(tile_select.instance())
	else:
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		add_child(tile_select.instance())
	PlayerStats.selected = market[$Sprite.frame]
