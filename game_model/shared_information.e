note
	description: "[
		Common variables such as thresholds of movable entities 
		and constants such as number of stationary items for generation of the board.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_INFORMATION

create {SHARED_INFORMATION_ACCESS}
	make

feature{NONE}
	make
		do
			create planet_list.make_empty
			create planet_entity_list.make_empty
			create stationary_list.make_empty
			planet_id := 1

			create explorer.make
			skip_explorer_coordinates := FALSE
			stationary_id:=1

			planet_supports_life:= FALSE 

			death_message_status := FALSE -- default: no death message
			create death_message.make_empty

			-- for movables
			create movables_list.make_empty
			create movables_entity_list.make_empty
			movables_id := 1



		end

feature

	number_rows: INTEGER = 5
        	-- The number of rows in the grid

	number_columns: INTEGER = 5
        	-- The number of columns in the  grid

	number_of_stationary_items: INTEGER = 10
			-- The number of stationary_items in the grid

	asteroid_threshold: INTEGER
		-- used to determine the chance of an asteroid being put in a location
		attribute
			Result := 10
		end

	janitaur_threshold: INTEGER
		-- used to determine the chance of a janitaur being put in a location
		attribute
			Result := 20
		end

	malevolent_threshold: INTEGER
		-- used to determine the chance of a malevolent being put in a location
		attribute
			Result := 30
		end

	benign_threshold: INTEGER
		-- used to determine the chance of a benign being put in a location
		attribute
			Result := 40
		end

    planet_threshold: INTEGER
		-- used to determine the chance of a planet being put in a location
		attribute
			Result := 50
		end

	max_capacity: INTEGER = 4
		 -- max number of objects that can be stored in a location

	planet_list : ARRAY[PLANET]

	planet_entity_list: ARRAY[ENTITY_ALPHABET]


	stationary_list: ARRAY[STATIONARY]

	stationary_id: INTEGER

	planet_id : INTEGER

	explorer: EXPLORER


	skip_explorer_coordinates: BOOLEAN

	planet_supports_life: BOOLEAN

	death_message_status: BOOLEAN

	death_message: STRING

	--movables
	movables_list : ARRAY[MOVABLE]

	movables_entity_list: ARRAY[ENTITY_ALPHABET]

	movables_id: INTEGER



feature --commands
	test(a_threshold: INTEGER; j_threshold: INTEGER; m_threshold: INTEGER; b_threshold: INTEGER; p_threshold: INTEGER)
		--sets threshold values
		require
			valid_threshold:
				0 < a_threshold and a_threshold <= j_threshold and j_threshold <= m_threshold
				and m_threshold <= b_threshold and b_threshold <= p_threshold and p_threshold <= 101
		do
				set_asteroid_threshold (a_threshold)
				set_benign_threshold (b_threshold)
				set_janitaur_threshold (j_threshold)
				set_malevolent_threshold (m_threshold)
				set_planet_threshold (p_threshold)
		end

	set_planet_supports_life(status: BOOLEAN)
		do
			planet_supports_life:= status
		end

	set_skip_explorer_coordinates(b: BOOLEAN)
		do
			skip_explorer_coordinates := b
		end

	set_malevolent_threshold(threshhold:INTEGER)
		do
			malevolent_threshold:=threshhold
		end

	set_janitaur_threshold(threshhold:INTEGER)
		do
			janitaur_threshold:=threshhold
		end

	set_asteroid_threshold(threshhold:INTEGER)
		do
			asteroid_threshold:=threshhold
		end
	set_planet_threshold(threshhold:INTEGER)
		do
			planet_threshold:=threshhold
		end

	set_benign_threshold(threshhold:INTEGER)
		do
			benign_threshold:=threshhold
		end

	shared_set_planet_id(id : INTEGER)
		do
			planet_id := id
		end

	shared_set_movables_id(id : INTEGER)
		do
			movables_id := id
		end




feature --queries




	get_error_messages(error_num: INTEGER): STRING
		do
			create Result.make_empty
			inspect error_num
			when 1 then  -- used by abort, land, liftoff, move, pass, status, wormhole commands
				Result := "Negative on that request: no mission in progress"
			when 2 then  -- used by land
				Result := "Negative on that request:already landed on a planet at Sector:" -- need to append X:Y to the end
			when 3 then  -- used by land
				Result := "Negative on that request:no yellow dwarf at Sector:" -- need to append X:Y to the end
			when 4 then  -- used by land
				Result := "Negative on that request:no planets at Sector:" -- need to append X:Y to the end
			when 5 then  -- used by land
				Result := "Negative on that request:no unvisited attached planet at Sector:"-- need to append X:Y to the end
			when 6 then  -- used by liftoff
				Result := "Negative on that request:you are not on a planet at Sector:"  -- need to append X:Y to the end
			when 7 then  -- used by move, wormhole
				Result := "Negative on that request:you are currently landed at Sector"  -- need to append X:Y to the end
			when 8 then  -- used by move
				Result := "Cannot transfer to new location as it is full."
			when 9 then  -- used by play, test
				Result := "To start a new mission, please abort the current one first."
			when 10 then  -- used by test
				Result := "Thresholds should be non-decreasing order."
			when 11 then  -- used by wormhole
				Result := "Explorer couldn't find wormhole at Sector:"  -- need to append X:Y to the end
			when 12 then -- devoured by black hole then
				Result := "Explorer got devoured by blackhole (id: -1) at Sector:3:3"
			else
				Result := "error with no description- something went wrong "
			end

		end

	get_death_message:STRING
		do
			Create Result.make_empty
			Result := death_message
		end

end
