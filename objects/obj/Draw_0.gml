// Draw sixteenth bars.
for (var i = 0; i < staff_length; i++)
{
	draw_set_color(c_dkgray);
	for (var j = 0; j < 16; j++)
	{
		var draw_x = i * staff_width + j * staff_width / 16;
		draw_line(draw_x, room_height / 2 - 10, draw_x, room_height / 2 + 50);
	}

	// Draw eighth bars.
	draw_set_color(c_gray);
	for (var j = 0; j < 8; j++)
	{
		var draw_x = i * staff_width + j * staff_width / 8;
		draw_line(draw_x, room_height / 2 - 10, draw_x, room_height / 2 + 50);
	}

	// Draw quarter bars.
	draw_set_color(c_white);
	for (var j = 0; j < 4; j++)
	{
		var draw_x = i * staff_width + j * staff_width / 4;
		draw_line(draw_x, room_height / 2 - 10, draw_x, room_height / 2 + 50);
	}
}

// Draw notes.
draw_set_color(c_blue);
for (var i = 0; i < ds_list_size(draw_notes_list); i++)
{
	draw_rectangle(
		draw_notes_list[| i].position * smallest_note_width + (draw_notes_list[| i].stanza * staff_width),
		room_height / 2 - draw_notes_list[| i].position/2 + 1,
		draw_notes_list[| i].position * smallest_note_width + (draw_notes_list[| i].stanza * staff_width)
			+ draw_notes_list[| i].beat_length * smallest_note_width,
		room_height / 2 + draw_notes_list[| i].position/2 + 30,
		false
	);
}

for (var i = 0; i <= staff_length; i++)
{
	// Draw staves.
	draw_set_color(c_red);
	draw_line((i) * staff_width, room_height / 2 - 10, (i) * staff_width, room_height / 2 + 50);
}

// Draw cursor.
draw_line(mouse_x, 0, mouse_x, room_height);
