extends Resource
class_name Card

export (String) var name
export (String) var type
export (String) var desc

#When making custom cards: base_cost and base_stock are the costs per person
#costs and  multiplied by int(randi() % 3 - 1 + floor(0.4day))

"""
when lower case "town", "merchant", "dungeon", "none", "random"

"""
export (int, 0, 9) var base_cost
export (float, 0, 18) var base_stock
export (String, "none", "town", "merchant", "dungeon") var market
export (int, 0, 6) var unlock_day

export (Dictionary) var properties = {
	"use":{},
	"hold":{},
	"drop":{},
}
