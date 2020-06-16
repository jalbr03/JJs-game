extends Camera

signal animation_fin
var animation_spd = 2
var animate = false
var look_at_target = "noone"
var type_string = 4
var current_pose = translation
var pose = Vector3.ZERO
var max_dist = 0
var target_off_set
#var x = translation.x
#var y = translation.y
#var z = translation.z

func _process(delta):
	#if((x != pose_x || y != pose_y || z != pose_z)&&animate):
	if(animate):
		var dist_to_pose = translation.distance_to(pose)
		if(dist_to_pose > 0.1):
			translation = lerp(translation,pose,0.15)
			if(typeof(look_at_target) != type_string && dist_to_pose < max_dist):
				look_at(look_at_target+target_off_set,Vector3(0,1,0))
		else:#(animate):
			animate = false
			emit_signal("animation_fin",look_at_target)
			if(typeof(look_at_target) == type_string):
				rotation = Vector3.ZERO
	

func _on_player_camera_move_to(go_to_pose,look_target,off_set):
#	pose_x = x
#	pose_y = y
#	pose_z = z
	target_off_set = off_set
	translation += target_off_set
	pose = go_to_pose
	look_at_target = look_target
	animate = true
	if(typeof(look_at_target) != type_string):
		max_dist = translation.distance_to(pose)
	#look_at(look_target.translation,Vector3(0,1,0))
