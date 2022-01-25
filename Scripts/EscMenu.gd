extends CanvasLayer

signal quit_to_menu
onready var settings = load("res://Scenes/UI/Settings.tscn")

onready var back = $Panel/VBox/Continue
onready var collection = $Panel/VBox/Collection
onready var settings_button = $Panel/VBox/Settings
onready var quit = $Panel/VBox/Quit

func _ready():
	back.focus_mode = 0
	collection.focus_mode = 0
	settings_button.focus_mode = 0
	quit.focus_mode = 0

func _on_Continue_pressed():
	PlayerStats.can_move = true
	PlayerStats.current_menu = "none"
	queue_free()
func _on_Collection_pressed():
	pass
func _on_Settings_pressed():
	var child = settings.instance()
	add_child(child)

func _on_Quit_pressed():
	Transition.change_scene("res://Scenes/UI/Menu.tscn", get_tree().get_root().find_node("World", true, false)
, "QuickFade")
	emit_signal("quit_to_menu")
