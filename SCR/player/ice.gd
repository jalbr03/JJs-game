extends Node

var player
var alarm0 = -1
var global_delta

export var bullet_scene = preload("res://scenes/bullet.tscn")
export var stomp_scene = preload("res://scenes/stomp_blast.tscn")

var cam
var gimble
var animations
var animation_player
var stomp_str = 200
var stomp_range = 20
var cam_move_to = Vector3.ZERO

enum player_states{
	passive,
	ability_1,
	ability_2
}
var states_array = ["","",""]
var state
func ready():
	states_array[player_states.passive] = "scr_ability_passive"
	states_array[player_states.ability_1] = "scr_ability_1"
	states_array[player_states.ability_2] = "scr_ability_2"

func process(delta):
	global_delta = delta
	if(player.ability_2_cool_down > 0):
		player.ability_2_cool_down -= 1
	call(states_array[state])


func scr_ability_passive():
	player.player_lock = false

func scr_ability_1():
	#ice from floor
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = 2
		cam_move_to = Vector3(0,5,20)
		player.camera_move(cam_move_to,"player",Vector3.ZERO)#x,y,z,look at
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		#player.cam_lock = false
		cam_move_to = Vector3.ZERO
		player.camera_move(cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
		player.state = player_states.passive
	else:
		alarm0-=1*global_delta
	#end of alarm stuff

func scr_ability_2():
	#fire stomp
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = 3
		
		player.cam_lock = true
		player.player_lock = true
		gimble.rotation.x = 0
		
		var target = player.translation
		var off_set = Vector3(0,5,0)
		cam_move_to = Vector3(0,15,15)
		player.camera_move(cam_move_to,target,off_set)#xyz,look at,off set
		
		animations.set("parameters/one_shot_ability/active",true)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		player.cam_lock = false
		
		cam_move_to = Vector3.ZERO
		player.camera_move(cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
		
		player.state = player_states.passive
	else:
		alarm0-=1*global_delta
	#end of alarm stuff
	if(player.ability_2_cool_down <= 0):
		if(player.animation_player.current_animation_position >= 1.3):#animation_player.current_animation_length-0.3):
			spawn_blast()
			player.ability_2_cool_down = 90

#spawn things
func spawn_bullet(size,life):
	var bullet = bullet_scene.instance()
	player.get_parent().add_child(bullet)
	
	var bullet_pos = (player.global_transform.basis.z*-2)
	bullet.type = 0
	bullet.translation = player.translation+bullet_pos
	bullet.rotation = cam.global_transform.basis.get_euler()#cam.rotation
	bullet.scale = size
	bullet.life_span = life
	return bullet

func spawn_blast():
	#stomp
	var stomp_blast = stomp_scene.instance()
	player.get_parent().add_child(stomp_blast)
	stomp_blast.translation = player.translation
	stomp_blast.splash_size = Vector3(stomp_range,stomp_range,stomp_range)
	player.impulse(stomp_str,stomp_range,0.02,player)#str,range,id

func cam_end_animation(camera_target):
	if(state == player_states.ability_2):
		if(str(camera_target) != "noone"):
			pass
			#spawn_blast()
	
	if(state == player_states.ability_1):
		if(str(camera_target) == "player"):
			pass
			
