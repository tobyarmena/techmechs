with(ctrl_grid)
	{
	mp_grid_clear_all(grid);
	
	mp_grid_add_instances(grid,par_unit,false)
	mp_grid_add_instances(grid,par_wall,false)
	mp_grid_add_instances(grid,par_ride,false)
	
	if current_unit != noone
		{
		if parent == par_unit
			{
			mp_grid_clear_cell(grid,current_unit.xpos,current_unit.ypos)
			}
		else if parent == par_ride
			{
			mp_grid_clear_cell(grid,current_unit.xpos,current_unit.ypos)
			mp_grid_clear_cell(grid,current_unit.xpos+1,current_unit.ypos)
			mp_grid_clear_cell(grid,current_unit.xpos,current_unit.ypos+1)
			mp_grid_clear_cell(grid,current_unit.xpos+1,current_unit.ypos+1)
			}
		}
	else if parent == par_ride
		{
		var inst = grid_occ[mouse_xxx,mouse_yyy]
		mp_grid_clear_cell(grid,inst.xpos,inst.ypos)
		mp_grid_clear_cell(grid,inst.xpos+1,inst.ypos)
		mp_grid_clear_cell(grid,inst.xpos,inst.ypos+1)
		mp_grid_clear_cell(grid,inst.xpos+1,inst.ypos+1)
		}
	else if parent == par_unit
		{
		var inst = grid_occ[mouse_xxx,mouse_yyy]
		mp_grid_clear_cell(grid,inst.xpos,inst.ypos)
		}

		
	
	
	}