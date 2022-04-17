extends Node2D

onready var esc = preload("res://Scenes/UI/Main/EscMenu.tscn")
onready var day = preload("res://Scenes/UI/Game/DayInfo.tscn")
onready var inv = preload("res://Scenes/UI/Game/InventoryUI.tscn")

onready var music = preload("res://Scenes/Instances/musicHandler.tscn")
onready var chest_ui = preload("res://Scenes/UI/Game/ChestUI.tscn")
onready var food = preload("res://Scenes/UI/Game/MarketUI.tscn")

onready var dialogue = preload("res://Scenes/Instances/DialogueBox.tscn")

onready var bed = preload("res://Scenes/Instances/Bed.tscn")
onready var chest = preload("res://Scenes/Instances/Chest.tscn")
onready var door = preload("res://Scenes/Instances/Door.tscn")
onready var market = preload("res://Scenes/Instances/Market.tscn")
onready var gold_pot = preload("res://Scenes/Instances/GoldPot.tscn")

onready var light = preload("res://Scenes/Instances/Light.tscn")

var slow_tiles = []

var tile_pos
var tile
var tile_name

onready var ground = $Objects/Floor
onready var stairs = $Objects/Floor/Stairs
onready var buildings = $Objects/Buildings
onready var structure = $Objects/Buildings/Structures
onready var decoration = $Objects/Decoration
onready var dungeon = $Objects/Dungeon
onready var Dbuildings = $Objects/Dungeon/Buildings
var time : int
var frame

func _ready():
	$UI.add_child(day.instance())
	add_child(music.instance())
# warning-ignore:return_value_discarded
	stairs.connect("enter_dungeon", self, "enter_dungeon")
# warning-ignore:return_value_discarded
	stairs.connect("exit_dungeon", self, "exit_dungeon")
	call_deferred("new_stats")
	add_instances()
	

func add_instances():
	#surface
	var structures = [bed, chest, door, market, gold_pot]
	var structure_ids = [52, 53, 55, 51, 54]
	
	var object
	for i in structures:
		object = buildings.get_used_cells_by_id(structure_ids[structures.find(i)])
		for cell in object:
			var instance = i.instance()
			instance.set_position(Vector2(cell.x*8, cell.y *8))
			if i == market:
				instance.get_child(1).frame = int(buildings.get_cell_autotile_coord(cell.x, cell.y).x)
			elif i == door:
				instance.type = int(buildings.get_cell_autotile_coord(cell.x, cell.y).y)
			elif i == chest:
				TownStats.chests.append(instance)
			structure.add_child(instance)
			#position = Vector2(cell.x*32, cell.y*32)
			buildings.set_cell(cell.x, cell.y, -1)
	structures = [door, market]
	structure_ids = [10, 9]
	for i in structures:
		object = Dbuildings.get_used_cells_by_id(structure_ids[structures.find(i)])
		for cell in object:
			var instance = i.instance()
			instance.set_position(Vector2(cell.x*8, cell.y *8))
			if i == market:
				instance.get_child(1).frame = 5
			elif i == door:
				instance.type = 3
			$Objects/Dungeon/Buildings/Structures.add_child(instance)
			Dbuildings.set_cell(cell.x, cell.y, -1)
	
	structure_ids = [16, 18]
	for id in structure_ids:
		object = decoration.get_used_cells_by_id(id)
		for cell in object:
			var instance = light.instance()
			if id == 18:
				if decoration.get_cell_autotile_coord(cell.x, cell.y) == Vector2(0,0):
					instance.set_position(Vector2(cell.x*8 +5, cell.y *8 +7))
					decoration.add_child(instance)
			else:
				instance.set_position(Vector2(cell.x*8 +4, cell.y *8 +4 ))
				decoration.add_child(instance)
			
			#position = Vector2(cell.x*32, cell.y*32)
	
func new_stats():
	PlayerStats.new_stats()
	TownStats.start_town_economy()

#func check_tile():
	#tile_pos = $Floor.world_to_map(Vector2($Player.position.x / 4 - 1, $Player.position.y / 4 - 1))
	#tile = $Floor.get_cellv(Vector2(tile_pos))
	#tile_name = $Floor.tile_set.tile_get_name(tile)

func _physics_process(_delta):
	time = $UI/DayInfo.second
	frame = range_lerp(time,0,86400,0,24)
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
		elif PlayerStats.selected in ["food","item","bank","role","secret"]:
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
				PlayerStats.add_card(load("res://Assets/UI/Cards/Gold.tres"))
		elif PlayerStats.selected.begins_with("chest"):
			TownStats.inv_res = TownStats.chests[PlayerStats.selected.to_int()].inventory
			if get_tree().get_root().find_node("ChestUI", true, false) == null:
				if PlayerStats.current_menu == "none":
					$UI.add_child(chest_ui.instance())
					PlayerStats.current_menu = "chest"
			else:
				$UI/ChestUI.queue_free()
				PlayerStats.current_menu = "none"
		elif PlayerStats.selected == "bed":
				if not PlayerStats.sleeping:
					if PlayerStats.can_sleep:
						PlayerStats.good_night()
				else:
					Transition.wake()
					$Objects/Player.position.x += 32
					PlayerStats.selected = "none"
					PlayerStats.sleeping = false
					PlayerStats.can_move = true
					PlayerStats.current_menu = "none"
func enter_dungeon():
	if $MusicChanger != null: 
		$MusicChanger.queue_free()
	stairs.in_dungeon = true
	dungeon.visible = true
	Dbuildings.set_collision_layer_bit(0, true)
	
	ground.visible = false
	decoration.visible = false
	buildings.visible = false
	buildings.set_collision_layer_bit(0, false)
	$Shader.visible = false
	Audio.play_dungeon()

func exit_dungeon():
	add_child(music.instance())
	stairs.in_dungeon = false
	Dbuildings.set_collision_layer_bit(0, false)
	#$Objects/Dungeon.visible = false
	
	ground.visible = true
	decoration.visible = true
	buildings.visible = true
	buildings.set_collision_layer_bit(0, true)
	$Shader.visible = true
	if $UI/DayInfo.hour > 3 and $UI/DayInfo.hour < 21:
		Audio.play_day()
	dungeon.visible = false
