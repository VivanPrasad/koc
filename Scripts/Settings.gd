extends CanvasLayer

onready var master_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer3/MSlider
onready var music_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer/MuSlider
onready var sfx_vol = $Margin/VBoxContainer/Tabs/Audio/VBoxContainer/HBoxContainer2/SSlider2

onready var debug = $Margin/VBoxContainer/Tabs/Display/HBox/VBox2/Debug
onready var flscrn = $Margin/VBoxContainer/Tabs/Display/HBox/VBox2/Fullscreen/

var new_color : Color

onready var debug_ui = preload("res://Scenes/UI/Settings/DebugUI.tscn")
func _ready():
	debug.pressed = bool(get_tree().get_root().find_node("DebugUI", true, false) != null)
	master_vol.value = Settings.master_vol
	music_vol.value = Settings.music_vol
	sfx_vol.value = Settings.sfx_vol
	focus_disable()
	flscrn.pressed = OS.window_fullscreen
# warning-ignore:standalone_expression

func focus_disable():
	$Margin/VBoxContainer/Tabs/Display/HBox/VBox/Resolution.focus_mode = 0
	$Margin/VBoxContainer/Tabs/Display/HBox/VBox/FPS.focus_mode = 0
	$Margin/VBoxContainer/Tabs/Display/HBox/VBox2/Debug.focus_mode = 0
	flscrn.focus_mode = 0
func _on_MSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	Settings.master_vol = value
	Settings.save_audio("master", value)

func _on_MuSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	Settings.music_vol = value
	Settings.save_audio("music", value)
func _on_SSlider_value_changed(value)  -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	Settings.sfx_vol = value
	Settings.save_audio("sfx", value)
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



