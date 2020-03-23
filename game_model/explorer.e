note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

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
		end
feature -- model attributes

	is_dead: BOOLEAN

    letter : ENTITY_ALPHABET

    exp_coordinates : TUPLE[row: INTEGER; column: INTEGER]
    exp_prev_coordinates : TUPLE[row: INTEGER; column: INTEGER]

    quadrant: INTEGER

    prev_quadrant: INTEGER

    fuel : INTEGER

    life: INTEGER

    landed : BOOLEAN

    game_over : INTEGER

    ID: INTEGER = 0

    Max_Fuel: INTEGER = 3

    sector_out_info: STRING

    death_message: STRING

feature -- Command


	update_coord(r: INTEGER; c: INTEGER)
		do
			exp_coordinates.row := r
			exp_coordinates.column := c
		--	exp_coordinates.quadrant := q
		end
	set_prev_coord(r: INTEGER; c: INTEGER)
		do

			exp_prev_coordinates.row := r
			exp_prev_coordinates.column := c
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

--	update_fuel(sect: SECTOR)
--		local
--			blue: ENTITY_ALPHABET
--			yellow: ENTITY_ALPHABET
--			worm: ENTITY_ALPHABET
--		do
--			create blue.make ('*')
--			create yellow.make ('Y')
--			create worm.make ('W')

----			across sect.contents is element loop
----				fuel := fuel - 1
----				if element ~ blue then
----					fuel := 3
----					print("here!! ")
----				elseif element ~ yellow then
----					if fuel = 0 then
----						fuel := 2
----					else
----						fuel := 3
----					end
----				elseif element ~ worm then
----					fuel := fuel
----				elseif fuel = 0 then
----					game_over := 1
----				end
----			end
----				print("the fuel is ")print(fuel)print("%N")

--		end

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
