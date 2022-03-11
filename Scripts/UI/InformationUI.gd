extends CanvasLayer

func _ready():
	$Label.text = PlayerStats.alerts[PlayerStats.alert_id]
	$AnimationPlayer.play("Fade")
	call_deferred("wait")

func wait():
	yield(get_tree().create_timer(3), "timeout")
	$AnimationPlayer.play_backwards("Fade")
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
