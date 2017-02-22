if !ds_list_empty(list_actions){

	if curr_action == noone{
		curr_action = ds_list_find_value(list_actions,0);
		action_finished = false;
	}
}