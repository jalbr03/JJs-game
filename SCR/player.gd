extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal knock_back
onready var cam = $gimble
var velocity = Vector3.ZERO
var move_h
var move_v
const UP = Vector3(0,-1,0)
const SPEED = 10
const JUMP_HEIGHT = 100
const EXEL = 0.2

enum player_states{
	move,
	stomp
}
var states_array = ["",""]
var state = player_states.move
# Called when the node enters the scene tree for the first time.
func _ready():
	states_array[player_states.move] = "move"
	states_array[player_states.stomp] = "stomp"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.window_fullscreen = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= 0.98
	var quit = Input.is_key_pressed(KEY_ESCAPE)
	call(states_array[state])
	velocity = move_and_slide(velocity, UP)
	#options
	if(quit):
		get_tree().quit()
	
func _unhandled_input(event):
	if(event is InputEventMouseMotion):
		rotation.y -= deg2rad(event.relative.x)*0.1
		cam.rotation.x -= deg2rad(event.relative.y)*0.1
		cam.rotation.x = clamp(cam.rotation.x,-1.57,1.57)

func move():
	var left = Input.is_key_pressed(KEY_A)
	var right = Input.is_key_pressed(KEY_D)
	var forward = Input.is_key_pressed(KEY_W)
	var backward = Input.is_key_pressed(KEY_S)
	var jump = Input.is_key_pressed(KEY_SPACE)
	var stomp = Input.is_key_pressed(KEY_Q)
	#move stuff
	var move_h = (int(right)-int(left))
	var move_v = (int(backward)-int(forward))
	var move = Vector2(move_h,move_v)
	move = move.normalized().rotated(-rotation.y)*SPEED
	velocity.x = lerp(velocity.x,move.x,EXEL)
	velocity.z = lerp(velocity.z,move.y,EXEL)
	velocity.y += int(jump)*int(is_on_floor())*JUMP_HEIGHT
	#attack stuff
	if(stomp):
		state = player_states.stomp
		velocity = Vector3.ZERO
func stomp():
	emit_signal("knock_back",10)
	pass


func _on_player_knock_back():
	pass # Replace with function body.
