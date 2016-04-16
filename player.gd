
extends Area2D

var player_image
var animation_timer

# variables for moving up/down stairs
var can_use_stairs
var is_using_stairs
var stairs_move_target
var current_stairs

# collecting targets
var can_collect_target

# shapeshifting
var is_attacking

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	player_image = get_node("Sprite")
	can_use_stairs = false
	is_using_stairs = false
	can_collect_target = false
	is_attacking = false
	animation_timer = 0
	
func _input(event):
	if event.is_action_pressed("ui_accept") and !event.is_echo() and !is_attacking:
		if get_node("person_look_left").is_colliding():
			if get_node("person_look_left").get_collider().is_in_group("prof"):
				is_attacking = true
				get_node("person_look_left").get_collider().kill()
			
func _fixed_process(delta):
	# check for collectible objectives
	if can_collect_target:
		get_node("../hud/target").set_text("collect")
	else:
		get_node("../hud/target").set_text("")
	
	# update animation
	animation_timer += delta
	if animation_timer >= 0.8:
		animation_timer = 0
		# any attack ends after one animation cycle
		is_attacking = false
	
	if is_using_stairs:
		# move player towards stairs target
		set_pos(Vector2(lerp(get_pos().x, stairs_move_target.x, 0.05), lerp(get_pos().y, stairs_move_target.y, 0.05)))
		if get_pos().distance_to(stairs_move_target) < 3:
			set_pos(stairs_move_target)
			is_using_stairs = false
			stairs_move_target = current_stairs.get_stairs_target(get_pos())
		# todo: play normal walk animation
	elif is_attacking:
		print("is attacking")
	else:
		# otherwise allow normal motion
		if Input.is_action_pressed("ui_left") and !get_node("look_left").is_colliding():
			translate(Vector2(-400 * delta, 0))
			
			# animate player walking
			player_image.set_flip_h(false)
			player_image.set_frame(int(animation_timer / 0.2))

		elif Input.is_action_pressed("ui_right") and !get_node("look_right").is_colliding():
			translate(Vector2(400 * delta, 0))

			# animate player walking
			player_image.set_flip_h(true)
			player_image.set_frame(int(animation_timer / 0.2))

		else:
			player_image.set_frame(0)
		
		if Input.is_action_pressed("ui_accept") and can_use_stairs:
			is_using_stairs = true
		
func _on_player_area_enter( area ):
	if area.is_in_group("stairs"):
		can_use_stairs = true
		current_stairs = area
		stairs_move_target = area.get_stairs_target(get_pos())
	elif area.is_in_group("book") and get_node("/root/global").current_target == get_node("/root/global").TARGETS["book"]:
		can_collect_target = true
	elif area.is_in_group("computer") and get_node("/root/global").current_target == get_node("/root/global").TARGETS["computer"]:
		can_collect_target = true

func _on_player_area_exit( area ):
	if area.is_in_group("stairs"):
		can_use_stairs = false
	elif area.is_in_group("book") and get_node("/root/global").current_target == get_node("/root/global").TARGETS["book"]:
		can_collect_target = false
	elif area.is_in_group("computer") and get_node("/root/global").current_target == get_node("/root/global").TARGETS["computer"]:
		can_collect_target = false