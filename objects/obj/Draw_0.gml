
function recurse_draw_notes(_branch_id, _staff_ind, _position, _half)
{
	// Stop recursing when hit pointer_null.
	// This represents a rest beat.
	if (_branch_id == pointer_null) { return; }
	
	// If the leaf has a pointer_null branch array,
	// then it is a tail.
	if (_branch_id.branch == pointer_null)
	{
		draw_rectangle(
			_position + (_staff_ind * staff_width),
			room_height / 2 - _position/2,
			_position + (_staff_ind * staff_width)
				+ _branch_id.beat_length * smallest_note_width,
			room_height / 2 + _position/2 + 30,
			true
		);

		// Stop recursing.
		return;
	}

	recurse_draw_notes(_branch_id.branch[0], _staff_ind, _position - _half, _half >> 1);
	recurse_draw_notes(_branch_id.branch[1], _staff_ind, _position + _half, _half >> 1);
}

// Recursively search through the next 4 staves
// to find and render every note.
for (var i = 0; i < array_length(staff); i++)
{
	// Draw notes.
	draw_set_color(c_blue);
	recurse_draw_notes(staff[i], i, stanza_length >> 1, stanza_length >> 2);
	
	// Draw staves.
	draw_set_color(c_red);
	draw_line((i+1) * staff_width, room_height / 2 - 10, (i+1) * staff_width, room_height / 2 + 50);
}
