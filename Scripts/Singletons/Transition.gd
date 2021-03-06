extends CanvasLayer


onready var animation = $AnimationPlayer
onready var rect = $ColorRect
var scene : String
var current

func _ready():
	rect.color = ("f4c497")
	get_tree().paused = true
	call_deferred("splash_fade")

func splash_fade():
	animation.play("SplashFade")
func unpause_tree():
	get_tree().paused = false
func fade_audio_out():
	Audio.fade_out()

# warning-ignore:unused_argument
func change_scene(new_scene, current_scene, transition):
	current = current_scene
	scene = new_scene
	get_tree().paused = false
	animation.play(transition)
	rect.mouse_filter = Control.MOUSE_FILTER_STOP


func _new_scene():
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene)
	current.queue_free()
	get_tree().paused = false
	return

func load_scene(path, now):
	var loader = ResourceLoader.load_interactive(path)
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var _resource = loader.get_resource()
			call_deferred("change_scene", path, now, "QuickFade")
			break
		elif err == OK:
			var _progress = float(loader.get_stage())/loader.get_stage_count()

func sleep_blackout():
	layer = 1
	animation.play("Sleep")

func wake():
	layer = 2
	if animation.is_playing():
		animation.stop()
	rect.color = Color("00000000")
