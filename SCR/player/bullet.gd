extends KinematicBody

var velocity = Vector3.ZERO
var time_from_birth = 0
var life_span = 100
var alarm0 = -1
var global_delta
var speed = 10

enum bullet_types{
	black_hole
}
var types_lists = [""]
var type

func _ready():
	types_lists[bullet_types.black_hole] = "scr_black_hole"
	

func _process(delta):
	global_delta = delta
	#func call
	call(types_lists[type])
	#time_from_birth += 1
	#keep the "time from birth" below call
	
	move_and_slide(velocity)
	
func scr_black_hole():
	if(alarm0 == -1): #start of alarm
		alarm0 = life_span-1
		var move = Vector3(0,0,-1)
		velocity = -get_transform().basis.z*speed
	elif(alarm0 <= 0): #end of alarm
		alarm0 = -1
		queue_free() #destroy
	else:
		alarm0-=1*global_delta
	#end of alarm stuff
	

