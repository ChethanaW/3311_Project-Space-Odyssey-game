note
	description: "Summary description for {MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVABLE

feature -- common features
	movable_id: INTEGER  -- ref -> planet_id : INTEGER

	death_message: STRING

	r: INTEGER

	c: INTEGER

	letter : ENTITY_ALPHABET

    t : INTEGER

    quadrant: INTEGER

    prev_r: INTEGER

    prev_c: INTEGER

    prev_quadrant: INTEGER

	star_val : BOOLEAN

	supports_life : BOOLEAN

	has_checked_for_life : BOOLEAN

	visited: BOOLEAN

	attached_check: BOOLEAN



	entity_alphabet: ENTITY_ALPHABET

	landed: BOOLEAN

	new_quadrant: INTEGER

	sector_out_info: STRING


feature -- commands

	set_id(movables_id: INTEGER)
		do
			movable_id:= movables_id
		end

	set_row(row_num: INTEGER)
		do
			r:= row_num
		end

	set_column(col_num: INTEGER)
		do
			c :=col_num
		end

	set_quadrant(index: INTEGER)
		do
			quadrant := index
		end

	set_entity_alphabet(l: ENTITY_ALPHABET)
		do
			entity_alphabet := l
		end


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
