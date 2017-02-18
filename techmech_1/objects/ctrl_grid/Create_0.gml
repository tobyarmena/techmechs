
//initialize grid

grid_size = 32
grid_width = room_width/grid_size
grid_height = room_height/grid_size


//initialize grids

grid = mp_grid_create(0, 0, grid_width, grid_height, grid_size, grid_size);

for (xx = 0; xx < grid_width;xx+=1)
	{
	for (yy = 0; yy < grid_width;yy+=1)
		{
		grid_occ[xx,yy] = noone
		grid_ter[xx,yy] = ""
		grid_mov[xx,yy] = 0
		}
	}
	
//Initialize states
state = "command"

//Initialize variables

current_unit = noone




