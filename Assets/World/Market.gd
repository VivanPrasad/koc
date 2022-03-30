extends StaticBody2D

var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")

const market = ["item", "food", "role", "bank"]

func _ready():
	position = Vector2(position.x + 4, position.y + 4)
func _on_Area2D_area_exited(_area):
	if $Sprite.frame < 4 and $Sprite.frame != 2:
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		PlayerStats.selected = "none"

func _on_Area2D_area_entered(_area):
	if $Sprite.frame < 4 and $Sprite.frame != 2:
		if get_tree().get_root().find_node("TileSelect", true, false) == null:
			add_child(tile_select.instance())
		else:
			get_tree().get_root().find_node("TileSelect", true, false).queue_free()
			add_child(tile_select.instance())
		
		PlayerStats.selected = market[$Sprite.frame]
