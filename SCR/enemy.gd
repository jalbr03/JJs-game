extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var player = get_parent().get_parent().get_node("player")


var player

var impulse_str = 0
var impulse_id
var impulse_time
var impulse_dist

var velocity = Vector3.ZERO
const UP = Vector3(0,-1,0)
const SPEED = 5
const JUMP_HEIGHT = 100
const EXEL = 0.02
var fps = 0
var alarm0 = -1
var global_delta
export var seeing_range = 20

var move_h = 0
var move_v = 1
var move = Vector2(move_h,move_v)

enum enemy_states{
	idle,
	roam,
	fight,
	hide,
	impulse
}
var states_array = ["","","","",""]
var state = enemy_states.roam
var last_state = state

# Called when the node enters the scene tree for the first time.
func _ready(): 
	states_array[enemy_states.idle] = "scr_idle"
	states_array[enemy_states.roam] = "scr_roam"
	states_array[enemy_states.fight] = "scr_fight"
	states_array[enemy_states.hide] = "scr_hide"
	states_array[enemy_states.impulse] = "scr_impulse"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_delta = delta
	fps = Engine.get_frames_per_second()
	#print("fps "+str(Engine.get_frames_per_second()))
	velocity.y -= 0.98
	call(states_array[state])
	if(last_state != state):
		alarm0 = -1
		#print("ah change!")
	last_state = state
	
	#print(state)
	#knock back
	if(impulse_str != 0):
		if (str(impulse_id)!="[Deleted Object]" && str(impulse_id) != "0"):
			var dist_to_imp = translation.distance_to(impulse_id.translation)
			if(dist_to_imp<impulse_dist):
				state = enemy_states.impulse
	else:
		#see the player
		var a = self.get_transform().basis.z # Enemy's forward vector
		var b = (player.get_translation() - self.get_translation()).normalized() # Vector from enemy to player
		var dist = translation.distance_to(player.translation)
		if acos(a.dot(b))-rad2deg(180) <= deg2rad(60) && dist < seeing_range: # If the angle is less than or equal to 60 degrees
			state = enemy_states.fight
	
	#move stuff
	velocity = move_and_slide(velocity, UP)

#scripts----------------
func smooth_move():
	move = -Vector2(move_h,move_v)
	move = move.normalized().rotated(-rotation.y)*SPEED
	velocity.x = lerp(velocity.x,move.x,EXEL)
	velocity.z = lerp(velocity.z,move.y,EXEL)
func direct_move():
	move = -Vector2(move_h,move_v)
	move = move.rotated(-rotation.y)
	velocity.x = move.x
	velocity.z = move.y

func scr_idle():
	move_h = 0
	move_v = 0
	if(alarm0 == -1): #start of alarm
		alarm0 = rand_range(2,4)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		state = enemy_states.roam
	else:
		alarm0-=1
	smooth_move()
	#end of alarm stuff
	

func scr_roam():
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = rand_range(3,5)
		var rand_dir = rand_range(0,359)
		rotate_y(rand_dir)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		state = enemy_states.idle
	else:
		alarm0-=1*global_delta
	#end of alarm stuff
	
	move_v = 1 #forward
	smooth_move()

func scr_fight():
	var player_pose = player.global_transform.origin
	player_pose.y = translation.y
	look_at(player_pose,Vector3.UP)
	move_v = 1
	smooth_move()
	var dist = translation.distance_to(player.translation)
	if dist > seeing_range: 
		state = enemy_states.idle
		alarm0 = -1
	

func scr_hide():
	pass

func scr_impulse():
	#print(alarm0)
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = impulse_time
		#wr = weakref(impulse_id)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		impulse_str = 0
		state = enemy_states.idle
		impulse_id = 0
		impulse_time = 0
	else:
		alarm0-=1*global_delta
	#end of alarm stuff
	print(impulse_id)
	if (str(impulse_id)!="[Deleted Object]" && str(impulse_id) != "0"):
		var impulse_pos = impulse_id.global_transform.origin
		var self_pose = global_transform.origin
		velocity.z = (self_pose.z - impulse_pos.z)#*knock_back_str
		velocity.x = (self_pose.x - impulse_pos.x)#*knock_back_str
		velocity = velocity.normalized()*impulse_str
		velocity.y = impulse_str/10
	else:
		alarm0 = 0
		








