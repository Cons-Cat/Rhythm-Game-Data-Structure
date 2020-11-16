#region Constructors

note_leaf = function() constructor
{
	// index [0] is the left leaf,
	// index [1] is the right leaf.
	branch = array_create(2, pointer_null);
	tail = pointer_null;
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

// Treat me like an adult.
gc_enable(false);

// The staff is a fixed size array that represents an entire music track.
// 200 is an arbitrary number of stanzas.
staff = array_create(1);

current_staff = 0; // This is only used for playing.

// I generate a random music track.
random_set_seed(2);

#region Generate Staff

// This block is vestigial code from what I thought
// would be a trivial optimization in any C-like
// language. GML is 'special'.
add_node = array_create(2, pointer_invalid);
add_node[0] = asset_get_index("scr_add_leaf");
add_node[1] = asset_get_index("scr_add_tail")

// I'm going to move through each stanza
// in 32th (2^-5) note increments. But
// this would with any duration of notes
stanza_length = 32;

for (var i = 0; i < array_length(staff); i++)
{
	// Put a new stanza in the staff.
	staff[i] = new note_leaf();

	// For reasons unknown to me, Game Maker
	// will not update the value of branch[]
	// unless it gets some kind of assignment
	// around here.
	staff[0].branch[1] = 12;

	// I will assume this staff is 4:4 time.
	// Thus, I loop at most 32 times.
	for (var j = 0; j < stanza_length; j++)
	{
		// Generate a length for the beat.
		// It can be anywhere between the end of the staff,
		// and the current iterator.
		var beat_length = power(2, irandom_range(1, 5));
		var depths = (32 / beat_length) - 1;

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
		var temp_place = stanza_length << 1;

		// Bitshift Right then Load Immediate might
		// be faster than this Load Address, Idk.
		var half_place = temp_place;

		for (var k = 0; k < depths * rest_coeff; k++)
		{
			// If j is ahead of temp_place, ADD half_place.
			// Otherwise, SUBTRACT half_place.
			var half_place = half_place >> 1;
			temp_place +=
				(((j >= temp_place) * 2) - 1)
				* half_place;

			// Determine whether the next node is a leaf or a tail.
			var new_node;
			if (temp_place == j)
			{
				// beat_length is only passed in for drawing. It
				// has no logical behavior in a note_tail. Storing
				// the duration here is faster than discovering the
				// duration while the music is being searched.
				new_node = new note_tail(beat_length);

				// Storing this value is the only reason why I wrote
				// both a leaf and tail struct. Without this variable,
				// they would be effectively identical.
			} else {
				new_node = new note_leaf();
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

			// Inserts into index [1] or [0].
			cur_leaf.branch[ j >= temp_place ] = new_node;
			cur_leaf = new_node;
		}

		// This addition prevents notes in a single stanza from
		// overlapping. Multiple stanzas should be used for over-
		// lapping notes. I would recommend adding another layer
		// to this data structure, a ds_list of stanzas, for
		// every index in the staff to get that behavior.
		j += beat_length;
	}
}

#endregion
