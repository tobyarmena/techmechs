

//displaye state
draw_text(x-10,y-24,state)

if state != "moving"
	{
	//draw hp bar
	var percent = hp/maxhp
	var length = 48
	var x1 = x-length/2
	var y1 = y+18
	var x2 = x1 + length
	var x2_hp = x1 + length*percent
	var y2 =  y+24


	draw_set_alpha(0.5)
	draw_set_color(c_green)
	draw_rectangle(x1,y1,max(x1,x2_hp),y2,false)
	if hp != maxhp
		{
		draw_set_color(c_red)
		draw_rectangle(max(x1,x2_hp),y1,x2,y2,false)
		}

	draw_set_alpha(1)

	draw_set_color(c_white)
	}
