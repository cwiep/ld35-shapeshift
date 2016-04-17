
extends Node

const TARGETS = {
	"book": 0,
	"computer": 1,
	"toiletpaper": 2
}

var current_targets

func _ready():
	current_targets = {TARGETS.book: 1, TARGETS.computer: 1, TARGETS.toiletpaper: 1}
	#roll_new_target()

func is_in_targets(object):
	# 1 being item is in current targets and has not yet been collected
	return current_targets[object] == 1

func set_is_collected(object):
	current_targets[object] = 0

func roll_new_target():
	"""var new_target = current_target
	while new_target == current_target:
		new_target = TARGETS[TARGETS.keys()[randi() % TARGETS.size()]]
	current_target = new_target"""
	pass
