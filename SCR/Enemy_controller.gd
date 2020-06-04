extends Node

var player
func _on_player_knock_back(strength,knock_back_dist):
	var num_of_children = get_child_count();
	
	for i in range(0,num_of_children):
		var current_child = get_child(i)
		var dist = current_child.translation.distance_to(player.translation)
		if(dist < knock_back_dist):
			current_child.knock_back_str = strength

func _on_player_self_id(player_id):
	var num_of_children = get_child_count();
	player = player_id
	for i in range(0,num_of_children):
		var current_child = get_child(i)
		current_child.player = player_id
