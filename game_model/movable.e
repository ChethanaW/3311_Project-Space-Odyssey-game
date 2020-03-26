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


	yellow_dwarf : BOOLEAN

	entity_alphabet: ENTITY_ALPHABET

	landed: BOOLEAN

	new_quadrant: INTEGER

	sector_out_info: STRING


feature -- commands

	set_visited(status: BOOLEAN)
		do
			visited:= status
		end

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

	set_turn(turn : INTEGER)
		do
			t := turn
		end

	has_yellow_dwarf(b: BOOLEAN)
		do
			yellow_dwarf := b
		end

	set_new_quadrant(new_q: INTEGER)
		do
			new_quadrant := new_q
		end

	decrement_turn
		do
			t := t - 1
		end

	star_value (val: BOOLEAN)
		do
			star_val := val
		end

	set_prev_r_c(row:INTEGER; col: INTEGER)

		do
			prev_r := row
			prev_c := col

		end

	set_prev_quadrant(qua: INTEGER)
		do
			prev_quadrant := qua
		end

	set_check_flag(b: BOOLEAN)
		do
			has_checked_for_life := b
		end

	support_life(yes: BOOLEAN)
		do
			supports_life := yes
		end


feature --queries

	is_visited : BOOLEAN
		do
			Result := visited
		end

	has_star: BOOLEAN
		do
			if star_val = True then
				Result := True
				attached_check := Result
			else
				Result := False
				attached_check := Result
			end
		end

	is_planet(a_letter : ENTITY_ALPHABET) : BOOLEAN
		do
			create Result
			if a_letter ~ letter then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	get_row : INTEGER
		do
			Result := r
		end

	get_turn : INTEGER
		do
			Result := t
		end
	get_col : INTEGER
		do
			Result := c
		end

	is_landed(b: BOOLEAN) : BOOLEAN
		do
			landed := b
			visited := b
			Result := landed
		end

	get_description: STRING
		do
			create Result.make_empty
			Result.append("[")
			Result.append_integer_64 (movable_id)
			Result.append(",")
			Result.append_character(entity_alphabet.item)
			if entity_alphabet.item ~ 'P' then
				Result.append("]->attached?:")
				if star_val ~ False then
					Result.append("F, ")
				else
				 	Result.append("T, ")
				end
				Result.append("support_life?:")
				if supports_life ~ False then
					Result.append("F, ")
				else
				 	Result.append("T, ")
				end
				Result.append("visited?:")
				if visited ~ False then
					Result.append("F, ")
				else
					Result.append("T, ")
				end
				Result.append("turns_left:")
				if star_val ~ False then
					Result.append_integer_64(t)
				else
					Result.append("N/A")
				end
			else
				Result.append("]->fuel?:")
				if supports_life ~ False then
					Result.append("F, ")
				else
				 	Result.append("T, ")
				end
				Result.append("action_left_until_reproduction?:")
				if visited ~ False then
					Result.append("F, ")
				else
					Result.append("T, ")
				end
				Result.append("turns_left:")
				if star_val ~ False then
					Result.append_integer_64(t)
				else
					Result.append("N/A")
				end
			end



		end

invariant
	invariant_clause: True -- Your invariant here

end
