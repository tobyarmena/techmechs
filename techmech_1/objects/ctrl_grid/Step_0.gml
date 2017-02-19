//Code for controlling selected unit

if state == "unitchosen"
	{
	if mouse_check_button_pressed(mb_left) && current_unit.state == "ready"
		{
		
		//move selected unit
		
		if floor(mouse_x/grid_size) == current_unit.xpos && floor(mouse_y/grid_size) == current_unit.ypos
			{
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					grid_mov[xx,yy] = 0
			with(current_unit)
				{
				//empty movable position grid
		
				
				path_position = 0 
				state = "action"
				other.grid_updated = false
				other.action_complete = true
				}
			}
		else if grid_mov[floor(mouse_x/grid_size),floor(mouse_y/grid_size)] == 1
			{
			current_unit.state = "moving"
			scr_move(current_unit,floor(mouse_x/grid_size),floor(mouse_y/grid_size))
			
			//empty movable position grid
		
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					grid_mov[xx,yy] = 0
			}
		}
		
		
	//This is what happens when unit is done moving
	
	with(current_unit)
		{
		if path_exists(path)
			if path_position == 1
				{
				path_position = 0 
				state = "action"
				other.grid_updated = false
				other.action_complete = true
				}
		}
		
	//choose an action to perform after movement
	
	if current_unit.state == "action"
		{
		if !instance_exists(obj_action_menu)
			{
			instance_create_layer(current_unit.x-64,current_unit.y-16,"Instances",obj_action_menu)
			
			}
		}
		
	//Attack
	
	if current_unit.state == "attacking"
		{
		if mouse_check_button_pressed(mb_right)
			{
			current_unit.state = "action"
			}
		if mouse_check_button_pressed(mb_left)
			{
			var mouse_xx = floor(mouse_x/grid_size)
			var mouse_yy = floor(mouse_y/grid_size)
			if ((abs(current_unit.xpos-mouse_xx) + abs(current_unit.ypos-mouse_yy)) <= current_unit.attack_range_max) 
				{
				if ((abs(current_unit.xpos-mouse_xx) + abs(current_unit.ypos-mouse_yy)) >= current_unit.attack_range_min) 
					{
					if grid_occ[mouse_xx,mouse_yy] != noone
						{
						if grid_occ[mouse_xx,mouse_yy].team != current_unit.team
							{
							grid_occ[mouse_xx,mouse_yy].hp -= 10
							current_unit.state = "wait"
							state = "command"
							current_unit = noone
							grid_updated = false
							action_complete = true
							exit;
							}
						}
					}
				}
			}
		}
		
	//Cancel move
	if mouse_check_button_pressed(mb_right)
		{
		if current_unit.state == "action" || current_unit.state == "ready" 
			{
			grid_occ[current_unit.xpos,current_unit.ypos] = noone
			current_unit.x = temp_x
			current_unit.y = temp_y
			current_unit.xpos = floor(current_unit.x/grid_size)
			current_unit.ypos = floor(current_unit.y/grid_size)
			grid_occ[current_unit.xpos,current_unit.ypos] = current_unit.id
			
			state = "command"
			current_unit.state = "ready"
			current_unit.path_position = 0
			current_unit = noone
			
			grid_updated = false
			action_complete = true
			
			
			
			exit;
			}
		
		}
	
	}

//Code for selecting which unit to command

if state == "command"
	{
	
	//Select Unit
	
	var mouse_xx = floor(mouse_x/grid_size)
	var mouse_yy = floor(mouse_y/grid_size)
		
	if mouse_x >= 0 && mouse_y >= 0 && mouse_x < room_width && mouse_y < room_height
		{
		if grid_occ[mouse_xx,mouse_yy] != noone
			{
			
			//Update the grid to display movement of unit under the cursor
			
			if grid_updated = false && grid_occ[mouse_xx,mouse_yy].state == "ready"
				{
				grid_updated = true
			
				scr_update_map()
				
				with(grid_occ[mouse_xx,mouse_yy])
					{
					mp_grid_clear_cell(ctrl_grid.grid,xpos,ypos)
					for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
						{
						for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
							{
							if mp_grid_path(other.grid,path,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
								{
								if path_get_length(path)/ctrl_grid.grid_size <= move_range
									other.grid_mov[xx,yy] = 1
								}
							}
						}
					}
				}
		
			if mouse_check_button_pressed(mb_left)
				{
				if grid_occ[mouse_xx,mouse_yy].state == "ready"
					{
					current_unit = grid_occ[mouse_xx,mouse_yy]
					state = "unitchosen"
					
					//store position incase player cancels move
					
					temp_x = current_unit.x
					temp_y = current_unit.y
					
					//Set movable positions
				
					scr_update_map()
				
				
					with(current_unit)
						{
						mp_grid_clear_cell(ctrl_grid.grid,xpos,ypos)
						for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
							for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
								{
						
								if mp_grid_path(other.grid,path,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
									{
									if path_get_length(path)/ctrl_grid.grid_size <= move_range
										other.grid_mov[xx,yy] = 1
									}
								}
						}
				
				
					}
				}
			}
		else
			{
			grid_updated = false
			
			//empty movable position grid
		
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					grid_mov[xx,yy] = 0
			}
		}
	
	}
	
///Check if a turn has ended

if action_complete == true
	{
	action_complete = false
	wait_count = 0
	if team == 1
		{
		for (i = 0; i < ds_list_size(team1); i++)
			{
			if ds_list_find_value(team1,i).state == "wait"
				{
				wait_count ++
				}
			if wait_count == ds_list_size(team1)
				phase_begin = true
			}
		}
	else if team == 2
		{
		for (i = 0; i < ds_list_size(team2); i++)
			{
			if ds_list_find_value(team2,i).state == "wait"
				{
				wait_count ++
				}
			if wait_count == ds_list_size(team1)
				phase_begin = true
			}
		}
	}
	
	
///Control turn phasing

if phase_begin == true
	{
	phase_begin = false
	
	wait_count = 0
	
	//increase turn count
	if team == 2
		turn_count ++
	
	//switch teams
	if team == 1
		team = 2
	else if team == 2
		team = 1
		
	//reactivate players
	if team == 1
		{
		for (i = 0; i < ds_list_size(team1); i++)
			{
			with(ds_list_find_value(team1,i))
				{
				state = "ready"
				}
			}
		}
	else if team == 2
		{
		for (i = 0; i < ds_list_size(team2); i++)
			{
			with(ds_list_find_value(team2,i))
				{
				state = "ready"
				}
			}
		}
	}
	
	
if keyboard_check(vk_escape)
	game_end()










/*
if mouse_check_button_pressed(mb_left)
	{
	scr_move(obj_unit_default,floor(mouse_x/grid_size),floor(mouse_y/grid_size))
	}