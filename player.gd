
extends Area2D

var player_image
var anim_node

# variables for moving up/down stairs
var can_use_stairs
var is_using_stairs
var stairs_move_target
var current_stairs

# collecting targets
var can_collect_target

func _ready():
	set_fixed_process(true)
	player_image = get_node("Sprite")
	anim_node = get_node("Sprite/walk_anim")
	can_use_stairs = false
	is_using_stairs = false
	can_collect_target = false
	
func _fixed_process(delta):
	if can_collect_target:
		get_node("../hud/target").set_text("collect")
	else:
		get_node("../hud/target").set_text("")
		
	if is_using_stairs:
		# move player toward target
		set_pos(Vector2(lerp(get_pos().x, stairs_move_target.x, 0.05), lerp(get_pos().y, stairs_move_target.y, 0.05)))
		if get_pos().distance_to(stairs_move_target) < 3:
			set_pos(stairs_move_target)
			is_using_stairs = false
			stairs_move_target = current_stairs.get_stairs_target(get_pos())
	else:
		# otherwise allow normal motion
		if Input.is_action_pressed("ui_left") and !get_node("look_left").is_colliding():
			translate(Vector2(-400 * delta, 0))
				
			if anim_node.get_current_animation() != "walk_left":
				anim_node.set_current_animation("walk_left")

		elif Input.is_action_pressed("ui_right") and !get_node("look_right").is_colliding():
			translate(Vector2(400 * delta, 0))

			if anim_node.get_current_animation() != "walk_right":
				anim_node.set_current_animation("walk_right")

		else:
			if player_image.is_flipped_h():
				anim_node.set_current_animation("stand_right")
			else:
				anim_node.set_current_animation("stand_left")
		anim_node.advance(delta)
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