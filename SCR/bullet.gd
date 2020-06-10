extends KinematicBody


var velocity = Vector3.ZERO
var time_from_birth = 0
var life_span = 100
var speed = 10

enum bullet_types{
	straight
}
var types_lists = [""]
var type

func _ready():
	#print("hello im here")
	types_lists[bullet_types.straight] = "scr_straight"
	
func _process(delta):
	#func call
	call(types_lists[type])
	time_from_birth += 1
	#keep the "time from birth" below call
	
	move_and_slide(velocity)
func scr_straight():
	if(time_from_birth < 1):
		var move = Vector3(0,0,-1)
		#move = move.normalized().
		#print(move)
		#velocity = Vector3(move.x,move.y,move.z)
		velocity = -get_transform().basis.z*speed
	elif(time_from_birth >= life_span):
		queue_free()
