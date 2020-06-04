extends Node


func _on_player_knock_back(strength):
	var num_of_children = get_child_count();
	
	for i in range(0,num_of_children):
		var current_child = get_child(i)
		current_child.knock_back_str = strength
