extends Node2D

onready var esc = preload("res://Scenes/UI/Main/EscMenu.tscn")
onready var day = preload("res://Scenes/UI/Game/DayInfo.tscn")
onready var inv = preload("res://Scenes/UI/Game/InventoryUI.tscn")

onready var dungeon = preload("res://Scenes/UI/Game/Dungeon.tscn")
onready var music = preload("res://Scenes/Instances/musicHandler.tscn")
onready var chest = preload("res://Scenes/UI/Game/ChestUI.tscn")
onready var food = preload("res://Scenes/UI/Game/MarketUI.tscn")

onready var dialogue = preload("res://Scenes/Instances/DialogueBox.tscn")

var slow_tiles = ["Grass", "Grass1", "Grass2", "Grass3", "RedFlowers", "YellowFlowers"]

var tile_pos
var tile
var tile_name

func _ready():
	$UI.add_child(day.instance())
	add_child(music.instance())
# warning-ignore:return_value_discarded
	$Stairs.connect("enter_dungeon", self, "enter_dungeon")
# warning-ignore:return_value_discarded
	$Stairs.connect("exit_dungeon", self, "exit_dungeon")
	PlayerStats.can_move = true
	call_deferred("new_stats")
	
	$Objects/Buildings/Structures/Chest4/Collision.disabled = true
	$Objects/Buildings/Structures/Chest5/Collision.disabled = true

func new_stats():
	PlayerStats.new_stats()
	TownStats.start_town_economy()

#func check_tile():
	#tile_pos = $Floor.world_to_map(Vector2($Player.position.x / 4 - 1, $Player.position.y / 4 - 1))
	#tile = $Floor.get_cellv(Vector2(tile_pos))
	#tile_name = $Floor.tile_set.tile_get_name(tile)

func _physics_process(_delta):
	var time = $UI/DayInfo.second
	var frame = range_lerp(time,0,86400,0,24)
	$Shader/AnimationPlayer.play("TimeCycle")
	$Shader/AnimationPlayer.seek(frame)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
			if get_tree().get_root().find_node("EscMenu", true, false) == null:
				if PlayerStats.current_menu == "none":
					$UI.add_child(esc.instance())
					PlayerStats.current_menu = "esc"
				elif PlayerStats.current_menu == "inv":
					$UI/InventoryUI.queue_free()
					PlayerStats.current_menu = "none"
			else:
				$UI/EscMenu.queue_free()
				PlayerStats.current_menu = "none"
	elif Input.is_action_just_pressed("interact"):
		if PlayerStats.selected == "none":
			if get_tree().get_root().find_node("InventoryUI", true, false) == null:
				if PlayerStats.current_menu == "none":
					$UI.add_child(inv.instance())
					PlayerStats.current_menu = "inv"
				else:
					if PlayerStats.current_menu == "market":
						$UI/MarketUI.queue_free()
						PlayerStats.current_menu = "none"
					elif PlayerStats.current_menu == "esc":
						$UI/EscMenu.queue_free()
						PlayerStats.current_menu = "none"
			else:
				$UI/InventoryUI.queue_free()
				PlayerStats.current_menu = "none"
		elif PlayerStats.selected == "food" or PlayerStats.selected == "item" or PlayerStats.selected == "bank":
			if get_tree().get_root().find_node("MarketUI", true, false) == null:
				if PlayerStats.current_menu == "none":
					$UI.add_child(food.instance())
					PlayerStats.current_menu = "market"
				else:
					pass
			else:
				$UI/MarketUI.queue_free()
				PlayerStats.current_menu = "none"
		elif PlayerStats.selected == "pot":
			if TownStats.town_gold > 0:
				TownStats.town_gold -= 1
				PlayerStats.add_card(load("res://Assets/UI/Inventory/Gold.tres"))
		elif PlayerStats.selected == "royalchest":
			if TownStats.royalchest > 0:
				TownStats.royalchest -= 1
				PlayerStats.add_card(load("res://Assets/UI/Inventory/RoyalGold.tres"))
				get_tree().get_root().find_node("TileSelect", true, false).update_value()
		elif PlayerStats.selected == "chest":
			if get_tree().get_root().find_node("ChestUI", true, false) == null:
				if PlayerStats.current_menu == "none":
					$UI.add_child(chest.instance())
					PlayerStats.current_menu = "chest"
			else:
				$UI/ChestUI.queue_free()
				PlayerStats.current_menu = "none"
					
func enter_dungeon():
	if $MusicChanger != null: 
		$MusicChanger.queue_free()
	$Objects.add_child(dungeon.instance())
	$Stairs.in_dungeon = true
	$Objects/Dungeon.visible = true
	$Objects/Dungeon/Building.set_collision_layer_bit(0, true)
	$Objects/Dungeon/Building.z_index = 2
	
	$Floor.visible = false
	$Objects/Decoration.visible = false
	$Objects/Buildings.visible = false
	$Objects/Buildings.set_collision_layer_bit(0, false)
	$Shader.visible = false
	Audio.play_dungeon()

func exit_dungeon():
	add_child(music.instance())
	$Stairs.in_dungeon = false
	$Objects/Dungeon/Building.set_collision_layer_bit(0, false)
	$Objects/Dungeon/Building.z_index = 0
	#$Objects/Dungeon.visible = false
	
	$Floor.visible = true
	$Objects/Decoration.visible = true
	$Objects/Buildings.visible = true
	$Objects/Buildings.set_collision_layer_bit(0, true)
	$Shader.visible = true
	if $UI/DayInfo.hour > 3 and $UI/DayInfo.hour < 21:
		Audio.play_day()
	else:
		Audio.play_night()
	$Objects/Dungeon.queue_free()
