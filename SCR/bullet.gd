extends KinematicBody


var velocity = Vector3.ZERO
var time_from_birth = 0

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
		var move = Vector2(0,-1)
		move = move.normalized().rotated(-rotation.y)*10
		print(move)
		velocity = Vector3(move.x,0,move.y)
	
