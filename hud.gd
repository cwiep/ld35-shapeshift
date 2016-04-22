
extends CanvasLayer

var target_labels
var global_node

# assigns "target" -> "label_index"
var targets_map

var finished
var fadeout_timer
var gameover

func _ready():
	Globals.set("gameover", false)
	set_fixed_process(true)
	target_labels = []
	target_labels.append(get_node("target1"))
	target_labels.append(get_node("target2"))
	target_labels.append(get_node("target3"))
	global_node = get_node("/root/global")
	global_node.roll_new_targets()
	_setup_targets_map()
	fadeout_timer = 0
	finished = false
	gameover = false

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
	if Globals.get("gameover") and !gameover and !finished:
		gameover = true
		_prepare_fadeout()
	
	if !finished:
		if global_node.all_targets_collected():
			get_node("finished").show()
			finished = true
			_prepare_fadeout()
	
	if finished or gameover:
		# fadeout screen
		fadeout_timer -= delta
		get_node("..").set_opacity(fadeout_timer / 3.0)
		# show message
		if gameover:
			get_node("gameover").show()
		if finished:
			get_node("well_done").show()
		if fadeout_timer <= 0:
			# reload level to choose new targets
			get_tree().change_scene("res://house.tscn")
		
	var current_targets = global_node.current_targets
	# this is very dirty, but we know that there are only three targets
	for target in targets_map.keys():
		if global_node.is_in_targets(target):
			target_labels[targets_map[target]].set_text(target)
		elif targets_map.has(target):
			target_labels[targets_map[target]].set_text("")

func _prepare_fadeout():
	fadeout_timer = 3.0
	get_node("../player").set_fixed_process(false)
	get_node("../player").set_process_input(false)