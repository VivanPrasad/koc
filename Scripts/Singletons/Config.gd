extends Node

var configfile
var filepath = "user://data/settings.ini"
var keybinds = {}

var default_keybinds = {
	"ui_up":87,
	"ui_down":83,
	"ui_left":65,
	"ui_right":68,
	"interact":69,
	"map":77,
	"ui_accept":32,
	"ui_cancel":16777217
	}

var fps
var resolution

var master_vol :int
var music_vol :int
var sfx_vol:int
func _ready():
	load_config()

func load_config():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
		fps = configfile.get_value("display", "fps")
		resolution = configfile.get_value("display", "resolution")
		master_vol = configfile.get_value("audio","master")
		music_vol = configfile.get_value("audio","music")
		sfx_vol = configfile.get_value("audio","sfx")
		update_audio()
	else:
		new_config()
	set_game_binds()
		
func new_config():
# warning-ignore:return_value_discarded
	Directory.new().make_dir("user://data")
	configfile.set_value("display", "resolution", 1)
	configfile.set_value("display", "fps", 60)
	configfile.set_value("audio", "master", 0.0)
	configfile.set_value("audio", "music", 0.0)
	configfile.set_value("audio", "sfx", 0.0)
	for key in default_keybinds:
		configfile.set_value("keybinds", key, default_keybinds[key])
	configfile.save(filepath)
	load_config()
func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value) 
			InputMap.action_add_event(key,new_key)

func save_binds():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, "")
	configfile.save(filepath)
 
func save_display(type, value):
	configfile.set_value("display", type, value)
	configfile.save(filepath)

func save_audio(type, value):
	configfile.set_value("audio", type, value)
	configfile.save(filepath)

func update_audio():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_vol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_vol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_vol)
func add_object(_object, _hostDest,_destPath):
	pass

func get_object(_object):
	pass
