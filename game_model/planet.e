note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

	inherit
		MOVABLE



create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create letter.make ('P')
			yellow_dwarf := false
			has_checked_for_life := false
			create entity_alphabet.make('P')
			visited := false
			create sector_out_info.make_empty
			create death_message.make_empty

		end
feature -- model attributes



feature --commands

--	set_entity_alphabet(l: ENTITY_ALPHABET)
--		do
--			entity_alphabet := l
--		end


--	set_planet_id(id: INTEGER)
--		do
--			planet_id := id
--		end

--	set_check_flag(b: BOOLEAN)
--		do
--			has_checked_for_life := b
--		end

--	support_life(yes: BOOLEAN)
--		do
--			supports_life := yes
--		end

--	has_yellow_dwarf(b: BOOLEAN)
--		do
--			yellow_dwarf := b
--		end


--	set_row(row : INTEGER)
--		do
--			r := row

--		end

--	set_column(col : INTEGER)
--		do
--			c := col

--		end

--	set_turn(turn : INTEGER)
--		do
--			t := turn
--		end

--	set_prev_r_c(row:INTEGER; col: INTEGER)

--		do
--			prev_r := row
--			prev_c := col

--		end

--	set_prev_quadrant(qua: INTEGER)
--		do
--			prev_quadrant := qua
--		end

--	set_quadrant(index: INTEGER)
--		do
--			quadrant := index
--		end

--	set_new_quadrant(new_q: INTEGER)
--		do
--			new_quadrant := new_q
--		end

--	decrement_turn
--		do
--			t := t - 1
--		end

--	star_value (val: BOOLEAN)
--		do
--			star_val := val
--		end

	set_visited(status: BOOLEAN)
		do
			visited:= status
		end


feature -- query

--	has_star: BOOLEAN
--		do
--			if star_val = True then
--				Result := True
--				attached_check := Result
--			else
--				Result := False
--				attached_check := Result
--			end
--		end

--	is_planet(a_letter : ENTITY_ALPHABET) : BOOLEAN
--		do
--			create Result
--			if a_letter ~ letter then
--				Result := TRUE
--			else
--				Result := FALSE
--			end
--		end


--	get_row : INTEGER
--		do
--			Result := r
--		end

--	get_turn : INTEGER
--		do
--			Result := t
--		end
--	get_col : INTEGER
--		do
--			Result := c
--		end



	is_visited : BOOLEAN
		do
			Result := visited
		end


--	get_description: STRING
--		do
--			create Result.make_empty
--			Result.append("[")
--			Result.append_integer_64 (movable_id)
--			Result.append(",P]->attached?:")
--			if star_val ~ False then
--				Result.append("F, ")
--			else
--			 	Result.append("T, ")
--			end
--			Result.append("support_life?:")
--			if supports_life ~ False then
--				Result.append("F, ")
--			else
--			 	Result.append("T, ")
--			end
--			Result.append("visited?:")
--			if visited ~ False then
--				Result.append("F, ")
--			else
--				Result.append("T, ")
--			end
--			Result.append("turns_left:")
--			if star_val ~ False then
--				Result.append_integer_64(t)
--			else
--				Result.append("N/A")
--			end


--		end




feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
