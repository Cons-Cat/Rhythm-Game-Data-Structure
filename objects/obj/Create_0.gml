#region Constructors

note_leaf = function() constructor
{
	// index [0] is the left leaf,
	// index [1] is the right leaf.
	branch = array_create(2, pointer_null);
	tail = pointer_null;

	static recurse_instantiate_note_leaf = function(_depth)
	{
		// Each leaf points to two other leaves.
		if (_depth < 5)
		{
			var next_depth = _depth + 1;
			branch[0] = new note_leaf(next_depth);
			branch[1] = new note_leaf(next_depth);
		}
		
		return;
	}
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

// The staff is a fixed size array that represents an entire music track.
// 200 is an arbitrary number of stanzas.
staff = array_create(1);

current_staff = 0; // This is only used for playing.

// I generate a random music track.
random_set_seed(2);

#region

for (var i = 0; i < array_length(staff); i++)
{
	// Put a new stanza in the staff.
	staff[i] = new note_leaf();
	staff[i].recurse_instantiate_note_leaf(5);
	
	// I'm going to move through this staff
	// in 32th (2^-5) note increments.
	// The algorithm which interprets this data
	// would work with any duration of notes, though.

	// I will assume this staff is 4:4 time.
	// Thus, I loop at most 32 times.
	for (var j = 0; j < 32; j++)
	{
		// Generate a length for the beat.
		// It can be anywhere between the end of the staff,
		// and the current iterator.
		var beat_length = power(2, irandom_range(1, 5));
		
		//// This is dumb, but I'm too tired to think
		//// about math, and it's just a dummy track
		//// generator.
		var depths = 32 / beat_length;
		//for (var k = 1; k < 5; k++) 
		//{
		//	if (((20 / k) % (power beat) == 0)
		//	{
		//		depths = k;
		//		break; 
		//	}
		//}

		// Populate the current staff.
		var cur_leaf = staff[i];
		show_debug_message(beat_length);

		// 50 : 50 chance of this beat being either
		// a note or a rest. If it's a rest, there
		// is no need to place a leaf representing
		// it, since the absence of a leaf can be
		// interpreted as a rest.
		var rest_coeff = irandom(1); // 0 or 1.
		var temp_place = 16;
		var half_place = 16;     // Load immediate is faster
                                   // than loading by address,
                                   // which is what:
                                   //  half_place = temp_place
                                   // would do here.

		for (var k = 1; k < (depths - 1) * rest_coeff; k++)
		{
			// If j is ahead of temp_place, ADD half_place.
			// Otherwise, SUBTRACT half_place.
			var half_place = half_place >> 1;
			temp_place +=
				// Compute either 1 or -1.
				(((j >= (temp_place + half_place)) * 2) - 1)
				// +half_place or -half_place.
				* half_place;

			// Inserts into index [1] or [0].
			if (cur_leaf.branch[ j >= temp_place ] == pointer_null) { break; }
			cur_leaf = cur_leaf.branch[
				j >= temp_place
			];
		}

		// beat_length is only passed in for drawing. It has
		// no logical behavior in a note_tail. Storing the
		// duration here is faster than discovering the
		// duration while the music is being searched.
		if (rest_coeff != 0)
		{
			//cur_leaf.tail = new note_tail(beat_length);
		}

		// This addition prevents notes in a single stanza from
		// overlapping. Multiple stanzas should be used for over-
		// lapping notes. I would recommend adding another layer
		// to this data structure, a ds_list of stanzas, for
		// every index in the staff to get that behavior.
		j += beat_length;
	}
}

var foo = 0;

#endregion
