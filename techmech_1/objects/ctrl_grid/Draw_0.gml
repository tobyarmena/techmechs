//Draw the grid

for(xx = 0 ; xx < grid_width ; xx += 1)
	{
	for(yy = 0 ; yy < grid_height ; yy += 1)
		{
		draw_set_alpha(0.3)
		if grid_mov[xx,yy] == 1
			draw_sprite(spr_available_position,0,xx*grid_size,yy*grid_size)
		draw_sprite(spr_grid,0,xx*grid_size,yy*grid_size)
		//draw_text(xx*grid_size,yy*grid_size,string(grid_mov[xx,yy]))
		draw_text(0,0,state)
		draw_set_alpha(1)
		
		}
	}
	


if current_unit != noone
	{
	if current_unit.state != "moving"
		{
		
		//Show which unit is selected
		
		draw_sprite(spr_unit_selector,-1,current_unit.x,current_unit.y)
		
		
		}
	}
	



