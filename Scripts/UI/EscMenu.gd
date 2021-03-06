extends CanvasLayer

signal quit_to_menu
onready var settings = load("res://Scenes/UI/Settings/Settings.tscn")

onready var back = $Panel/VBox/Continue
onready var collection = $Panel/VBox/Collection
onready var settings_button = $Panel/VBox/Settings
onready var quit = $Panel/VBox/Quit

func _ready():
	back.focus_mode = 0
	collection.focus_mode = 0
	settings_button.focus_mode = 0
	quit.focus_mode = 0
	#get_tree().paused = true

func _on_Continue_pressed():
	PlayerStats.can_move = true
	PlayerStats.current_menu = "none"
	Audio.play_confirm()
	queue_free()
	
func _on_Collection_pressed():
	pass
func _on_Settings_pressed():
	Audio.play_confirm()
	add_child(settings.instance())

func _on_Quit_pressed():
	Audio.play_confirm()
	Transition.change_scene("res://Scenes/Menu.tscn", get_tree().get_root().find_node("World", true, false)
, "QuickFade")
	emit_signal("quit_to_menu")
