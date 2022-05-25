extends CanvasLayer

func _ready():
	$Label.text = PlayerStats.alerts[PlayerStats.alert_id]
	$AnimationPlayer.play("Fade")
func _process(_delta):
	if PlayerStats.current_menu == "none" and PlayerStats.slot_selector == null:
		$Label.rect_position = Vector2(80,144)
	else:
		$Label.rect_position = Vector2(80,100)
