/// @description Insert description here
// You can write your code in this editor

startx = x
starty = y



option[0,0] = "wait"
option[0,1] = scr_wait

//Check if attacking is an option
with(ctrl_grid)
	{
	for(xx = 0 ; xx < grid_width ; xx += 1)
		{
		for(yy = 0 ; yy < grid_height ; yy += 1)
			{
			if state == "unitchosen"
				{
				if ((abs(current_unit.xpos-xx) + abs(current_unit.ypos-yy)) <= current_unit.attack_range_max) 
					{
					if ((abs(current_unit.xpos-xx) + abs(current_unit.ypos-yy)) >= current_unit.attack_range_min) 
						{
						if grid_occ[xx,yy] != noone
							{
							if grid_occ[xx,yy].team != current_unit.team
								{
								with(other)
									{
									option[1,0] = "attack"
									option[1,1] = scr_attack
									}
								}
							}
						}
					}
				}
			}
		}
	}



draw_set_font(fnt_menu)




//find max width

box_width = 0
box_height = string_height(option[0,0])
for(i = 0 ; i < array_height_2d(option) ; i++)
	{
	var width = string_width(option[i,0])
	if width > box_width
		box_width = width
	}
