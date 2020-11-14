/*note_tail = function(_length) constructor
{
	// Making branch null is a type-safe way to
	// check if there exists an array or not.
	// That is done in the Draw event.
	branch = null;
	
	// Notes have a flag that is toggled when they have
	// been played. This prevents them from being
	// played multiple times.
	played = false;
	beat_length = _length;
}
