draw_set_alpha(0)
mp_grid_draw(grid)
draw_set_alpha(1)



//Draw the grid

for(xx = 0 ; xx < grid_width ; xx += 1)
	{
	for(yy = 0 ; yy < grid_height ; yy += 1)
		{
		
		if grid_mov[xx,yy] == 1
			{
			if state == "command"
				draw_set_alpha(0.15)
			else if state == "unitchosen" || state == "ridechosen"
				draw_set_alpha(0.3)
			draw_sprite(spr_available_position,0,xx*grid_size,yy*grid_size)
			if state == "ridechosen" || (state == "command" && parent == par_ride)
				{
				if grid_mov[xx+1,yy] == 0 && grid_mov[xx+1,max(0,yy-1)] == 0
					draw_sprite(spr_available_position,0,(xx+1)*grid_size,yy*grid_size)
				if grid_mov[xx,yy+1] == 0 
					draw_sprite(spr_available_position,0,(xx)*grid_size,(yy+1)*grid_size)
				if grid_mov[xx+1,yy+1] == 0 && grid_mov[xx+1,yy] == 0 && grid_mov[xx,yy+1] == 0
					draw_sprite(spr_available_position,0,(xx+1)*grid_size,(yy+1)*grid_size)
				}
				
			}
		//Draw hittable positions
		else if grid_hit[xx,yy] == 1
			{
			if state == "command"
				draw_set_alpha(0.15)
			else if state == "unitchosen" || state == "ridechosen"
				draw_set_alpha(0.3)
			if state == "command"
				{
				if parent == par_unit
					draw_sprite(spr_attackable_position,0,xx*grid_size,yy*grid_size)
				else if parent == par_ride
					if grid_mov[xx-1,yy-1] != 1
						if grid_mov[xx-1,yy] != 1
							if grid_mov[xx,yy-1] != 1
								draw_sprite(spr_attackable_position,0,xx*grid_size,yy*grid_size)
				}
			else if state == "unitchosen" 
				{
				if current_unit.state == "ready" || current_unit.state == "attacking"
					draw_sprite(spr_attackable_position,0,xx*grid_size,yy*grid_size)
				}
			else if state == "ridechosen"
				{
				if current_unit.state == "ready" || current_unit.state == "attacking"
					{
					if grid_mov[xx-1,yy-1] != 1
						if grid_mov[xx-1,yy] != 1
							if grid_mov[xx,yy-1] != 1
								draw_sprite(spr_attackable_position,0,xx*grid_size,yy*grid_size)
					}
				}
			}
			
		
		//DEBUG GRID
		draw_set_alpha(0.3)
		draw_sprite(spr_grid,0,xx*grid_size,yy*grid_size)
		draw_set_font(fnt_debug)
		draw_text(xx*grid_size,yy*grid_size,string(grid_hit[xx,yy]))
		draw_text(xx*grid_size,yy*grid_size+6,string(grid_mov[xx,yy]))
		draw_set_font(fnt_menu)
		draw_text(0,0,state)
		draw_set_alpha(1)
		
		
		}
	}
	
draw_text(0,128,"team: " + string(team))
draw_text(0,144,"turn count: " + string(turn_count))
	
if state == "command"
	{
	//draw_text(mouse_x,mouse_y,object_get_name(parent))
	}

//Show which unit is selected

if current_unit != noone
	{
	if state == "unitchosen"
		{
		if current_unit.state != "moving"
			{		
			draw_sprite(spr_unit_selector,-1,current_unit.x,current_unit.y)
			}
		}
	else if state = "ridechosen"
		{
		if current_unit.state != "moving"
			{		
			draw_sprite(spr_select_2x2,-1,current_unit.x+16,current_unit.y+16)
			}
		}
	}
	
//draw path
if state == "unitchosen"
	{
	if current_unit.state == "ready"
		{
		var mouse_xx = floor(mouse_x/grid_size)
		var mouse_yy = floor(mouse_y/grid_size)
		if grid_mov[mouse_xx,mouse_yy]  
			{
			if mouse_xx_check!= mouse_xx || mouse_yy_check != mouse_yy	
				{
				mouse_xx_check = mouse_xx
				mouse_yy_check = mouse_yy
				show_path = path_add()
				mp_grid_path(grid,show_path,current_unit.x,current_unit.y,mouse_xx*grid_size + grid_size/2,mouse_yy*grid_size + grid_size/2,false)
				}
			if path_exists(show_path)
				{
				var node_amount = path_get_length(show_path)/8
				for (i=0;i<path_get_number(show_path)-1;i++)
					{
					var xx = path_get_point_x(show_path,i)
					var yy = path_get_point_y(show_path,i)
					var xxnext = path_get_point_x(show_path,i+1)
					var yynext = path_get_point_y(show_path,i+1)
					var color = make_colour_rgb(0, 113, 188);
					if i == path_get_number(show_path)-2
						{
						var dir = point_direction(xx,yy,xxnext,yynext)
						draw_sprite_ext(spr_show_path,0,xxnext,yynext,1,1,dir,c_white,0.5)
						}
					draw_set_alpha(0.5)
					draw_line_width_color(xx,yy,xxnext,yynext,8,color,color)
					draw_set_alpha(1)
					}
				}
			}
		}
	}
else if state == "ridechosen"
	{
	if current_unit.state == "ready"
		{

		var mouse_xx = floor(mouse_x/grid_size)
		var mouse_yy = floor(mouse_y/grid_size)
		
		//draw square
		draw_sprite(spr_select_2x2,0,(mouse_xxx+1)*grid_size,(mouse_yyy+1)*grid_size)
		
		
		if grid_mov[mouse_xx,mouse_yy]  
			{
			if mouse_xx_check!= mouse_xx || mouse_yy_check != mouse_yy	
				{
				mouse_xx_check = mouse_xx
				mouse_yy_check = mouse_yy
				show_path = path_add()
				with(current_unit)
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
					//top left path
					if mp_grid_path(ctrl_grid.grid, 
									path1, 
									x, 
									y, 
									other.mouse_xxx*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									other.mouse_yyy*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									false)
					{
					scr_grid_refresh()
					//top right path
					if mp_grid_path(ctrl_grid.grid, 
									path2, 
									x+ctrl_grid.grid_size, 
									y, 
									other.mouse_xxx*ctrl_grid.grid_size+ctrl_grid.grid_size/2+ctrl_grid.grid_size, 
									other.mouse_yyy*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									false)
					//bottom left path
					if mp_grid_path(ctrl_grid.grid, 
									path3, 
									x, 
									y+ctrl_grid.grid_size, 
									other.mouse_xxx*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									other.mouse_yyy*ctrl_grid.grid_size+ctrl_grid.grid_size/2+ctrl_grid.grid_size, 
									false)
					//bottom right path
					if mp_grid_path(ctrl_grid.grid, 
									path4, 
									x+ctrl_grid.grid_size, 
									y+ctrl_grid.grid_size, 
									other.mouse_xxx*ctrl_grid.grid_size+ctrl_grid.grid_size/2+ctrl_grid.grid_size, 
									other.mouse_yyy*ctrl_grid.grid_size+ctrl_grid.grid_size/2+ctrl_grid.grid_size, 
									false)
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
						//top left path
						mp_grid_path(ctrl_grid.grid, 
									other.show_path, 
									x, 
									y, 
									other.mouse_xxx*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									other.mouse_yyy*ctrl_grid.grid_size+ctrl_grid.grid_size/2, 
									false)
						scr_grid_refresh()
						}
					}
				}
				}
			if path_exists(show_path)
				{
				var node_amount = path_get_length(show_path)/8
				for (i=0;i<path_get_number(show_path)-1;i++)
					{
					var xx = path_get_point_x(show_path,i)
					var yy = path_get_point_y(show_path,i)
					var xxnext = path_get_point_x(show_path,i+1)
					var yynext = path_get_point_y(show_path,i+1)
					var color = make_colour_rgb(0, 113, 188);
					if i == path_get_number(show_path)-2
						{
						var dir = point_direction(xx,yy,xxnext,yynext)
						draw_sprite_ext(spr_show_path,0,xxnext+grid_size/2,yynext+grid_size/2,1,1,dir,c_white,0.5)
						}
					draw_set_alpha(0.5)
					draw_line_width_color(xx+grid_size/2,yy+grid_size/2,xxnext+grid_size/2,yynext+grid_size/2,8,color,color)
					draw_set_alpha(1)
					}
				}
			}
		}
	}
	



