extends Node

var player

func _on_player_self_id(player_id):
	var num_of_children = get_child_count();
	player = player_id
	for i in range(0,num_of_children):
		var current_child = get_child(i)
		current_child.player = player_id

func _on_player_impulse(strength,impulse_dist,impulse_time,from_node_id):
	var num_of_children = get_child_count();
	#print("impulse--------------------------------")
	for i in range(0,num_of_children):
		var current_child = get_child(i)
		var dist = current_child.translation.distance_to(from_node_id.translation)
		current_child.impulse_str = strength
		current_child.impulse_id = from_node_id
		current_child.impulse_time = impulse_time
		current_child.impulse_dist = impulse_dist


#func _on_player_pull(id,strength,life_span):
#	var num_of_children = get_child_count();
#
#	for i in range(0,num_of_children):
#		var current_child = get_child(i)
#		var dist = current_child.translation.distance_to(id.translation)
#		if(dist < strength):
#			current_child.impulse_str = -strength
#			current_child.impulse_id = id
