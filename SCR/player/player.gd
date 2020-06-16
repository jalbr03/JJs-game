extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"\

signal impulse
signal self_id

var alarm0 = -1
var global_delta

const scr_fire_abilities = preload("fire.gd")
var fire_abilities = scr_fire_abilities.new()

export var bullet_scene = preload("res://scenes/bullet.tscn")
export var stomp_scene = preload("res://scenes/stomp_blast.tscn")

onready var cam = $gimble/Camera
onready var gimble = $gimble
onready var animations = $AnimationTree
onready var animation_player = $AnimationPlayer
signal camera_move_to
var cam_lock = false
var player_lock = false

var velocity = Vector3.ZERO
var GRV = 0.98
var move_h
var move_v
var animation_blend = 0
const UP = Vector3(0,-1,0)
const SPEED = 10
const JUMP_HEIGHT = 100
const EXEL = 0.1

var elements = [fire_abilities]
var current_element = elements[0]
var ability_1_cool_down = 0
var ability_2_cool_down = 0

enum player_states{
	passive,
	ability_1,
	ability_2
}
var state = player_states.passive
var last_state = state
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("self_id",self)
	current_element.player = self
	current_element.ready()
	current_element.cam = cam
	current_element.gimble = gimble
	current_element.animations = animations
	current_element.animation_player = animation_player
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#OS.window_fullscreen = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_delta = delta
	velocity.y -= GRV
	current_element.state = state
	current_element.process(delta)
	scr_move()
	if(last_state != state):
		alarm0 = -1
	last_state = state
	
	#attack stuff
	var ability_1 = Input.is_key_pressed(KEY_E)
	var ability_2 = Input.is_key_pressed(KEY_Q)
	
	if(ability_1 && ability_1_cool_down <= 0):
		state = player_states.ability_1
	if(ability_2 && ability_2_cool_down <= 0):
		state = player_states.ability_2
	
	
	
	velocity = move_and_slide(velocity, UP)
	#options
	var quit = Input.is_key_pressed(KEY_ESCAPE)
	if(quit):
		get_tree().quit()
	
func _unhandled_input(event):
	if(!cam_lock):
		if(event is InputEventMouseMotion):
			rotation.y -= deg2rad(event.relative.x)*0.1
			gimble.rotation.x -= deg2rad(event.relative.y)*0.1
			gimble.rotation.x = clamp(gimble.rotation.x,-1.57,1.57)
		
#		#shoot
#		if event is InputEventMouseButton:
#			if event.button_index == BUTTON_LEFT and event.pressed:
#				if(state == player_states.passive):
#					state = player_states.ability_1
		

func scr_move():
	var left = Input.is_key_pressed(KEY_A)
	var right = Input.is_key_pressed(KEY_D)
	var forward = Input.is_key_pressed(KEY_W)
	var backward = Input.is_key_pressed(KEY_S)
	var jump = Input.is_key_pressed(KEY_SPACE)
	#move stuff
	if(!player_lock):
		var move_h = (int(right)-int(left))
		var move_v = (int(backward)-int(forward))
		var move = Vector2(move_h,move_v)
		move = move.normalized().rotated(-rotation.y)*SPEED
		velocity.x = lerp(velocity.x,move.x,EXEL)
		velocity.z = lerp(velocity.z,move.y,EXEL)
		velocity.y += int(jump)*int(is_on_floor())*JUMP_HEIGHT
		
		animation_blend += (clamp(abs(move_h)+abs(move_v),0,1)-animation_blend)*EXEL
		animations.set("parameters/Blend_Idle_Move/blend_amount",animation_blend)
	
	

func impulse(imp_str,imp_range,imp_time,id):
	emit_signal("impulse",imp_str,imp_range,imp_time,id)#str,range,id
func camera_move(cam_move_to,target,off_set):
	emit_signal("camera_move_to",cam_move_to,target,off_set)#xyz,look at,off set
func _on_Camera_animation_fin(camera_target):
	current_element.cam_end_animation(camera_target)



#func scr_fire_ball():
#	#alarm stuff
#	if(alarm0 == -1): #start of alarm
#		alarm0 = 2
#		velocity.y = 40
#		#cam_lock = true
#		#gimble.rotation.x = 0
#		var target = translation
#		#target.y+=20
#		#var off_set = Vector3(0,20,0)
#		cam_move_to = Vector3(0,5,20)
#		emit_signal("camera_move_to",cam_move_to,"player",Vector3.ZERO)#x,y,z,look at
#		#stomp_cooldown = 90
#	elif(alarm0 <= 0): #end of alarm
#		alarm0 = -1
#		cam_lock = false
#		cam_move_to = Vector3.ZERO
#		emit_signal("camera_move_to",cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
##			cam.rotation = Vector3.ZERO
#		state = player_states.move
#	else:
#		scr_move()
#		if(velocity.y <= 0):
#			velocity.y = 0
#		alarm0-=1*global_delta
#
#	#end of alarm stuff
#
#func scr_stomp():
#	#alarm stuff
#	#print(alarm0)
#	if(alarm0 == -1): #start of alarm
#		alarm0 = 3
#		cam_lock = true
#		gimble.rotation.x = 0
#		var target = self.translation
#		#target.y+=5
#		var off_set = Vector3(0,5,0)
#		cam_move_to = Vector3(0,15,15)
#		emit_signal("camera_move_to",cam_move_to,target,off_set)#x,y,z,look at
#		animations.set("parameters/one_shot_ability/active",true)
#	elif(alarm0 <= 0): #end of alarm
#		alarm0 = -1
#		cam_lock = false
#		cam_move_to = Vector3.ZERO
#		emit_signal("camera_move_to",cam_move_to,"noone",Vector3.ZERO)#x,y,z,look at
##		cam.rotation = Vector3.ZERO
#		state = player_states.move
#	else:
#		alarm0-=1*global_delta
#	#end of alarm stuff
#	#print(!animations.get("parameters/one_shot_ability/active"))
#	print("poso"+str(animation_player.current_animation_position))
#	if(stomp_cooldown <= 0):
#		if(animation_player.current_animation_position >= 1.3):#animation_player.current_animation_length-0.3):
#			spawn_blast()
#			#animations.set("parameters/smash_pause/scale",0)
#			stomp_cooldown = 90
#
##spawn things
#func spawn_bullet(size,life):
#	var bullet = bullet_scene.instance()
#	get_parent().add_child(bullet)
#
#	var bullet_pos = (global_transform.basis.z*-2)
#	bullet.type = 0
#	bullet.translation = translation+bullet_pos
#	bullet.rotation = cam.global_transform.basis.get_euler()#cam.rotation
#	bullet.scale = size
#	bullet.life_span = life
#	return bullet
#	#bullet_scene.instance()
#
#func spawn_blast():
#	#stomp
#	var stomp_blast = stomp_scene.instance()
#	get_parent().add_child(stomp_blast)
#	stomp_blast.translation = translation
#	stomp_blast.splash_size = Vector3(stomp_range,stomp_range,stomp_range)
#	emit_signal("impulse",stomp_str,stomp_range,0.02,self)#str,range,id
#	#end of stomp

#communicate

