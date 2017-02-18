//Code for controlling selected unit

if state == "unitchosen"
	{
	if mouse_check_button_pressed(mb_left) 
		{
		//move selected unit
		
		if grid_mov[floor(mouse_x/grid_size),floor(mouse_y/grid_size)] == 1
			{
			scr_move(current_unit,floor(mouse_x/grid_size),floor(mouse_y/grid_size))
			
			//empty movable position grid
		
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					grid_mov[xx,yy] = 0
			}
		}
		
		
	//This is what happens when a path is completed
	
	with(current_unit)
		{
		if path_exists(path)
			if path_position == 1
				{
				state = "wait"
				other.state = "command"
				other.current_unit = noone
				
				}
		}
	}

//Code for selecting which unit to command

if state == "command"
	{
	
	//Select Unit
	
	if mouse_check_button_pressed(mb_left)
		{
		var mouse_xx = floor(mouse_x/grid_size)
		var mouse_yy = floor(mouse_y/grid_size)
		
		if grid_occ[mouse_xx,mouse_yy] != noone
			{
			if grid_occ[mouse_xx,mouse_yy].state == "ready"
				{
				current_unit = grid_occ[mouse_xx,mouse_yy]
				state = "unitchosen"
				
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
	}
	







/*
if mouse_check_button_pressed(mb_left)
	{
	scr_move(obj_unit_default,floor(mouse_x/grid_size),floor(mouse_y/grid_size))
	}