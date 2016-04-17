
extends CanvasLayer

var target_labels
var global_node

# assigns "target" -> "label_index"
var targets_map

func _ready():
	set_fixed_process(true)
	target_labels = []
	target_labels.append(get_node("target1"))
	target_labels.append(get_node("target2"))
	target_labels.append(get_node("target3"))
	global_node = get_node("/root/global")
	_setup_targets_map()

func _setup_targets_map():
	targets_map = {}
	var label_index = 0
	for t in global_node.TARGETS:
		if global_node.is_in_targets(t):
			targets_map[t] = label_index
			label_index += 1
		if label_index > 2:
			# we have a maximum of 3 targets
			break

func _fixed_process(delta):
	var current_targets = global_node.current_targets
	# this is very dirty, but we know that there are only three targets
	for target in targets_map.keys():
		if global_node.is_in_targets(target):
			target_labels[targets_map[target]].set_text(target)
		elif targets_map.has(target):
			target_labels[targets_map[target]].set_text("")
