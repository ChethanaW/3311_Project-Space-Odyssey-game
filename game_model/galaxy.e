note
	description: "Galaxy represents a game board in simodyssey."
	author: "Kevin B"
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY

inherit ANY
	redefine
		out
	end

create
	make,
	dummy_galaxy_make

feature -- attributes

	grid: ARRAY2 [SECTOR]
			-- the board

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end
	flag : INTEGER

	du: DIRECTION_UTILITY

	explorer : ENTITY_ALPHABET

	letter_p : ENTITY_ALPHABET

	letter_replacement: ENTITY_ALPHABET

	turn_flag : INTEGER

	fuel_check: BOOLEAN

	-- --ex: EXPLORER

	 last_coord: EXPLORER

	move_planet_list : ARRAY[PLANET]
	p_move_index: INTEGER
	stat_id: INTEGER


feature --constructor

	make

		local
			row : INTEGER
			column : INTEGER

		do
			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)

			from
				row := 1
			until
				row > shared_info.number_rows
			loop

				from
					column := 1
				until
					column > shared_info.number_columns
				loop
					grid[row,column] := create {SECTOR}.make(row,column,create{ENTITY_ALPHABET}.make ('E'))
					column:= column + 1;
				end
				row := row + 1
			end
			set_stationary_items
			--create player_coord.make (1, 1, create{ENTITY_ALPHABET}.make ('E'))
			--create last_coord.make (player_coord.row.deep_twin, player_coord.column.deep_twin, create{ENTITY_ALPHABET}.make ('E'))
			--last_coord := player_coord.deep_twin
			create explorer.make ('E')
			create letter_p.make('P')
			turn_flag := 0
			-- create ex.make
			create last_coord.make
			last_coord := shared_info.explorer.deep_twin
			flag := 0

			create letter_replacement.make('-')
			create move_planet_list.make_empty
			move_planet_list.compare_objects
			p_move_index :=0
			fuel_check := false

	end

feature -- constructor

	dummy_galaxy_make
		do
			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)
			--create player_coord.make (1, 1, create{ENTITY_ALPHABET}.make ('E'))
			--create last_coord.make (player_coord.row.deep_twin, player_coord.column.deep_twin, create{ENTITY_ALPHABET}.make ('E'))
			--last_coord := player_coord.deep_twin
			create explorer.make ('E')
			create letter_p.make('P')
			-- create ex.make
			create last_coord.make
			last_coord := shared_info.explorer.deep_twin
			create letter_replacement.make('-')
			create move_planet_list.make_empty

		end


feature --commands

	set_stationary_items
			-- distribute stationary items amongst the sectors in the grid.
			-- There can be only one stationary item in a sector
		local
			loop_counter: INTEGER
			check_sector: SECTOR
			temp_row: INTEGER
			temp_column: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > shared_info.number_of_stationary_items
			loop

				temp_row :=  gen.rchoose (1, shared_info.number_rows)
				temp_column := gen.rchoose (1, shared_info.number_columns)
				check_sector := grid[temp_row,temp_column]
				if (not check_sector.has_stationary) and (not check_sector.is_full) then
					grid[temp_row,temp_column].put (create_stationary_item(temp_row,temp_column, loop_counter+1))

					loop_counter := loop_counter + 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item(r:INTEGER; c: INTEGER;id_s:INTEGER): ENTITY_ALPHABET
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
			wormhole: WORMHOLE
			yellow_dwarf : YELLOW_DWARF
			blue_giant: BLUE_GIANT
			stationary: STATIONARY
			--blackhole: BLACKHOLE
		do
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
				create Result.make('Y')
				Result.represents_stationary_id (id_s)
				create yellow_dwarf.make
				stationary:= yellow_dwarf
				stationary.set_id (id_s)
				stationary.set_luminosity(2)
				stationary.set_row(r)
				stationary.set_column(c)
				shared_info.stationary_list.force(yellow_dwarf, shared_info.stationary_list.count +1)

			when 2 then
				create Result.make('*')
				Result.represents_stationary_id (id_s)
				create blue_giant.make
				stationary:= blue_giant
				stationary.set_id (id_s)
				stationary.set_luminosity(5)
				stationary.set_row(r)
				stationary.set_column(c)
				shared_info.stationary_list.force(blue_giant, shared_info.stationary_list.count +1)

			when 3 then
				create Result.make('W')
				Result.represents_stationary_id (id_s)
				create wormhole.make
				stationary:=wormhole
				stationary.set_id (id_s)
				stationary.set_luminosity(0)
				stationary.set_row(r)
				stationary.set_column(c)
				shared_info.stationary_list.force(wormhole, shared_info.stationary_list.count +1)

			else
				create Result.make('Y') -- create more yellow dwarfs this will never happen, but create by default
			end -- inspect

		end

	move_player(row_input: INTEGER; column_input: INTEGER; a_explorer:ENTITY_ALPHABET): BOOLEAN

			-- Basic implementation of player movement in the maze.
			-- Move the player with a y_delta = `row_mod` and x_delta = `col_mod`
			-- d: TUPLE[row_mod: INTEGER; col_mod: INTEGER]

		local

			temp_row : INTEGER
			temp_col : INTEGER
			placed_on_letter_replacement : BOOLEAN
			pointer : INTEGER
			quadrant: INTEGER
		do
			placed_on_letter_replacement := false
			pointer := 1


			last_coord := shared_info.explorer.deep_twin -- update last coord

			shared_info.explorer.set_prev_coord (last_coord.exp_coordinates.row,last_coord.exp_coordinates.column)
			quadrant := 1
			across grid[last_coord.exp_coordinates.row, last_coord.exp_coordinates.column].contents is entity
			loop
				if entity ~ create{ENTITY_ALPHABET}.make('E') then
					shared_info.explorer.set_prev_quadrant (quadrant)
				end
				quadrant := quadrant +1
			end

			temp_row := last_coord.exp_coordinates.row + row_input
			temp_col := last_coord.exp_coordinates.column + column_input

			if temp_row > 5 then
				temp_row := 1
			end
			if temp_row < 1 then
				temp_row := 5
			end
			if temp_col  > 5 then
				 temp_col := 1
			end
			if  temp_col < 1 then
				 temp_col := 5
			end

			if temp_row = 3 and temp_col = 3 then
				Result := TRUE
				shared_info.explorer.set_is_dead(true)
				across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is value loop
					if value ~ a_explorer then
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.go_i_th (pointer)

						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.replace (letter_replacement)
					end
					pointer:= pointer + 1
				end
				shared_info.explorer.update_coord(temp_row, temp_col)
--				shared_info.explorer.set_prev_quadrant(2)
				shared_info.explorer.set_quadrant(2)
			else

			if not grid[temp_row, temp_col].is_full then -- if there's an empty space or there's '-'
				across grid[temp_row, temp_col].contents is entity loop
					if entity ~ letter_replacement then
						shared_info.explorer.update_coord (temp_row, temp_col)
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.put (a_explorer)
						placed_on_letter_replacement := true
					end
				end
					if not placed_on_letter_replacement then
						shared_info.explorer.update_coord (temp_row, temp_col)
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.force (a_explorer)
--						quadrant := 1
--						across grid[ex.exp_coordinates.row, ex.exp_coordinates.column].contents is entity
--						loop
--							if entity ~ create{ENTITY_ALPHABET}.make('E') then
--								ex.set_quadrant (quadrant)
--							end
--							quadrant := quadrant +1
--						end
					end
					quadrant := 1
					across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is entity
						loop
							if entity ~ create{ENTITY_ALPHABET}.make('E') then
								shared_info.explorer.set_quadrant (quadrant)
							end
						quadrant := quadrant +1
					end
				get_updated_fuel(shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column) -- print(ex.fuel)
				-- shared_info.explorer.update_coord(ex.exp_coordinates.row, ex.exp_coordinates.column)
				if shared_info.explorer.fuel < 1 then
					grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.go_i_th (pointer)
					grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.replace (letter_replacement)
				end
				Result := TRUE
			else
				-- print("false")
				Result := FALSE
			end
			end


		--	ex.update_coord (temp_row, temp_col))

			grid[last_coord.exp_coordinates.row,last_coord.exp_coordinates.column].contents.prune_all (a_explorer)

--			grid[ex.exp_coordinates.row, ex.exp_coordinates.column].contents.force (a_explorer)
--			ex.update_fuel(grid[ex.exp_coordinates.row, ex.exp_coordinates.column])
			--print("[0,E]")print(ex.exp_prev_coordinates.row)print(" " )print(ex.exp_prev_coordinates.column)print("->")print(ex.exp_coordinates.row)print(" ")print(ex.exp_coordinates.column)print("%N")

		end



	movement(p: PLANET)
		local
			temp_row : INTEGER
			temp_column : INTEGER
			create_sector : SECTOR
			turn : INTEGER
			dir : INTEGER
			direction: TUPLE[first: INTEGER; last: INTEGER]
			d : DIRECTION_UTILITY
			placed_on_letter_replacement : BOOLEAN
			letter_planet : ENTITY_ALPHABET
--			quadrant : INTEGER

		do
			-- PLANET with turn 0 and no star

					placed_on_letter_replacement := False
					dir := gen.rchoose (1, 8)
					direction := d.num_dir (dir)
					create letter_planet.make ('P')

					temp_row := p.get_row + direction.first
					temp_column := p.c + direction.last
					if temp_row > 5 then
						temp_row := 1
					elseif temp_row < 1 then
						temp_row := 5
					end
					if temp_column > 5 then
						temp_column := 1
					elseif temp_column < 1 then
						temp_column := 5
					end


					get_planet_quadrant(p, p.r, p.c)

					grid[p.r, p.c].contents.go_i_th (p.quadrant)
					--print("the planet and sector are ")print(p.planet_id)print(" and ")print(p.quadrant)print(" and the row and column are ")print(p.r)print(p.c)

					grid[p.r, p.c].contents.replace (letter_replacement)

					if not grid[temp_row, temp_column].is_full then -- if there's an empty space or there's '-'
					-- print("the target sector is not full ")print("%N")
						across grid[temp_row, temp_column].contents is entity loop
							if entity ~ letter_replacement then
								-- print("here!!!") print("%N")
								grid[temp_row, temp_column].contents.put (letter_planet)
								placed_on_letter_replacement := true
							end
						end
						if not placed_on_letter_replacement then
							grid[temp_row, temp_column].contents.force (letter_planet)
						end
						letter_planet.represents_planet_id(p.planet_id)
						p.set_prev_r_c(p.r,p.c)
						p.set_entity_alphabet (letter_planet)
						p.set_row (temp_row)
						p.set_column (temp_column)
					--	print("after moving, the entity plant id is")print(letter_planet.entity_planet_id)print("%N")print("%N")
						move_planet_list.force (p, p_move_index)
						p_move_index := p_move_index + 1
						--print(" and move to row and column ")print(p.r)print(" ")print(p.c)print(" ")print(p.quadrant)print("%N")
					end

					across grid[p.get_row, p.get_col].contents is val loop
						if val.is_star then
							p.star_value(True)
						end
					end

		end

	move_planets
		local
			row_counter: INTEGER
			col_counter: INTEGER
			sector_counter: INTEGER
			turn :INTEGER
			p: PLANET
			temp: ARRAY[PLANET]
			yellow_dwarf: INTEGER
			num: INTEGER
			new_q: INTEGER

		do
			create temp.make_empty
			temp.compare_objects
			yellow_dwarf := 0

			across shared_info.planet_list is planet loop
				--print("[")print(planet.get_row)print(" ") print(planet.get_col)print("]")print(" ")
--				print(planet.at)
--				print("[")print(i)print("]")
--				i:= i + 1
--				print("before decrementing turn ")
--				print(planet.get_turn)
--				print(" ")
--				print("%N")
--				print("the row and column of planet are ") print(planet.get_row) print(" and ") print(planet.get_col)

				--planet.star_value(False)
				if planet.get_turn = 0 then
				across grid[planet.get_row, planet.get_col].contents is val loop
					if val.is_star then
						planet.star_value(True)
						if val.item ~ 'Y' then
							planet.has_yellow_dwarf(true)
						else
							planet.has_yellow_dwarf(false)
						end
					end
				end
				end


				if planet.get_turn = 0 then
					if planet.has_star = true then
						if planet.yellow_dwarf = true and not planet.has_checked_for_life then
							num := gen.rchoose(1, 2) -- num=2 means life
							if num = 2 then
								planet.support_life(true)
							end
							planet.set_check_flag(TRUE)
						end
					else
						movement(planet)
						get_planet_new_quadrant(planet, planet.r, planet.c)

						if planet.has_star = false then
							turn:=gen.rchoose (0, 2)
						end
						planet.set_turn(turn)
					end
				else
					planet.set_turn(planet.get_turn - 1)
				end

--				print("before decrementing turn ")
--				print(planet.get_turn)
--				print(" ")
--				print("%N")

			end

		end


	check_planet(p: PLANET)
		do

		end

	wormhole_move(a_ent: ENTITY_ALPHABET)

		local
			temp_row : INTEGER
			temp_col : INTEGER
			placed_on_letter_replacement : BOOLEAN
			pointer : INTEGER
			quadrant: INTEGER
			worm_exists: BOOLEAN
		do
			placed_on_letter_replacement := false
			pointer := 1

			last_coord := shared_info.explorer.deep_twin -- update last coord
			shared_info.explorer.set_prev_coord (last_coord.exp_coordinates.row,last_coord.exp_coordinates.column)

			quadrant := 1
			across grid[last_coord.exp_coordinates.row, last_coord.exp_coordinates.column].contents is entity
			loop
				if entity ~ create{ENTITY_ALPHABET}.make('E') then
					shared_info.explorer.set_prev_quadrant (quadrant)
				end
				quadrant := quadrant +1
			end

			temp_row := gen.rchoose(1,5)
			temp_col := gen.rchoose(1,5)


			if temp_row = 3 and temp_col = 3 then
				-- Result := TRUE
				shared_info.explorer.set_is_dead(true)
				across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is value loop
					if value ~ a_ent then
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.go_i_th (pointer)

						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.replace (letter_replacement)
					end
					pointer:= pointer + 1
				end
				shared_info.explorer.update_coord(temp_row, temp_col)
--				shared_info.explorer.set_prev_quadrant(2)
				shared_info.explorer.set_quadrant(2)
			else

			if not grid[temp_row, temp_col].is_full then -- if there's an empty space or there's '-'
				across grid[temp_row, temp_col].contents is entity loop
					if entity ~ letter_replacement then
						shared_info.explorer.update_coord (temp_row, temp_col)
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.put (a_ent)
						placed_on_letter_replacement := true
					end
				end
					if not placed_on_letter_replacement then
						shared_info.explorer.update_coord (temp_row, temp_col)
						grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents.force (a_ent)
					end
					quadrant := 1
					across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is entity
						loop
							if entity ~ create{ENTITY_ALPHABET}.make('E') then
								shared_info.explorer.set_quadrant (quadrant)
							end
						quadrant := quadrant +1
					end
				-- get_updated_fuel(shared_info.explorer, shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column) -- print(ex.fuel)
			else

				-- wormhole directed explorer to full sector... do
			end
		end
		grid[last_coord.exp_coordinates.row,last_coord.exp_coordinates.column].contents.prune_all (a_ent)
	end



feature -- query

	check_for_wormhole: BOOLEAN
		do
			--create worm.make('W')
			across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is entity loop
				if entity ~ create{ENTITY_ALPHABET}.make('W') then
					Result := TRUE
				end
			end
			Result := FALSE
		end

	get_updated_fuel(row: INTEGER; col: INTEGER)
		do
			shared_info.explorer.update_fuel(shared_info.explorer.fuel - 1)
			across grid[row, col].contents is entity loop
				if entity ~ create{ENTITY_ALPHABET}.make('*') then
					shared_info.explorer.update_fuel(3)
					-- print("herererer")
				elseif entity ~ create{ENTITY_ALPHABET}.make('Y') then
					shared_info.explorer.update_fuel(3)
				end
				if shared_info.explorer.fuel > 3 then
					shared_info.explorer.update_fuel(3)
				end
			end
			if shared_info.explorer.fuel < 1 then
				fuel_check := true
			end
		end

	get_planet_quadrant(planet: PLANET; row: INTEGER; col: INTEGER)
		local
			quadrant : INTEGER
		do
			quadrant := 1
			-- print("the planet id is ")print(planet.planet_id)print("planet row and col ")print(planet.r)print(" ")print(planet.c)print("%N")
			across grid[row, col].contents is entity loop
				if entity ~ letter_p then
				--	print("the entityplanetid is ")print(entity.entity_planet_id)print(" and the planetid is ")print(planet.planet_id)print("%N")
					if entity.entity_planet_id ~ planet.planet_id then
						planet.set_quadrant (quadrant)
--						print("the entity planet id is ")print(entity.entity_planet_id)print("%N")
--						print(" afjdslj;fadkkfa;ldsajf ")print(planet.planet_id)print(" ")print(planet.quadrant)print("%N")
					end
				end
				quadrant := quadrant + 1
			end
		end

	get_planet_new_quadrant(planet: PLANET; row: INTEGER; col: INTEGER)
		local
			new_q: INTEGER
		do
			new_q := 1
			across grid[planet.r, planet.c].contents is entity loop
				if entity ~ letter_p then
					if entity.entity_planet_id ~ planet.planet_id then
						planet.set_new_quadrant (new_q)
					end
				end
				new_q := new_q + 1
			end
		end


	landed_planet: BOOLEAN
		require
			-- MUST BE AT YELLOW STAR
		do
			Result := false
			across grid[shared_info.explorer.exp_coordinates.row, shared_info.explorer.exp_coordinates.column].contents is entity loop
				if entity ~ letter_p then
					across shared_info.planet_list is planet loop
						if entity.entity_planet_id ~ planet.planet_id and planet.supports_life = true then
							Result := true
						end
					end
				end
			end

		end

	out_movement:STRING
	 	local
	 		prev_p:PLANET
		do
			create Result.make_empty
			create prev_p.make
			Result.append ("  ")
			Result.append ("  ")
		 	if shared_info.skip_explorer_coordinates ~ FALSE then
				Result.append ("[0,E]:[")
				Result.append_integer_64 (shared_info.explorer.exp_prev_coordinates.row)
				Result.append (",")
				Result.append_integer_64 (shared_info.explorer.exp_prev_coordinates.column)
				Result.append (",")
				Result.append_integer_64 (shared_info.explorer.prev_quadrant)
				Result.append ("]->[")
				Result.append_integer_64 (shared_info.explorer.exp_coordinates.row)
				Result.append (",")
				Result.append_integer_64 (shared_info.explorer.exp_coordinates.column)
				Result.append (",")
				Result.append_integer_64 (shared_info.explorer.quadrant)
				Result.append ("]")
--				Result.append ("%N")
--				Result.append ("  ")
--				Result.append ("  ")
				--Result.append ("%N")
			end
			-- shared_info.set_skip_explorer_coordinates(FALSE)

			across move_planet_list is p loop
				if(prev_p.planet_id ~ p.planet_id) then
				else
					if shared_info.skip_explorer_coordinates ~ FALSE then
						Result.append ("%N")
						Result.append ("  ")
						Result.append ("  ")
					end

					Result.append ("[")
					Result.append_integer_64 (p.planet_id)
					Result.append (",P]:[")
					Result.append_integer_64 (p.prev_r)
					Result.append (",")
					Result.append_integer_64 (p.prev_c)
					Result.append (",")
					Result.append_integer_64 (p.quadrant)
					Result.append ("]->[")
					Result.append_integer_64 (p.r)
					Result.append (",")
					Result.append_integer_64 (p.c)
					Result.append (",")
					Result.append_integer_64 (p.new_quadrant)
					Result.append ("]")
				end

				shared_info.set_skip_explorer_coordinates(FALSE)
				prev_p := p
				--print(" and move to row and column ")print(p.r)print(" ")print(p.c)print(" ")print(p.quadrant)print("%N")
			end
--			print("move planet count")
--			print(move_planet_list.count)
			move_planet_list.remove_head(move_planet_list.count )
--			print("%N")
--			print("move planet count after remove head")
--			print(move_planet_list.count)

		end

	description_out:STRING
		local
			i : INTEGER
			stat : STATIONARY
		do
			create Result.make_empty
			Result.append("%N")
			Result.append ("  ")
			Result.append ("Descriptions:")

--			across shared_info.stationary_list is stationary loop

--					Result.append("%N")
--					Result.append ("  ")
--					Result.append ("  ")
--					Result.append_character (stationary.entity)


--			end

			from
				i:=shared_info.stationary_list.upper
			until
				i=shared_info.stationary_list.lower -1
			loop
				stat := shared_info.stationary_list[i]
					Result.append("%N")
					Result.append ("  ")
					Result.append ("  [-")
					Result.append_integer_64  (stat.id)
					Result.append (",")
					Result.append_character (stat.entity)
					Result.append ("]->")
					if (stat.star_luminosity /~ 0) then
						Result.append ("Luminosity:")
						Result.append_integer_64 (stat.star_luminosity)
					end

				i:= i-1
			end
			Result.append("%N")
			Result.append ("  ")
			Result.append ("  [-")
			Result.append_integer_64  (1)
			Result.append (",")
			Result.append ("O]->")

--			Result.append ("%N")
--			Result.append ("  ")
--			Result.append ("  ")
			if shared_info.explorer.fuel > 0 then
				Result.append ("%N")
				Result.append ("  ")
				Result.append ("  ")
				Result.append(shared_info.explorer.get_description)
			end

			across shared_info.planet_list is planet loop
					Result.append("%N")
					Result.append ("  ")
					Result.append ("  ")
					Result.append (planet.get_description)

			end
		shared_info.stationary_list.remove_head(move_planet_list.count )

		end

	sector_out: STRING
		local
			string1: STRING
			string2: STRING
			row_counter: INTEGER
			column_counter: INTEGER
			contents_counter: INTEGER
			temp_sector: SECTOR
			temp_component: ENTITY_ALPHABET
			printed_symbols_counter: INTEGER
			planet : PLANET
			check_sector: SECTOR
			temp_row: INTEGER
			temp_column: INTEGER
		do
			create Result.make_empty
			create string1.make_empty
			create string2.make(7*shared_info.number_columns)
			string1.append("%N")
			string1.append ("  ")

			string1.append("Sectors:")
			create planet.make



			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
--				string1.append("    ")
--				string2.append("    ")

				from
					column_counter := 1
				until
					column_counter > shared_info.number_columns
				loop
					string1.append("%N")
					string1.append ("  ")
					string1.append ("  ")
					temp_sector:= grid[row_counter, column_counter]
				    string1.append("[")
	            	string1.append(temp_sector.print_sector_out)
	                string1.append("]")
				    string1.append("->")
					from
						contents_counter := 1
						printed_symbols_counter:=0
					until
						contents_counter > temp_sector.contents.count
					loop
						temp_component := temp_sector.contents[contents_counter]
						if attached temp_component as character then
							if contents_counter /~ 1 then
									string1.append (",")
							end
							--string1.append_character(character.item) --was 2
							if temp_component ~ create {ENTITY_ALPHABET}.make('E') then
								string1.append (shared_info.explorer.sector_out_info)
							elseif temp_component ~ create {ENTITY_ALPHABET}.make('P') then
								string1.append ("[")
								string1.append_integer_64 (temp_component.entity_planet_id)
								string1.append (",P]")
							elseif temp_component ~ create {ENTITY_ALPHABET}.make('O') then
								string1.append ("[-")
								string1.append_integer_64 (temp_component.entity_blackhole_id)
								string1.append (",O]")
							elseif temp_component ~ create {ENTITY_ALPHABET}.make('-') then
								string1.append_character(character.item)
							else
								string1.append ("[-")
								string1.append_integer_64 (temp_component.entity_stationary_id)
								string1.append (",")
								string1.append_character(character.item) --was 2
								string1.append ("]")
							end
							--string1.append (ex.sector_out_info)
						else
							string1.append("-") --was 2
						end -- if
						printed_symbols_counter:=printed_symbols_counter+1
						contents_counter := contents_counter + 1
						--string1.append("%N")
					end -- loop

					from
					until (shared_info.max_capacity - printed_symbols_counter)=0
					loop
							if printed_symbols_counter ~ 0 then
									string1.append ("")

							else
								string1.append(",") --was 2
							end
							string1.append("-") --was 2
							printed_symbols_counter:=printed_symbols_counter+1
							--string1.append("%N")

					end
					--string1.append("   ,") --was 2
					column_counter := column_counter + 1
				end -- loop
				--string1.append("%N")
--				if not (row_counter = shared_info.number_rows) then
--					--string1.prune_all_trailing ("-")
--					--string1.append("%N") --was 2
--					string1.append (" ")
--				end

				Result.append (string1.twin)
				--Result.append ("k")
				--Result.append (string2.twin)

				row_counter := row_counter + 1
				string1.wipe_out
				string2.wipe_out
			end
		end

	out: STRING
	--Returns grid in string form
	local
		string1: STRING
		string2: STRING
		row_counter: INTEGER
		column_counter: INTEGER
		contents_counter: INTEGER
		temp_sector: SECTOR
		temp_component: ENTITY_ALPHABET
		printed_symbols_counter: INTEGER
		planet : PLANET
		check_sector: SECTOR
		temp_row: INTEGER
		temp_column: INTEGER
	do
		create Result.make_empty
		create string1.make(7*shared_info.number_rows)
		create string2.make(7*shared_info.number_columns)
		string1.append("%N")
		create planet.make



		from
			row_counter := 1
		until
			row_counter > shared_info.number_rows
		loop
			string1.append("    ")
			string2.append("    ")

			from
				column_counter := 1
			until
				column_counter > shared_info.number_columns
			loop
				temp_sector:= grid[row_counter, column_counter]
			    string1.append("(")
            	string1.append(temp_sector.print_sector)
                string1.append(")")
			    string1.append("  ")
				from
					contents_counter := 1
					printed_symbols_counter:=0
				until
					contents_counter > temp_sector.contents.count
				loop
					temp_component := temp_sector.contents[contents_counter]
					if attached temp_component as character then
--						print("the value of character is ")
--						print(character)
--						if character ~ letter_planet then
--							planet.set_sector_index (contents_counter - 1)
----							temp_row :=  gen.rchoose (1, shared_info.number_rows)
----							temp_column := gen.rchoose (1, shared_info.number_columns)
----							check_sector := grid[temp_row,temp_column]
----							print("the value of row counter is ")
----							print(row_counter)


----							grid[row_counter, column_counter].contents.prune(character)
----							grid[temp_row, temp_column].contents.force (character)

------							grid[last_coord.row,last_coord.column].contents.prune (a_explorer)
------							grid[player_coord.row,player_coord.column].contents.force (a_explorer)
--						end
						string2.append_character(character.item)
					else
						string2.append("-")
					end -- if
					printed_symbols_counter:=printed_symbols_counter+1
					contents_counter := contents_counter + 1
				end -- loop

				from
				until (shared_info.max_capacity - printed_symbols_counter)=0
				loop
						string2.append("-")
						printed_symbols_counter:=printed_symbols_counter+1

				end
				string2.append("   ")
				column_counter := column_counter + 1
			end -- loop
			string1.append("%N")
			if not (row_counter = shared_info.number_rows) then
				string2.append("%N")
			end

			Result.append (string1.twin)
			Result.append (string2.twin)

			row_counter := row_counter + 1
			string1.wipe_out
			string2.wipe_out
		end
	end


end
