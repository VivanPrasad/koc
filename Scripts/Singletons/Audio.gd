extends Node

const menu = preload("res://Audio/Music/menu.ogg")
const town_day = preload("res://Audio/Music/day.ogg")
const town_night = preload("res://Audio/Music/night.ogg")
const castle = preload("res://Audio/Music/castle.ogg")
const dungeon = preload("res://Audio/Music/dungeon.ogg")
const shop = preload("res://Audio/Music/shop.ogg")
const sleep = preload("res://Audio/Music/sleep.ogg")

const select = preload("res://Audio/SFX/select.wav")
const confirm = preload("res://Audio/SFX/confirm.wav")
const back = preload("res://Audio/SFX/back.wav")

const door_open = preload("res://Audio/SFX/doorOpen.ogg")
const door_close = preload("res://Audio/SFX/doorClose.ogg")
const death = preload("res://Audio/SFX/dead.ogg")

const card = preload("res://Audio/SFX/card.wav")
var music_player : String
func _ready():
	if get_tree().current_scene.name == "Menu":
		call_deferred("play_menu")

func play_menu():
	stop_all()
	$Music.volume_db = -80
	$Music.stream = menu
	$Music.pitch_scale = 0.9
	$Music.play()
	$Tween.interpolate_property($Music,"volume_db", -80, 0, 1, 2)
	$Tween.start()
	music_player = "menu"

func fade_out():
	$Tween.interpolate_property($Music, "volume_db", 0, -80, 0.4)
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
	#$Town.volume_db = -80
	#$Tween.interpolate_property($Town,"volume_db", -80, 0, 1, 2)
	#$Tween.start()
	$Music.volume_db = -80
	play_day()

func play_castle():
	fade_out()
	$Tween.interpolate_property($Music,"volume_db", -80, -10, 0.5, 2)
	$Tween.start()
	$Music.pitch_scale = 1
	$Music.stream = castle
	music_player = "castle"
	$Music.play()

func play_day():
	fade_out()
	$Tween.interpolate_property($Music,"volume_db", -80, 0, 0.5, 2)
	$Tween.start()
	music_player = "town_day"
	$Music.stream = town_day
	$Music.pitch_scale = 1
	$Music.play()
func play_night():
	fade_out()
	$Tween.interpolate_property($Music,"volume_db", -80, -15, 10, 2)
	$Tween.start()
	$Music.stream = town_night
	$Music.pitch_scale = 0.9
	music_player = "town_night"
	$Music.play()
	$Music.stop()
func play_dungeon():
	fade_out()
	$Music.volume_db = -80
	$Tween.interpolate_property($Music,"volume_db", -80, -10, 0.5, 2)
	$Tween.start()
	$Music.stream = dungeon
	$Music.pitch_scale = 1
	music_player = "dungeon"
	$Music.play()
func play_shop():
	fade_out()
	$Tween.interpolate_property($Music,"volume_db", -80, 0, 0.5, 2)
	$Tween.start()
	$Music.stream = shop
	$Music.pitch_scale = 1
	music_player = "shop"
	$Music.play()
func play_dialogue():
	$Dialogue.stream = select
	$Dialogue.play()

func stop_all():
	$Music.stop()
	$Door.stop()

func play_door_open():
	$Door.stream = door_open
	$Door.pitch_scale = 1
	$Door.play()

func play_door_close():
	$Door.stream = door_close
	$Door.pitch_scale = 0.8
	$Door.play()

func play_death():
	stop_all()
	$Death.stream = death
	$Death.play()

func take_card():
	$TakeCard.stream = card
	$TakeCard.play()
