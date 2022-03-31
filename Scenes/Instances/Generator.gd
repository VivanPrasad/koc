extends Node2D

var initial_pos = Vector2.ZERO
var random : int
var i : int
var branch = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
var space : int

func _ready():
	randomize()
	call_deferred("clear")
	call_deferred("gen_paths")
func clear():
	for y in 45:
		for x in 43:
			$Floor.set_cell(x-21,y-22,0)

func gen_paths():
	randomize()
	initial_pos = Vector2(randi() % 13-8, randi() % 13-8)
	$Floor.set_cell(initial_pos.x, initial_pos.y, 2)
	gen_town_square()
	randomize()
	if branch[0] != Vector2.ZERO:
		for y in randi() % 10 + 10:
			$Floor.set_cell(branch[0].x, branch[0].y - y, 1)
	if branch[1] != Vector2.ZERO:
		for x in randi() % 10 + 10:
			$Floor.set_cell(branch[1].x - x, branch[1].y, 1)
	#gen_castle()
func gen_town_square():
	random = randi() % 5+8
	randomize()
	i = randi() % 10 + 1
	for y in random:
		for x in random:
			if y==0:
				if x==0:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(2,0))
				elif x==random-1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, false, false, Vector2(2,0))
				elif x==1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, true, false, Vector2(7,0))
				elif x==random-2:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, true, false, Vector2(7,0))
				else:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(4,0))
					randomize()
					if randi() % 10 + 1 == i and branch[0] == Vector2.ZERO:
						branch[0] = Vector2(initial_pos.x + x,initial_pos.y - 1)
						$Floor.set_cell(branch[0].x, branch[0].y, 1)
						
			elif y==random-1:
				if x==0:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(3,0))
				elif x==random-1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, false, false, Vector2(3,0))
				elif x==1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, false, false, Vector2(6,0))
				elif x==random-2:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(6,0))
				else:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(5,0))
			elif x==0:
				if y==1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, true, false, Vector2(8,0))
				elif y==random-2:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, false, false, Vector2(8,0))
				else:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, true, Vector2(4,0))
					if randi() % 10 + 1 == i and branch[1] == Vector2.ZERO:
						branch[1] = Vector2(initial_pos.x - 1,initial_pos.y + y)
						$Floor.set_cell(branch[1].x, branch[1].y, 1)
			elif x==random-1:
				if y==1:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, true, false, Vector2(8,0))
				elif y==random-2:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, false, false, false, Vector2(8,0))
				else:
					$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 1, true, false, true, Vector2(4,0))
			else:
				$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 2)
				
				if x==1:
					if y==1:
						$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 2, false, false, false, Vector2(1,0))
					elif y==random-2:
						$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 2, true, true, false, Vector2(2,0))
				elif x==random-2:
					if y==1:
						$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 2, false, false, false, Vector2(2,0))
					elif y==random-2:
						$Floor.set_cell(initial_pos.x + x,initial_pos.y + y, 2, true, true, false, Vector2(1,0))

func gen_castle():
	randomize()
	initial_pos = Vector2(rand_range(-20, 0), rand_range(-20, 0))
	while $Floor.get_cell(initial_pos.x, initial_pos.y) != 0:
		randomize()
		initial_pos = Vector2(rand_range(-20, 0), rand_range(-20, 0))
	random = randi() % 5+8
	randomize()
	i = randi() % 10 + 1
	for y in random:
		for x in random*i:
			yield(get_tree().create_timer(0),"timeout")
			if initial_pos.x + x > 19 or initial_pos.x + x < -19:
				return
			elif initial_pos.y + y > 19 or initial_pos.y + y < -19:
				return
			if $Floor.get_cell(initial_pos.x + x, initial_pos.y + y) != 0:
				for j in initial_pos.y + y:
					for k in initial_pos.x + x:
						$Floor.set_cell(k, j, 0)
						yield(get_tree().create_timer(0),"timeout")
				gen_castle()
				break
			else:
				$Floor.set_cell(initial_pos.x + x, initial_pos.y + y, 4)
