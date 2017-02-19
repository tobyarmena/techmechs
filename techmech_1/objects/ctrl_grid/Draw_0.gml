//Draw the grid

for(xx = 0 ; xx < grid_width ; xx += 1)
	{
	for(yy = 0 ; yy < grid_height ; yy += 1)
		{
		
		if grid_mov[xx,yy] == 1
			{
			if state == "command"
				draw_set_alpha(0.15)
			else if state == "unitchosen"
				draw_set_alpha(0.3)
			draw_sprite(spr_available_position,0,xx*grid_size,yy*grid_size)
			}
		draw_set_alpha(0.3)
		draw_sprite(spr_grid,0,xx*grid_size,yy*grid_size)
		//draw_text(xx*grid_size,yy*grid_size,string(grid_mov[xx,yy]))
		draw_text(0,0,state)
		draw_set_alpha(1)
		
		if state == "unitchosen"
			{
			if current_unit.state == "attacking"
				{
				if ((abs(current_unit.xpos-xx) + abs(current_unit.ypos-yy)) <= current_unit.attack_range_max) 
					{
					if ((abs(current_unit.xpos-xx) + abs(current_unit.ypos-yy)) >= current_unit.attack_range_min) 
						{
						draw_set_alpha(0.3)
						draw_sprite(spr_attackable_position,0,xx*grid_size,yy*grid_size)
						draw_set_alpha(1)
						
						}
					}
				}
			}
		
		}
	}
	
draw_text(0,128,"team: " + string(team))
draw_text(0,144,"turn count: " + string(turn_count))
	

//Show which unit is selected

if current_unit != noone
	{
	if current_unit.state != "moving"
		{		
		draw_sprite(spr_unit_selector,-1,current_unit.x,current_unit.y)
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
	



