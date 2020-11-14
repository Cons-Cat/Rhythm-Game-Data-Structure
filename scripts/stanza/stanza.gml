/*stanza() = function() constructor
{
	// Stanzas contain an arbitrary list of notes.
	// These are represented as an ** unbalanced binary search tree **.
	branch_left = null;
	branch_right = null;
	
	function make_tree (_depth)
	{
		// These constructors are recursive.
		branch_left = note_leaf(_depth);
		branch_right = note_leaf(_depth);
	}
}
