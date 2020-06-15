extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var scr_player = preload("player.gd")
var player = scr_player.new()
var alarm0 = -1
# Called when the node enters the scene tree for the first time.
func scr_ability_passive():
	pass

func scr_ability_1():
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = 2
		player.velocity.y = 40
		#cam_lock = true
		#gimble.rotation.x = 0
		var target = player.translation
		#target.y+=20
		#var off_set = Vector3(0,20,0)
		cam_move_to = Vector3(0,5,20)
		emit_signal("camera_move_to",cam_move_to,"player",Vector3.ZERO)#x,y,z,look at
		#stomp_cooldown = 90
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		cam_lock = false
		cam_move_to = Vector3.ZERO
		emit_signal("camera_move_to",cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
#			cam.rotation = Vector3.ZERO
		state = player_states.move
	else:
		scr_move()
		if(velocity.y <= 0):
			velocity.y = 0
		alarm0-=1*global_delta
		
	#end of alarm stuff

func scr_ability_2():
	#alarm stuff
	#print(alarm0)
	if(alarm0 == -1): #start of alarm
		alarm0 = 3
		cam_lock = true
		gimble.rotation.x = 0
		var target = self.translation
		#target.y+=5
		var off_set = Vector3(0,5,0)
		cam_move_to = Vector3(0,15,15)
		emit_signal("camera_move_to",cam_move_to,target,off_set)#x,y,z,look at
		animations.set("parameters/one_shot_ability/active",true)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		cam_lock = false
		cam_move_to = Vector3.ZERO
		emit_signal("camera_move_to",cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
#		cam.rotation = Vector3.ZERO
		state = player_states.move
	else:
		alarm0-=1*global_delta
	#end of alarm stuff
	#print(!animations.get("parameters/one_shot_ability/active"))
	print("poso"+str(animation_player.current_animation_position))
	if(stomp_cooldown <= 0):
		if(animation_player.current_animation_position >= 1.3):#animation_player.current_animation_length-0.3):
			spawn_blast()
			#animations.set("parameters/smash_pause/scale",0)
			stomp_cooldown = 90

#spawn things
func spawn_bullet(size,life):
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	
	var bullet_pos = (global_transform.basis.z*-2)
	bullet.type = 0
	bullet.translation = translation+bullet_pos
	bullet.rotation = cam.global_transform.basis.get_euler()#cam.rotation
	bullet.scale = size
	bullet.life_span = life
	return bullet
	#bullet_scene.instance()

func spawn_blast():
	#stomp
	var stomp_blast = stomp_scene.instance()
	get_parent().add_child(stomp_blast)
	stomp_blast.translation = translation
	stomp_blast.splash_size = Vector3(stomp_range,stomp_range,stomp_range)
	emit_signal("impulse",stomp_str,stomp_range,0.02,self)#str,range,id
	#end of stomp


