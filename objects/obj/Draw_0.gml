// Draw notes.
//draw_set_color(staff[| i].played ? c_green : c_blue);
draw_set_color(c_blue);
for (var i = 0; i < ds_list_size(draw_notes_list); i++)
{
	draw_rectangle(
		draw_notes_list[| i].position * smallest_note_width + (draw_notes_list[| i].stanza * staff_width),
		room_height / 2 - draw_notes_list[| i].position/2,
		draw_notes_list[| i].position * smallest_note_width + (draw_notes_list[| i].stanza * staff_width)
			+ draw_notes_list[| i].beat_length * smallest_note_width,
		room_height / 2 + draw_notes_list[| i].position/2 + 30,
		true
	);
}

// Draw staves.
draw_set_color(c_red);
for (var i = 0; i < array_length(staff); i++)
{
	draw_line((i+1) * staff_width, room_height / 2 - 10, (i+1) * staff_width, room_height / 2 + 50);
}

draw_line(mouse_x, 0, mouse_x, room_height);
