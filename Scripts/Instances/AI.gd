extends Resource

class_name Citizen

var memory = {}

"""
lkdsjglsdkgj

Winning: day 7, getting all the money, you get the role royal
Surviving: eating, buying food
Wealth/Status: homeowner w/ work, money

Loyalty: 
Stealing:
Sharing:
Lying:
Selfless:
Selfish:
"""

func _ready():
	pass
	
var can_move = true
var sleeping : bool = false

const names = ["","Homeowner","Housekeeper","Prisoner","Undead","Spirit"]

var gold : int

var life : int
var status : String
const base_speed = 127.5
var input_vector = Vector2.ZERO

var speed = base_speed
var can_eat = true
var can_sleep = false
