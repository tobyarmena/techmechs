//adjust the sprite position to match the grid

sprite_set_offset(sprite_index,16,16)
x+=16
y+=16

//Set variables

path = path_add()
state = "ready"
move_range = 4

//get position in terms of grid
xpos = floor(x/ctrl_grid.grid_size) 
ypos = floor(y/ctrl_grid.grid_size)

//Update position on grid

ctrl_grid.grid_occ[xpos,ypos] = id