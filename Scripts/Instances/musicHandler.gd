extends Node2D

func _on_Castle_area_entered(_area):
	if Audio.music_player != "castle":
		Audio.play_castle()

func _on_Town_area_entered(_area):
		if $"/root/World/UI/DayInfo".hour > 3 and $"/root/World/UI/DayInfo".hour < 21:
			if Audio.music_player != "town_day":
				Audio.play_day()
		else:
			if Audio.music_player != "town_night":
				Audio.play_night()
