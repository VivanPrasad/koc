extends CanvasLayer

func _physics_process(_delta):
	$MarginContainer/VBoxContainer/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$MarginContainer/VBoxContainer/Memory.text = "Static Memory: " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)) + "MB"
