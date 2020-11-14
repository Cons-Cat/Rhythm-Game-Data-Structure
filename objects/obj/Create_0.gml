#region Constructors

note_leaf = function(_depth) constructor
{
	// index [0] is the left leaf,
	// index [1] is the right leaf.
	branch = array_create(2, -4);
	tail = -4;
	
	// Each leaf points to two other leaves.
	if (_depth > 0)
	{
		_depth--;
		branch[0] = new note_leaf(_depth);
		branch[1] = new note_leaf(_depth);
	}
}

note_tail = function(_length) constructor
{
	// Making branch null is a type-safe way to
	// check if there exists an array or not.
	// That is done in the Draw event.
	branch = -4;
	
	// Notes have a flag that is toggled when they have
	// been played. This prevents them from being
	// played multiple times.
	played = false;
	beat_length = _length;
}

#endregion

// The staff is a fixed size array that represents an entire music track.
// 200 is an arbitrary number of stanzas.
staff = array_create(200);

current_staff = 0; // This is only used for playing.

// I generate a random music track.
random_set_seed(random_get_seed());

for (var i = 0; i < array_length(staff); i++)
{
	// Put a new stanza in the staff.
	staff[i] = new note_leaf(0);
	//generate_staff_tree(staff[i]);
	
	// I'm going to move through this staff
	// in 32th (2^5) note increments.
	// I will assume this staff is 4:4 time.
	
	// Thus, I loop through at most 5 * 4 iterations of a stanza.
	for (var j = 0; j < 20; j++)
	{
		// Generate a length for the beat.
		// It can be anywhere between the end of the staff,
		// and the current iterator.
		var beat = 0;
		while (beat == 0)
		{
			beat = irandom(20 - j);
		}
		
		// This is dumb, but I'm too tired to think
		// about math, and it's just a dummy track
		// generator.
		var depths;
		for (var k = 1; k < 5; k++) 
		{
			if (((20 / k) % beat) == 0)
			{
				depths = k;
				break; 
			}
		}
		
		// Populate the current staff.
		var cur_leaf = staff[i];
		
		// This is either 1 or 0.
		if (irandom(2))
		{
			// Non-zero represents a note.
			for (var k = 1; k < depths; k++)
			{
				// Inserts into index [1] or [0].
				cur_leaf = cur_leaf.branch[ j >= (20 / power(2, k)) ];
			}
			
			// beat is only passed in for drawing. It has no
			// logical behavior in a note_tail.
			cur_leaf.tail = new note_tail(beat);
			
			// This addition prevents notes in a single stanza from
			// overlapping. Multiple stanzas should be used for over-
			// lapping notes. I would recommend adding another layer
			// to this data structure, a ds_list of stanzas, for every
			// index in the staff if that is behavior you want.
			j += beat;
		}
		// Zero represents a rest.
	}
}
