extends CanvasLayer

func _ready():
	if PlayerStats.current_menu == "none":
		$Label.rect_position = Vector2(80,144)
	else:
		$Label.rect_position = Vector2(80,100)
	$Label.text = PlayerStats.alerts[PlayerStats.alert_id]
	$AnimationPlayer.play("Fade")
