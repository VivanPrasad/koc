extends Control

onready var master_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer3/MSlider
onready var music_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer/MuSlider
onready var sfx_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer2/SSlider2

onready var debug = $Margin/VBoxContainer/Tabs/Display/VBoxContainer/Debug
onready var flscrn = $Margin/VBoxContainer/Tabs/Display/VBoxContainer/Fullscreen

var new_color : Color

onready var debug_ui = preload("res://Scenes/UI/DebugUI.tscn")
func _ready():
	master_vol.value = AudioServer.get_bus_volume_db(0)
	music_vol.value = AudioServer.get_bus_volume_db(1)
	sfx_vol.value = AudioServer.get_bus_volume_db(2)
	focus_disable()
	flscrn.pressed = OS.window_fullscreen
# warning-ignore:standalone_expression
	debug.pressed = bool(get_tree().get_root().find_node("DebugUI", true, false) != null)
func focus_disable():
	$Margin/VBoxContainer/Tabs/Display/VBoxContainer/Resolution.focus_mode = 0
	$Margin/VBoxContainer/Tabs/Display/VBoxContainer/Debug.focus_mode = 0
	flscrn.focus_mode = 0
func _on_MSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_MuSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_SSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_TabContainer_tab_changed(tab) -> void:
	if tab == 3:
		Audio.play_back()
		queue_free()
	else:
		Audio.play_dialogue()

func _on_Fullscreen_pressed():
	Audio.play_dialogue()
	OS.window_fullscreen = flscrn.pressed
func _on_Debug_pressed():
	Audio.play_dialogue()
	if debug.pressed == true:
		get_tree().get_root().add_child(debug_ui.instance())
	else:
		get_tree().get_root().find_node("DebugUI", true, false).queue_free()
