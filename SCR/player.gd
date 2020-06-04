extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cam = $gimble
var velocity = Vector3.ZERO
const UP = Vector3(0,-1,0)
const SPEED = 10
const JUMP_HEIGHT = 100
const EXEL = 0.2
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.window_fullscreen = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= 0.98
	var quit = Input.is_key_pressed(KEY_Q)
	var left = Input.is_key_pressed(KEY_A)
	var right = Input.is_key_pressed(KEY_D)
	var forward = Input.is_key_pressed(KEY_W)
	var backward = Input.is_key_pressed(KEY_S)
	var jump = Input.is_key_pressed(KEY_SPACE) 
	#move stuff
	var move_h = (int(right)-int(left))
	var move_v = (int(backward)-int(forward))
	var move = Vector2(move_h,move_v)
	move = move.normalized().rotated(-rotation.y)*SPEED
	velocity.x = lerp(velocity.x,move.x,EXEL)
	velocity.z = lerp(velocity.z,move.y,EXEL)
	velocity.y += int(jump)*int(is_on_floor())*JUMP_HEIGHT
	velocity = move_and_slide(velocity, UP)
	#options
	if(quit):
		get_tree().quit()
	
func _unhandled_input(event):
	if(event is InputEventMouseMotion):
		rotation.y -= deg2rad(event.relative.x)*0.1
		cam.rotation.x -= deg2rad(event.relative.y)*0.1
		cam.rotation.x = clamp(cam.rotation.x,-1.57,1.57)

