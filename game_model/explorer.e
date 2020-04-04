note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

--	inherit
--		MOVABLE

--		redefine
--			is_dead,has_yellow_dwarf, letter,
--			quadrant,prev_quadrant,fuel,landed,
--			Max_fuel,sector_out_info,death_message,
--			set_quadrant,set_prev_quadrant,
--			set_is_dead,get_description

--		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create letter.make ('E')
			exp_coordinates := [1, 1]
			exp_prev_coordinates := [1,1]
			fuel := 3
			life:=3
			landed := FALSE
			game_over := 0
			create sector_out_info.make_empty
			sector_out_info := "[0,E]"
			create death_message.make_empty
			death_message := "none"
			is_dead:= false
			has_yellow_dwarf:= false
			has_planets:= false
			quadrant := 1
		end
feature -- model attributes

	is_dead: BOOLEAN -- did the exlorer die?

	has_yellow_dwarf: BOOLEAN -- is there a yellow dwarf int he same sactor?

    letter : ENTITY_ALPHABET

    exp_coordinates : TUPLE[row: INTEGER; column: INTEGER]
    exp_prev_coordinates : TUPLE[row: INTEGER; column: INTEGER]

    quadrant: INTEGER

    prev_quadrant: INTEGER

    fuel : INTEGER  -- explorer's fuel level

    life: INTEGER -- explorer's life status

    landed : BOOLEAN -- did the explorer land

    game_over : INTEGER -- did the explorer die and game ended?

    ID: INTEGER = 0

    Max_Fuel: INTEGER = 3

    sector_out_info: STRING

    death_message: STRING

    has_planets: BOOLEAN

feature -- Command


	update_coord(l_r: INTEGER; l_c: INTEGER)
		do
			exp_coordinates.row := l_r
			exp_coordinates.column := l_c
		--	exp_coordinates.quadrant := q
		end
	set_prev_coord(l_r: INTEGER; l_c: INTEGER)
		do

			exp_prev_coordinates.row := l_r
			exp_prev_coordinates.column := l_c
		end

	set_quadrant(qua: INTEGER)
		do
			quadrant := qua
		end

	set_prev_quadrant(qua: INTEGER)
		do
			prev_quadrant := qua
		end

	move_expl(a_dir : INTEGER; g:GALAXY):BOOLEAN -- move the explorer
				local
					direction: TUPLE[first: INTEGER; last: INTEGER]
					dir : DIRECTION_UTILITY
					targetPosition: SECTOR
					move_status : BOOLEAN

				do
					direction := dir.num_dir (a_dir)

--					IO.putint (direction.first)
--					IO.putint (direction.last)

 					move_status := g.move_player (direction.first, direction.last, letter)

 					Result := move_status
				end

		set_is_dead(status: BOOLEAN)
				do
					is_dead:= status
				end

		set_yellow_dwarf(status: BOOLEAN)
			do
				has_yellow_dwarf:= status
			end

		set_has_planets(status: BOOLEAN) -- there are planets at the sector
			do
				has_planets:= status
			end

		update_fuel(cur_fuel: INTEGER)
			do
				fuel := cur_fuel
			end

		update_life (cur_life: INTEGER)
			do
				life := cur_life
			end
		update_death_message(msg: STRING)
			do
				death_message := msg
			end
		update_landed_status(land_status: BOOLEAN)
			do
				landed := land_status
			end
feature -- Query
	get_description: STRING
		do
			create Result.make_empty
			Result.append(sector_out_info)
			Result.append("->fuel:")
			Result.append_integer_64(fuel)
			Result.append("/3, life:")
			Result.append_integer_64(life)
			Result.append("/3, landed?:")
			if landed ~ FALSE then
				Result.append("F")
			else
				Result.append("T")
			end

		end


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
