extends Tabs

func _on_FPS_item_selected(_index):
	if $HBox/VBox/FPS.text != "Unlimited":
		Engine.target_fps = int($HBox/VBox/FPS.text)
	else:
		Engine.target_fps = 0
	print(Engine.target_fps)
	Settings.save_display("fps", Engine.target_fps)


func _on_Resolution_item_selected(_index):
	pass
