#region Constructors

note_leaf = function() constructor
{
	// index [0] is the left leaf,
	// index [1] is the right leaf.
	branch = array_create(2, pointer_null);
}

note_tail = function(_beat_length) constructor
{
	// Making branch null is a type-safe way to
	// check if there exists an array or not.
	// That is done in the Draw event.
	branch = pointer_null;

	// Notes have a flag that is toggled when they have
	// been played. This prevents them from being
	// played multiple times.
	played = false;
	beat_length = _beat_length;
}

#endregion

// I generate a random music track.
random_set_seed(2);

// I am an adult.
gc_enable(false);

// The staff is a fixed size array that represents an entire music track.
// 200 is an arbitrary number of stanzas.
staff = array_create(4);

// Interactive values.
current_staff = 0;
escape = false;

// I'm going to move through each stanza
// in 32th (2^-5) note increments. But
// this would with any duration of notes
stanza_length = 32;

// Drawing values.
smallest_note_width = 2; // 2 is an arbitrary number.
staff_width = smallest_note_width * stanza_length;

#region

// This is a lazy function to finish the tree.
optimize_tree_recurse = function(_cur_pos, _low_bound, _up_bound, _half,
                                  _cur_node, _stanza_len, _prev_node)
{
	// Terminate on a note.
	if (_cur_node.branch == pointer_null)
	{
		return _cur_node;
	}

	if (
		(_cur_pos + _half) <= _up_bound
		&& _cur_pos >= _low_bound
	)
	{
		// TODO: Delete nodes up the tree.

		// End search, and move back down the tree.
		return _prev_node;
	} else {
		// Recurse down the tree.
		//if (_cur_pos >= _low_bound)
		{
			if (_cur_node.branch[0] != pointer_null)
			{
				_cur_node.branch[0] = optimize_tree_recurse(_cur_pos, _low_bound, _up_bound,
					ceil(_half / 2), _cur_node.branch[0], _stanza_len, _prev_node);
			} else {
				if _cur_pos + _half < _up_bound
				{
					_cur_node.branch[0] = _prev_node;
				}
			}
		}

		//if ((_cur_pos + _half) <= _up_bound)
		{
			if (_cur_node.branch[1] != pointer_null)
			{
				_cur_node.branch[1] = optimize_tree_recurse(_cur_pos + _half, _low_bound, _up_bound,
					ceil(_half / 2), _cur_node.branch[1], _stanza_len, _prev_node);
			} else {
				if _cur_pos >= _low_bound
				{
					_cur_node.branch[1] = _prev_node;
				}
			}
		}

		// Converge back down the tree.
		return _cur_node;
	}
}

#endregion

#region Generate Staff

// This block is vestigial code from what I thought
// would be a trivial optimization in any C-like
// language. GML is special.
	//add_node = array_create(2, pointer_invalid);
	//add_node[0] = asset_get_index("scr_add_leaf");
	//add_node[1] = asset_get_index("scr_add_tail")
//

for (var i = 0; i < array_length(staff); i++)
{
	show_debug_message("Stanza: " + string(i));

	// Put a new stanza in the staff.
	staff[i] = new note_leaf();
	var temp_list_notes = ds_list_create();

	// I will assume this staff is 4:4 time.
	// Thus, I loop at most 32 times.
	for (var j = 0; j < stanza_length; j++)
	{
		// Generate a length for the beat.
		// It can be anywhere between the end of the staff,
		// and the current iterator.
		var beat_length = min( power(2, irandom_range(1, 5)), power(2, log2(stanza_length - j)) );

		var cur_leaf = staff[i];
	
		// 50 : 50 chance of this beat being either
		// a note or a rest. If it's a rest, there
		// is no need to place a leaf representing
		// it, since the absence of a leaf can be
		// interpreted as a rest.
		var rest_coeff = irandom(1); // 0 or 1.

		// Idk if Game Maker VM will optimize semantically
		// clear division, or if bitshifting is faster.
		// On YYC, this is probably worse than / 2.
		var temp_place = 0;

		// Bitshift Right + Load Immediate might
		// be faster than this Load Address, Idk.
		var half_place = stanza_length;

		for (var k = 1; k <= log2(stanza_length) * rest_coeff; k++)
		{
			half_place = ceil(half_place / 2);

			// Inserts into index [1] or [0].
			var index = j >= (temp_place + half_place);

			// If j is ahead of temp_place, ADD half_place.
			// Otherwise, SUBTRACT half_place.
			// ceil prevents half_place from being 0.
			temp_place += (index * half_place);

			// Determine whether the next node is a leaf or a tail.
			if (k < log2(stanza_length))
			{
				if (cur_leaf.branch[index] == pointer_null)
				{
					var new_node = new note_leaf();
					cur_leaf.branch[index] = new_node;
				}

				cur_leaf = cur_leaf.branch[index];
				continue;
			} else {
				show_debug_message("  Posi: " + string(j));
				show_debug_message("  Leng: " + string(beat_length));
				show_debug_message("");

				// beat_length is only passed in for drawing. It
				// has no logical behavior in a note_tail. Storing
				// the duration here is faster than discovering the
				// duration while the music is being searched.
				cur_leaf.branch[index] = new note_tail(beat_length);

				// Used for optimizing the tree size.
				ds_list_add(temp_list_notes, j);
				ds_list_add(temp_list_notes, cur_leaf.branch[index]);
			}

			// In C++, it would be easy to inline two functions
			// and branchlessly determine which type of node to
			// instantiate. I do not have the minde to
			// comprehend GML's galaxy brain language semantics
			// and figure out how to do that here. I made this
			// attempt:
			//
			//	var new_node = script_execute(add_node[temp_place == j], beat_length);
			//
		}

		// This addition prevents notes in a single stanza from
		// overlapping. Multiple stanzas should be used for over-
		// lapping notes. I would recommend adding another layer
		// to this data structure, a ds_list of stanzas, for
		// every index in the staff to get that behavior.
		j += beat_length;
	}

	// This is about the part where I got tired
	// and stopped considering efficiency. Sorry.
	for (var j = 0; j < (ds_list_size(temp_list_notes) >> 1) - 1; j += 2)
	{
		optimize_tree_recurse(
			0,                                  // Begin search at start of stanza.
			temp_list_notes[| j],
			temp_list_notes[| j]
			+ temp_list_notes[| j+1].beat_length,
			stanza_length,
			staff[i],                           // Search through the current stanza.
			stanza_length,                      // Pass the stanza length in by value.
			temp_list_notes[| j+1]              // Try to replace nodes with a reference to the current note.
		)
	}

	// The list is not needed afterwards.
	ds_list_destroy(temp_list_notes);
}

#endregion
