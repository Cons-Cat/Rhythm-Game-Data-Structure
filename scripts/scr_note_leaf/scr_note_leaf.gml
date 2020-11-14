/*note_leaf = function(_depth) constructor
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
