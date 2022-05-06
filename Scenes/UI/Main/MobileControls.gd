extends CanvasLayer

var joystick_active = false
var move_vector
func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $Joystick.is_pressed():
			move_vector = calculate(event.position)
			joystick_active = true
			$Circle.position = Vector2(56,130)
			$Circle.position += (event.position-Vector2(56,130)).normalized() * Vector2(24,24)

	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false
			$Circle.position = Vector2(56,130)
			PlayerStats.input_vector = Vector2.ZERO
func _physics_process(_delta):
	if joystick_active:
		PlayerStats.input_vector = move_vector
		
func calculate(pos):
	var center = $Joystick.position + Vector2(24,24)
	return (pos - center).normalized()
