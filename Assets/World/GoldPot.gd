extends StaticBody2D

var wealth : int
var tile_select = preload("res://Scenes/Instances/TileSelect.tscn")

func _ready():
	position = Vector2(position.x +4, position.y +4)
func _on_Area2D_area_exited(_area):
	get_tree().get_root().find_node("TileSelect", true, false).queue_free()
	PlayerStats.selected = "none"
	$TownGold.visible = false
func _on_Area2D_area_entered(_area):
	if get_tree().get_root().find_node("TileSelect", true, false) == null:
		add_child(tile_select.instance())
	else:
		get_tree().get_root().find_node("TileSelect", true, false).queue_free()
		add_child(tile_select.instance())
	PlayerStats.selected = "pot"
	$TownGold.visible = true

func _process(_delta):
	$TownGold.text = str(TownStats.town_gold) + "/" + str(TownStats.max_bank)
