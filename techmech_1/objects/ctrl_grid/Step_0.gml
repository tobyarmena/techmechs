mp_grid_add_instances(grid, obj_path_wall, false);

//store mouses position in terms of the grid
mouse_xxx = max(0,floor(mouse_x/grid_size))
mouse_yyy = max(0,floor(mouse_y/grid_size))



//Code for controlling selected unit

if state == "unitchosen"
	{
	if mouse_check_button_pressed(mb_left) && current_unit.state == "ready"
		{
		
		//move selected unit
		
		if mouse_xxx == current_unit.xpos && mouse_yyy == current_unit.ypos
			{
			scr_update_map()
			
			scr_update_hit_grid()
			with(current_unit)
				{
				//empty movable position grid
				path_position = 0 
				state = "action"
				other.grid_updated = false
				other.action_complete = true
				}
			}
		else if grid_mov[mouse_xxx,mouse_yyy] == 1
			{
			current_unit.state = "moving"
			scr_move(current_unit,mouse_xxx,mouse_yyy)
			
			//empty movable position grid
		
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					{
					grid_mov[xx,yy] = 0
					grid_hit[xx,yy] = 0
					}
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
				scr_update_hit_grid()
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
			if grid_hit[mouse_xxx,mouse_yyy]
				{
				if grid_occ[mouse_xxx,mouse_yyy] != noone
					{
					var target = grid_occ[mouse_xxx,mouse_yyy]
					if target.team != current_unit.team
						{
						target.hp -= 10
						grid_occ[mouse_xxx,mouse_yyy].hp -= 10
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
	
//Code for controlling ride 

if state == "ridechosen"
	{
	if mouse_check_button_pressed(mb_left) && current_unit.state == "ready"
		{
		//do an action without moving
		if mouse_xxx == current_unit.xpos && mouse_yyy == current_unit.ypos
			{
			//empty movable position grid
			scr_update_map()
			
			scr_update_hit_grid()
			with(current_unit)
				{
				path_position = 0 
				state = "action"
				other.grid_updated = false
				other.action_complete = true
				}
			}
		//move ride
		else if grid_mov[mouse_xxx,mouse_yyy] == 1
			{
			current_unit.state = "moving"
			scr_move_ride(current_unit,mouse_xxx,mouse_yyy)
			
			//empty movable position grid
			for (xx = 0 ; xx <= grid_width ; xx++)
				for (yy = 0 ; yy <=  grid_height ; yy++)
					{
					grid_mov[xx,yy] = 0
					grid_hit[xx,yy] = 0
					}
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
				scr_update_hit_grid()
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
		
	//Attacking
	if current_unit.state = "attacking"
		{
		if mouse_check_button_pressed(mb_right)
			{
			current_unit.state = "action"
			}
		if mouse_check_button_pressed(mb_left)
			{
			
			if grid_hit[mouse_xxx,mouse_yyy] == 1
				{
				if grid_occ[mouse_xxx,mouse_yyy] != noone
					{
					var target = grid_occ[mouse_xxx,mouse_yyy]
					if target.team != current_unit.team
						{
						target.hp -= 10
						grid_occ[mouse_xxx,mouse_yyy].hp -= 10
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
		
	//Cancel move
	if mouse_check_button_pressed(mb_right)
		{
		if current_unit.state == "action" || current_unit.state == "ready" 
			{
			grid_occ[current_unit.xpos,current_unit.ypos] = noone
			grid_occ[current_unit.xpos+1,current_unit.ypos] = noone
			grid_occ[current_unit.xpos,current_unit.ypos+1] = noone
			grid_occ[current_unit.xpos+1,current_unit.ypos+1] = noone
			current_unit.x = temp_x
			current_unit.y = temp_y
			current_unit.xpos = floor(current_unit.x/grid_size)
			current_unit.ypos = floor(current_unit.y/grid_size)
			grid_occ[current_unit.xpos,current_unit.ypos] = current_unit.id
			grid_occ[current_unit.xpos+1,current_unit.ypos] = current_unit.id
			grid_occ[current_unit.xpos,current_unit.ypos+1] = current_unit.id
			grid_occ[current_unit.xpos+1,current_unit.ypos+1] = current_unit.id
			
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
	if keyboard_check_pressed(vk_space)
		{
		with(par_unit)
			state = "wait"
		with(par_ride)
			state = "wait"
		}
	
		
	if mouse_x >= 0 && mouse_y >= 0 && mouse_x < room_width && mouse_y < room_height //check if mouse is inside room
		{
		if grid_occ[mouse_xxx,mouse_yyy] != noone //check if there is an object of interest under the mouse
			{
			
			//prompt the grid to be updated again if mouse changes positions
			if inst_check != grid_occ[mouse_xxx,mouse_yyy]
				{
				inst_check = grid_occ[mouse_xxx,mouse_yyy]
				grid_updated = false
				}
			
			
			
			//Get the value of the parent
			parent = object_get_parent(grid_occ[mouse_xxx,mouse_yyy].object_index)
			
			//Update the grid to display movement of unit under the cursor
			if grid_updated = false && grid_occ[mouse_xxx,mouse_yyy].state == "ready" && parent == par_unit
				{
				grid_updated = true
				scr_update_map()
				
				with(grid_occ[mouse_xxx,mouse_yyy])
					{
					scr_grid_refresh()
					for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
						{
						for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
							{
							if mp_grid_path(other.grid,path,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
								{
								if path_get_length(path)/ctrl_grid.grid_size <= move_range
									{
									other.grid_mov[xx,yy] = 1
									//Set hittable positions
										for (xxx = xx-attack_range_max;xxx <= xx+attack_range_max;xxx++)
											for (yyy = yy-attack_range_max;yyy <= yy+attack_range_max;yyy++)
												{
												if abs(xxx-xx)+ abs(yyy-yy) <= attack_range_max
													if abs(xxx-xx)+ abs(yyy-yy) >= attack_range_min
														{
														other.grid_hit[xxx,yyy] = 1
														}
												}
									}
								}
							}
						}
					}
				}
			//Update the grid to display movement of ride under the cursor
			else if grid_updated = false && grid_occ[mouse_xxx,mouse_yyy].state == "ready" && parent == par_ride
				{
				
				grid_updated = true
				//Set movable positions for unit
				scr_update_map()	
				with(grid_occ[mouse_xxx,mouse_yyy])
					{
					scr_grid_refresh()
					for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
						for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
							{
							with(par_wall)
								{
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size)-1)
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size),floor(y/ctrl_grid.grid_size)-1)
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size))
								}
							with(par_unit)
								{
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size)-1)
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size),floor(y/ctrl_grid.grid_size)-1)
								mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size))
								}
							//top left position
							if mp_grid_path(other.grid,path1,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
								{
								scr_grid_refresh()
								if path_get_length(path1)/ctrl_grid.grid_size <= move_range
								//top right position
								if mp_grid_path(other.grid,path2,x+other.grid_size,y,(xx+1)*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
									{
									if path_get_length(path2)/ctrl_grid.grid_size <= move_range
									//bottom left position
									if mp_grid_path(other.grid,path3,x,y+other.grid_size,(xx)*other.grid_size+other.grid_size/2,(yy+1)*other.grid_size+other.grid_size/2,false)
										{
										if path_get_length(path3)/ctrl_grid.grid_size <= move_range
										//bottom right position
										if mp_grid_path(other.grid,path4,x+other.grid_size,y+other.grid_size,(xx+1)*other.grid_size+other.grid_size/2,(yy+1)*other.grid_size+other.grid_size/2,false)
											{
											if path_get_length(path4)/ctrl_grid.grid_size <= move_range
												{
												other.grid_mov[xx,yy] = 1
												
												//Set hittable positions
													for (xp = xx; xp <= xx+1;xp++)
														for (yp = yy; yp <= yy+1;yp++)
															for (xxx = xp-attack_range_max;xxx <= xp+attack_range_max;xxx++)
																for (yyy = yp-attack_range_max;yyy <= yp+attack_range_max;yyy++)
																	{
																	if abs(xxx-xp)+ abs(yyy-yp) <= attack_range_max
																		if abs(xxx-xp)+ abs(yyy-yp) >= attack_range_min
																			{
																			other.grid_hit[xxx,yyy] = 1
																			}
																	}
												}
											}
										}
									}
								}
								scr_grid_refresh()
							}
					}
				
				}
		
			if mouse_check_button_pressed(mb_left)
				{
				
				
				//What happens when you press a unit
				if grid_occ[mouse_xxx,mouse_yyy].state == "ready" && parent == par_unit
					{
					//update current unit and switch game state
					current_unit = grid_occ[mouse_xxx,mouse_yyy]
					state = "unitchosen"
					
					//store position incase player cancels move
					temp_x = current_unit.x
					temp_y = current_unit.y
					
					//Set movable and hittable positions positions for unit
					scr_update_map()
					with(current_unit)
						{
						scr_grid_refresh()
						for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
							for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
								{
						
								if mp_grid_path(other.grid,path,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
									{
									if path_get_length(path)/ctrl_grid.grid_size <= move_range
										{
										other.grid_mov[xx,yy] = 1
										
										//Set hittable positions
										for (xxx = xx-attack_range_max;xxx <= xx+attack_range_max;xxx++)
											for (yyy = yy-attack_range_max;yyy <= yy+attack_range_max;yyy++)
												{
												if abs(xxx-xx)+ abs(yyy-yy) <= attack_range_max
													if abs(xxx-xx)+ abs(yyy-yy) >= attack_range_min
														{
														other.grid_hit[xxx,yyy] = 1
														}
												}
										
										
										}
									}
								}
						}
					
					
					}
				//what happens when you press a ride
				else if grid_occ[mouse_xxx,mouse_yyy].state == "ready" && parent == par_ride
					{
					
					
					
					//update current unit and switch game state
					current_unit = grid_occ[mouse_xxx,mouse_yyy]
					state = "ridechosen"
					
					//store position incase player cancels move
					temp_x = current_unit.x
					temp_y = current_unit.y
					
					//Set movable positions for unit
					scr_update_map()
					with(current_unit)
						{
						scr_grid_refresh()
						for (xx = xpos - move_range;xx <= xpos + move_range;xx++)
							for (yy = ypos - move_range;yy <= ypos + move_range;yy++)
								{
								with(par_wall)
									{
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size)-1)
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size),floor(y/ctrl_grid.grid_size)-1)
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size))
									}
								with(par_unit)
									{
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size)-1)
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size),floor(y/ctrl_grid.grid_size)-1)
									mp_grid_add_cell(ctrl_grid.grid,floor(x/ctrl_grid.grid_size)-1,floor(y/ctrl_grid.grid_size))
									}
								//top left position
								if mp_grid_path(other.grid,path1,x,y,xx*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
									{
									scr_grid_refresh()
									if path_get_length(path1)/ctrl_grid.grid_size <= move_range
									//top right position
									if mp_grid_path(other.grid,path2,x+other.grid_size,y,(xx+1)*other.grid_size+other.grid_size/2,yy*other.grid_size+other.grid_size/2,false)
										{
										if path_get_length(path2)/ctrl_grid.grid_size <= move_range
										//bottom left position
										if mp_grid_path(other.grid,path3,x,y+other.grid_size,(xx)*other.grid_size+other.grid_size/2,(yy+1)*other.grid_size+other.grid_size/2,false)
											{
											if path_get_length(path3)/ctrl_grid.grid_size <= move_range
											//bottom right position
											if mp_grid_path(other.grid,path4,x+other.grid_size,y+other.grid_size,(xx+1)*other.grid_size+other.grid_size/2,(yy+1)*other.grid_size+other.grid_size/2,false)
												{
												if path_get_length(path4)/ctrl_grid.grid_size <= move_range
													{
													other.grid_mov[xx,yy] = 1
													
													//Set hittable positions
													for (xp = xx; xp <= xx+1;xp++)
														for (yp = yy; yp <= yy+1;yp++)
															for (xxx = xp-attack_range_max;xxx <= xp+attack_range_max;xxx++)
																for (yyy = yp-attack_range_max;yyy <= yp+attack_range_max;yyy++)
																	{
																	if abs(xxx-xp)+ abs(yyy-yp) <= attack_range_max
																		if abs(xxx-xp)+ abs(yyy-yp) >= attack_range_min
																			{
																			other.grid_hit[xxx,yyy] = 1
																			}
																	}
													}
												}
											}
										}
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
					{
					grid_mov[xx,yy] = 0
					grid_hit[xx,yy] = 0
					}
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
			if wait_count == ds_list_size(team2)
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