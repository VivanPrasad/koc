extends Control

onready var settings = preload("res://Scenes/UI/Settings.tscn")
onready var world = preload("res://Scenes/World.tscn")

const colors = [
	"#314759", #dark blue
	"#6b2c59", #dark magenta
	"#9e6b4c", #dark yellow/orange
	"#31645f", #viridian
	"9e3f60" #pink
	]
onready var play_button = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Play
onready var tutorial_button = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Tutorial
onready var settings_button = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Settings
onready var collection_button = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Collection
onready var exit_button = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Exit
onready var bg = $BG
#var new_color : Color

func _ready():
	call_deferred("setup")

func setup():
	Audio.play_menu()
	$BG2.playing = true
	play_button.focus_mode = 0;tutorial_button.focus_mode = 0;settings_button.focus_mode = 0;settings_button.focus_mode = 0;collection_button.focus_mode = 0;
	randomize()
	bg.modulate = (Color(colors[int(rand_range(0,4))]))


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_Play_mouse_entered():
	play_button.text = "~ Play"
	Audio.play_select()
func _on_Play_mouse_exited():
	play_button.text = "Play"

func _on_Tutorial_mouse_entered():
	#tutorial_button.text = "~ Tutorial"
	#Audio.play_select()
	pass
func _on_Tutorial_mouse_exited():
	#tutorial_button.text = "Tutorial"
	pass
func _on_Settings_mouse_entered():
	settings_button.text = "~ Settings"
	Audio.play_select()
func _on_Settings_mouse_exited():
	settings_button.text = "Settings"

func _on_Collection_mouse_entered():
	pass
	#collection_button.text = "~ Collection"
	#Audio.play_select()
func _on_Collection_mouse_exited():
	pass
	#collection_button.text = "Collection"
	
func _on_Exit_mouse_entered():
	exit_button.text = "~ Exit"
	Audio.play_select()
func _on_Exit_mouse_exited():
	exit_button.text = "Exit"

func _on_Play_pressed():
# warning-ignore:return_value_discarded
	Audio.play_confirm()
	Transition.change_scene("res://Scenes/World.tscn", self, "LongFade")

func _on_Tutorial_pressed():
	Audio.play_confirm()
	Transition.change_scene("res://Scenes/Instances/DialogueBox.tscn", self, "LongFade")

func _on_Settings_pressed():
	Audio.play_confirm()
	self.add_child(settings.instance())
	
func _on_Collection_pressed():
	pass


func _on_Discord_pressed():
	return OS.shell_open("https://discord.com/invite/ZEETC5Y7Df/")

func _on_Reddit_pressed():
	return OS.shell_open("https://www.reddit.com/r/kingdomofcards/")

func _on_Exit_pressed():
	get_tree().quit()
