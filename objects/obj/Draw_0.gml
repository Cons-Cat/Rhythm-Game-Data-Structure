draw_set_color (c_blue);
var smallest_note_width = 4; // 4 is an arbitrary number.
var staff_width = 80;

function recurse_draw_notes(_staff_id, _position, _half)
{
	// Stop recursing when hit pointer_null.
	// This represents a rest beat.
	if (_staff_id == pointer_null) { return; }
	
	// If the leaf has a pointer_null branch array,
	// then it is a tail.
	if (_staff_id.branch == pointer_null)
	{
		show_debug_message(_position)
		draw_rectangle(
			_position * staff_width,
			room_height / 2,
			_position * staff_width + 10,
			room_height / 2 + 30,
			false
		);

		// Stop recursing.
		return;
	}

	recurse_draw_notes(_staff_id.branch[0], _position - _half, _half << 1);
	recurse_draw_notes(_staff_id.branch[1], _position + _half, _half << 1);
}

// Recursively search through the next 4 staves
// to find and render every note.
for (var i = 0; i < array_length(staff); i++)
{
	// Start at 1 depth and 2 beats ( half of 4, for 4:4 time )
	recurse_draw_notes(staff[i], stanza_length << 1, stanza_length << 1);
}
show_debug_message(" ");
