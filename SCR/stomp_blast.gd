extends MeshInstance

var splash_size
var decel_spd = 0.3
var grow_spd = 5
func _process(delta):
	if(scale < splash_size):
		scale += Vector3(grow_spd,0.5,grow_spd)
		grow_spd -= decel_spd
	else:
		queue_free()
	
