if !ds_list_empty(list_strs){
	textbox = true;
	
	
	// Set tar_str to first element in list
	if tar_str == ""{
		tar_str = ds_list_find_value(list_strs,0);
	}
	
	if sprite_data == noone{
		sprite_data = ds_list_find_value(list_sprite,0)
		spr_left = sprite_data[0];
		name_left = sprite_data[2];
		spr_right = sprite_data[1];
		name_right = sprite_data[3];
	}
	
	//Next element in str
	if text_finished and keyboard_check_pressed(vk_enter){
		ds_list_delete(list_strs,0);
		ds_list_delete(list_sprite,0);
		clear_textbox()
	}
	
	//Skip text
	if !text_finished and keyboard_check_pressed(vk_enter){
		drawn_str = tar_str;
	}
}
else{
	textbox = false;
}
