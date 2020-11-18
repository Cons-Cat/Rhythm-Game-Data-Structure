// Hacky gameplay
interactive_search = function(_cur_node, _cur_pos, _to_pos, _half)
{
	iterations++;
	if (escape) { return; }

	if (_cur_node.branch == pointer_null)
	{
		escape = true;
		isNote = true;
		_cur_node.played = !_cur_node.played;

		return;
	}

	if (_to_pos >= _cur_pos + _half)
	{
		if (_cur_node.branch[1] != pointer_null) // Terminate at rests.
		{
			interactive_search(_cur_node.branch[1], _cur_pos + _half, _to_pos, ceil(_half / 2));
		}
	} else {
		if (_cur_node.branch[0] != pointer_null) // Terminate at rests.
		{
			interactive_search(_cur_node.branch[0], _cur_pos, _to_pos, ceil(_half / 2));
		}
	}
}

play_stanza = mouse_x div staff_width;
play_note = (mouse_x - (play_stanza * staff_width)) div smallest_note_width;

if (mouse_check_button_pressed(mb_left))
{
	if (play_stanza < array_length(staff))
	{
		iterations = 0;
		escape = false;
		isNote = false;
		interactive_search(staff[play_stanza], 0, play_note, stanza_length >> 1);
		show_message("Found " + (isNote ? "note" : "rest") + " in " + string(iterations) + " steps.");
	}
}
