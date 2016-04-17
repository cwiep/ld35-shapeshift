
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
var target_in_sight
var target_type

# shapeshifting
var is_attacking
const ray_left = Vector2(-30, 0)
const ray_right = Vector2(30, 0)
var current_shape
const attack_frames = [11, 8, 9, 10, 10, 9, 8, 11]
var attack_timer
var changed_shape

var global_node

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	player_image = get_node("sprite_guest_m")
	current_shape = "guest_m"
	can_use_stairs = false
	is_using_stairs = false
	can_collect_target = false
	target_in_sight = null
	is_attacking = false
	animation_timer = 0
	global_node = get_node("/root/global")
	attack_timer = 0
	changed_shape = false
	
func _input(event):
	if is_attacking:
		# block all moves when attacking
		return
	if event.is_action_pressed("ui_attack") and !event.is_echo():
		var colliding_ray = null
		if get_node("person_look").is_colliding():
			colliding_ray = get_node("person_look")
		if colliding_ray != null:
			var collider = colliding_ray.get_collider()
			if collider.is_in_group("prof"):
				is_attacking = true
				# change player sprite to killed type
				current_shape = "prof_m"
			elif collider.is_in_group("guest_w"):
				is_attacking = true
				get_node("SamplePlayer").play("hit")
				# change player sprite to killed type
				current_shape = "guest_w"
			elif collider.is_in_group("guest_m"):
				is_attacking = true
				# change player sprite to killed type
				current_shape = "guest_m"
			
			if is_attacking:
				attack_timer = 0
				changed_shape = false
				collider.kill()
				get_node("SamplePlayer").play("hit")
			
	elif event.is_action_pressed("ui_quit") and !event.is_echo():
		get_tree().change_scene("res://menu.tscn")
		
func _fixed_process(delta):	
	# update animation
	animation_timer += delta
	if animation_timer >= 0.8:
		animation_timer = 0

	if is_attacking:
		attack_timer += delta
		if attack_timer >= 1.6:
			is_attacking = false
			
	if is_using_stairs:
		# move player towards stairs target
		set_pos(Vector2(lerp(get_pos().x, stairs_move_target.x, 0.05), lerp(get_pos().y, stairs_move_target.y, 0.05)))
		if get_pos().distance_to(stairs_move_target) < 3:
			set_pos(stairs_move_target)
			is_using_stairs = false
			stairs_move_target = current_stairs.get_stairs_target(get_pos())
		player_image.set_frame(int(animation_timer / 0.2))
	elif is_attacking:
		# attack lasts two animation cycles and blocks all movement
		# player_image.set_frame(11)
		if attack_timer > 0.8 and !changed_shape:
			changed_shape = true
			_set_sprite_for_type(current_shape)
		player_image.set_frame(attack_frames[int(attack_timer / 0.2)])
	else:
		# otherwise allow normal motion
		if Input.is_action_pressed("ui_left"):
			var move_allowed = false
			if get_node("look_left").is_colliding():
				var collider = get_node("look_left").get_collider()
				if collider.has_method("is_allowed"):
					if collider.is_allowed(current_shape):
						move_allowed = true
			else:
				move_allowed = true
				
			if move_allowed:
				translate(Vector2(-400 * delta, 0))
				# animate player walking
				player_image.set_frame(int(animation_timer / 0.2))
			
			player_image.set_flip_h(false)
			# set person detection ray accordingly
			get_node("person_look").set_cast_to(ray_left)
		elif Input.is_action_pressed("ui_right"):
			var move_allowed = false
			if get_node("look_right").is_colliding():
				var collider = get_node("look_right").get_collider()
				if collider.has_method("is_allowed"):
					if collider.is_allowed(current_shape):
						move_allowed = true
			else:
				move_allowed = true
				
			if move_allowed:
				translate(Vector2(400 * delta, 0))
				# animate player walking
				player_image.set_frame(int(animation_timer / 0.2))

			player_image.set_flip_h(true)
			# set person detection ray accordingly
			get_node("person_look").set_cast_to(ray_right)
		else:
			player_image.set_frame(0)
		
		if Input.is_action_pressed("ui_collect"):
			# collect key uses stairs and collects items
			if can_use_stairs:
				is_using_stairs = true
			elif can_collect_target:
				global_node.set_is_collected(target_type)
				target_in_sight.hide()
				can_collect_target = false
				get_node("SamplePlayer").play("collect")
		
func _on_player_area_enter( area ):
	if area.is_in_group("stairs"):
		can_use_stairs = true
		current_stairs = area
		stairs_move_target = area.get_stairs_target(get_pos())
	elif area.has_method("get_target_type"):
		target_type = area.get_target_type()
		if global_node.is_in_targets(target_type):
			can_collect_target = true
			target_in_sight = area

func _on_player_area_exit( area ):
	if area.is_in_group("stairs"):
		can_use_stairs = false
	elif area.has_method("get_target_type"):
		target_type = area.get_target_type()
		if global_node.is_in_targets(target_type):
			can_collect_target = false
			
func causes_panic():
	return is_attacking
	
func _set_sprite_for_type(type):
	# hide current shape
	player_image.hide()
	var flip = player_image.is_flipped_h()
	# set new shape
	if type == "prof_m":
		player_image = get_node("sprite_prof_m")
	if type == "guest_w":
		player_image = get_node("sprite_guest_w")
	if type == "guest_m":
		player_image = get_node("sprite_guest_m")
	player_image.show()
	# set correct direction of new shape
	player_image.set_flip_h(flip)