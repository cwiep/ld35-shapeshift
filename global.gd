
extends Node

const TARGETS = [
	"book",
	"computer",
	"toiletpaper",
	"beer",
	"hotdog"
]

var current_targets

func _ready():
	pass

func is_in_targets(target_string):
	# 1 being item is in current targets and has not yet been collected
	return current_targets[target_string] == 1

func set_is_collected(target_string):
	current_targets[target_string] = 0

func roll_new_targets():
	current_targets = {"book": 0, "computer": 0, "toiletpaper": 0, "beer": 0, "hotdog": 0}
	randomize()
	var rand_index = randi() % TARGETS.size()
	for i in range(3):
		while is_in_targets(TARGETS[rand_index]):
			rand_index = randi() % TARGETS.size()
		current_targets[TARGETS[rand_index]] = 1
	print(current_targets)

func all_targets_collected():
	for target in TARGETS:
		if current_targets[target] == 1:
			return false
	return true
	
func rand_choose(options):
	randomize()
	return options[randi() % options.size()]