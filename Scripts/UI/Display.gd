extends Tabs

var fps_list = {0:0,120:1,90:2,60:3,30:4}
func _ready():
	if Settings.fps != 0:
		$HBox/VBox/FPS.text = str(Settings.fps)
	else:
		$HBox/VBox/FPS.text = "Unlimited"
	$HBox/VBox/FPS.select(fps_list[Settings.fps])
	$HBox/VBox/Resolution.selected = Settings.resolution
	$HBox/VBox/Resolution.text = $HBox/VBox/Resolution.get_item_text(Settings.resolution)
	
func _on_FPS_item_selected(_index):
	if $HBox/VBox/FPS.text != "Unlimited":
		Engine.target_fps = int($HBox/VBox/FPS.text)
	else:
		Engine.target_fps = 0
	Settings.save_display("fps", Engine.target_fps)
	Settings.fps = Engine.target_fps

func _on_Resolution_item_selected(_index):
	OS.window_size = Vector2(320*2,180*2) * ($HBox/VBox/Resolution.selected + 1)
	Settings.resolution = $HBox/VBox/Resolution.selected
	Settings.save_display("resolution", int($HBox/VBox/Resolution.selected))
