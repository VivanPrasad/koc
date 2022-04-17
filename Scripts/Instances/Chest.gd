extends StaticBody2D
var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")
var id
var inventory
func _ready():
	position = Vector2(position.x +4, position.y + 4)
	id = TownStats.chests.find(self)
	inventory = Inventory.new()
	
func _on_Area2D_area_entered(_area):
	PlayerStats.selected = "chest" + str(id)
	if PlayerStats.selected != "none":
		modulate = Color(1.5,1.5,1.5,1)
		if get_tree().get_root().find_node("TileSelect", true, false) == null:
			add_child(tile_select.instance())
		else:
			get_tree().get_root().find_node("TileSelect", true, false).queue_free()
			add_child(tile_select.instance())

func _on_Area2D_area_exited(_area):
	modulate = Color(1,1,1,1)
	if PlayerStats.selected != "none":
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		PlayerStats.selected = "none"
