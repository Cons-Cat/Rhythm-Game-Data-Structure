draw_set_color (c_blue);
var smallest_note_width = 4; // 4 is an arbitrary number.
var staff_width = 80;

function recurse_draw_notes(_staff_id, _depths, _position)
{
	// Stop recursing when hit null.
	if (_staff_id == -4) { return; }
	
	// If the leaf has a null branch array,
	// then it is a tail.
	if (_staff_id.branch == -4)
	{
		show_debug_message("A")
		draw_rectangle(_position * staff_width,
			room_height / 2,
			_position * staff_width + 10,
			room_height / 2 + 30,
			false
		);

		// Stop recursing.
		return;
	}

	recurse_draw_notes(_staff_id.branch[0], _depths + 1, _position - _depths / 2);
	recurse_draw_notes(_staff_id.branch[1], _depths + 1, _position + _depths / 2);
}

// Recursively search through the next 4 staves
// to find and render every note.
//for (var i = 0; i < 4; i++)
{
	// Start at 1 depth and 2 beats ( half of 4, for 4:4 time )
	recurse_draw_notes(staff[0], 1, 2);
}
show_debug_message(" ");
