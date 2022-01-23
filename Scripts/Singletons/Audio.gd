extends Node

var menu = preload("res://Audio/Music/menu.ogg")
var town = preload("res://Audio/Music/town.ogg")

var select = preload("res://Audio/SFX/select.wav")
var confirm = preload("res://Audio/SFX/confirm.wav")
var back = preload("res://Audio/SFX/back.wav")

func _ready():
	if get_tree().current_scene.name == "Menu":
		call_deferred("play_menu")

func play_menu():
	stop_all()
	$Menu.volume_db = -80
	$Menu.stream = menu
	$Menu.play()
	$Tween.interpolate_property($Menu,"volume_db", -80, 0, 1, 2)
	$Tween.start()

func fade_out(music):
	$Tween.interpolate_property(music, "volume_db", music.volume_db, -80, 2)
	$Tween.start()
	
func play_select():
	$Select.stream = select
	$Select.play()

func play_confirm():
	$Confirm.stream = confirm
	$Confirm.play()

func play_back():
	$Back.stream = back
	$Back.play()

func play_back2():
	$Back2.stream = back
	$Back2.play()
	
func play_town():
	stop_all()
	$Town.volume_db = -80
	$Tween.interpolate_property($Town,"volume_db", -80, 0, 1, 2)
	$Tween.start()
	$Town.stream = town
	$Town.play()

func play_dialogue():
	$Dialogue.stream = select
	$Dialogue.play()
func stop_all():
	$Menu.stop()
	$Town.stop()
