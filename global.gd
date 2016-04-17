
extends Node

const TARGETS = [
	"book",
	"computer",
	"toiletpaper"
]

var current_targets

func _ready():
	current_targets = {"book": 1, "computer": 1, "toiletpaper": 1}
	#roll_new_target()

func is_in_targets(target_string):
	# 1 being item is in current targets and has not yet been collected
	return current_targets[target_string] == 1

func set_is_collected(target_string):
	current_targets[target_string] = 0

func roll_new_target():
	"""var new_target = current_target
	while new_target == current_target:
		new_target = TARGETS[TARGETS.keys()[randi() % TARGETS.size()]]
	current_target = new_target"""
	pass
