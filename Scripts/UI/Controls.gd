extends Tabs

onready var buttonscript = load("res://Scripts/UI/KeyButton.gd")

var keybinds
var buttons = {}

var labels = {
	"ui_up":"Up", 
	"ui_down":"Down", 
	"ui_left":"Left", 
	"ui_right":"Right", 
	"interact":"Interact", 
	"map":"Map", 
	"ui_accept":"Confirm", 
	"ui_cancel":"Exit"
	}
func _ready():
	keybinds = Game.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = labels[key]
		#label.text = label.text.capitalize()
		
		var button_value = keybinds[key]
		
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		hbox.add_child(label)
		hbox.add_child(button)
		$VBoxContainer.add_child(hbox)
		
		buttons[key] = button

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"


func _on_Save_pressed():
	Game.keybinds = keybinds.duplicate()
	Game.set_game_binds()
	Game.write_config()
	
