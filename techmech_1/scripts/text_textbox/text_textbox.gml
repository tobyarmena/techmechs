var str = argument2;
var posx = argument0;
var posy = argument1;

if abs(initTime - current_time) > sectomil(0.05) and string_length(drawn_str) != string_length(str){
	drawn_str += string_char_at(str,counter);
	initTime = current_time;
	counter ++;
}
if string_length(drawn_str) == string_length(str){
	text_finished = true;
}
else if string_length(drawn_str) != string_length(str){
	text_finished = false;
}

draw_set_font(fnt_menu)
draw_text(posx,posy,drawn_str);
