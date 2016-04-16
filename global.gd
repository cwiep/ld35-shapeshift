
extends Node

const TARGETS = {
	"book": 0,
	"computer": 1
}

var current_target

func _ready():
	roll_new_target()

func roll_new_target():
	var new_target = current_target
	while new_target == current_target:
		new_target = TARGETS[TARGETS.keys()[randi() % TARGETS.size()]]
	current_target = new_target
