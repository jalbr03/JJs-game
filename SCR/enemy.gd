extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_parent().get_parent().get_node("player")
var knock_back = 0
var velocity = Vector3.ZERO
const UP = Vector3(0,-1,0)
const SPEED = 5
const JUMP_HEIGHT = 100
const EXEL = 0.2
var fps = 0
var alarm0 = -1
export var seeing_range = 20

var move_h = 0#(int(right)-int(left))
var move_v = 1#(int(backward)-int(forward))
var move = Vector2(move_h,move_v)

enum enemy_states{
	idle,
	roam,
	fight,
	hide,
	knock_back
}
var states_array = ["","","","",""]
var state = enemy_states.roam

# Called when the node enters the scene tree for the first time.
func _ready(): 
	states_array[enemy_states.idle] = "scr_idle"
	states_array[enemy_states.roam] = "scr_roam"
	states_array[enemy_states.fight] = "scr_fight"
	states_array[enemy_states.hide] = "scr_hide"
	states_array[enemy_states.knock_back] = "knock_back"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps = 30#Engine.get_frames_per_second();
	velocity.y -= 0.98
	call(states_array[state])
	#print(state)
	#knock back
	if(knock_back != 0):
		state = enemy_states.knock_back
	else:
		#see the player
		var a = self.get_transform().basis.z # Enemy's forward vector
		var b = (player.get_translation() - self.get_translation()).normalized() # Vector from enemy to player
		var dist = translation.distance_to(player.translation)
		if acos(a.dot(b))-rad2deg(180) <= deg2rad(60) && dist < seeing_range: # If the angle is less than or equal to 60 degrees
			state = enemy_states.fight
	
	
	
	
	#move stuff
	move = -Vector2(move_h,move_v)
	move = move.normalized().rotated(-rotation.y)*SPEED
	velocity.x = lerp(velocity.x,move.x,EXEL)
	velocity.z = lerp(velocity.z,move.y,EXEL)
	velocity = move_and_slide(velocity, UP)

#scripts----------------
func scr_idle():
	move_h = 0
	move_v = 0
	#print("alarm"+str(alarm0))
	#alarm stuff
	#alarm0-=1
	if(alarm0 == -1): #start of alarm
		alarm0 = fps*rand_range(2,4)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		#print("go back")
		state = enemy_states.roam
	else:
		alarm0-=1
	#end of alarm stuff
	

func scr_roam():
	#alarm stuff
	if(alarm0 == -1): #start of alarm
		alarm0 = fps*rand_range(3,5)
		var rand_dir = rand_range(0,359)
		rotate_y(rand_dir)
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		state = enemy_states.idle
	else:
		alarm0-=1
	#end of alarm stuff
	
	move_v = 1 #forward
	

func scr_fight():
	var player_pose = player.global_transform.origin
	player_pose.y = translation.y
	look_at(player_pose,Vector3.UP)
	move_v = 1
	
	var dist = translation.distance_to(player.translation)
	if dist > seeing_range: 
		state = enemy_states.idle
		alarm0 = -1
	

func scr_hide():
	pass

func knock_back():
	var player_pose = player.global_transform.origin
	move_v = knock_back/(translation.x - player_pose.x)
	move_h = knock_back/(translation.z - player_pose.z)
	
	


















