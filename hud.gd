
extends CanvasLayer

var target_labels
var global_node

func _ready():
	set_fixed_process(true)
	target_labels = []
	target_labels.append(get_node("target1"))
	target_labels.append(get_node("target2"))
	target_labels.append(get_node("target3"))
	global_node = get_node("/root/global")

func _fixed_process(delta):
	var current_targets = global_node.current_targets
	# this is very dirty, but we know that there are only three targets
	var idx = 0
	for target in current_targets.keys():
		if global_node.is_in_targets(target):
			target_labels[idx].set_text(target)
		else:
			target_labels[idx].set_text("")
		idx += 1
