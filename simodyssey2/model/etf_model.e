note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		local
        	sa: SHARED_INFORMATION_ACCESS -- singleton
		do
			--integer
			i := 0
			j := 0
         	play_check:=0
         	abort_flag := 0
         	land_flag := 0   -----------######### may be we can put it in explorer...ikr lets seee
         	blackhole_output := 0  --------########## may be this tooo better if we can move it to explorer
         	trying_to_land := 0

         	--boolean
         	movement_out := TRUE
         	entity_movement := FALSE
         	fuel_check_game_over:= false
         	passing := false
         	error:= FALSE

			--string
			create mode.make_empty
			mode := "start"
			create board_print.make_empty
			create cmd_name.make_empty
			cmd_name:= "none"
			create error_message.make_empty

			--other
         --	create explorer.make
         	create planet.make
         	create g.dummy_galaxy_make
         	info := sa.shared_info

         end

feature -- model attributes

	--integer
	i : INTEGER
	j : INTEGER
	play_check : INTEGER
    abort_flag : INTEGER
    land_flag : INTEGER
    blackhole_output: INTEGER
    trying_to_land: INTEGER

    --boolean
	fuel_check_game_over: BOOLEAN
	movement_out: BOOLEAN
	entity_movement: BOOLEAN
    exp_move_status: BOOLEAN ----------------------##########not initialized --may be there is a better way to use it
    passing: BOOLEAN
    error: BOOLEAN

    --string
    board_print : STRING
    mode: STRING  -- only start, abort, play, test
    cmd_name: STRING
    error_message: STRING

    --other
	g : GALAXY -- has access to shared information
 	info : SHARED_INFORMATION
	-- explorer : EXPLORER
    planet: PLANET



feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	abort
			-- Ends the game prematurely. Only valid when game is in progress
		do
			cmd_name:= "abort"

			error:= FALSE
			entity_movement:= FALSE

			--empty all lists created at the beginning of pplay and abort
			info.planet_entity_list.make_empty
			info.planet_list.make_empty
			info.stationary_list.make_empty

			info.explorer.set_is_dead(false)
			fuel_check_game_over := false
			info.shared_set_planet_id (1)

			abort_flag := 1
			play_check := 0
			blackhole_output := 0

			if mode ~ "start" or mode ~ "abort" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			end
			mode := "abort"
			update_status
		end

	land
			-- Lands the explorer on a planet to check for life on planet.
		do
			cmd_name:="land"
			error:= FALSE

			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			else
				-- things to do if land is used at a valid time
				trying_to_land := 1
				if g.landed_planet = true then
					land_flag := 1
				end
			--	g.ex.update_landed_status(TRUE)
				info.set_skip_explorer_coordinates(TRUE)
				info.explorer.update_landed_status (true)  -------###### double check if this is correct the case if no life we still land or not
				g.move_planets
			end

			update_status

		end

	liftoff
			-- Lifts the explorer off a planet.
		do
		--	cmd_name:="liftoff"
			error:= FALSE

			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			else
				-- things to do if liftoff is used at a valid time
				if info.explorer.landed then -- if landed last move, then liftoff is valid
					cmd_name := "liftoff"
					info.set_skip_explorer_coordinates(TRUE)
					entity_movement:=TRUE
					g.move_planets
					info.explorer.update_landed_status (false) -- lifting off, not landed anymore
				else
					error:=TRUE
					error_message:=info.get_error_messages(6)
				end
				--entity_movement:= TRUE -- bcs planets and others move without the explorer
				--g.move_planets
			end

			update_status
		end

	move(a_dir : INTEGER)
			-- Moves the explorer in a given direction.
		do
			cmd_name:="move"
			error:= FALSE

			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			else
				-- things to do if move is used at a valid time
				entity_movement:= TRUE -- bcs almost all movables move
				exp_move_status:= info.explorer.move_expl (a_dir, g)
				if exp_move_status ~ FALSE then
					error:= TRUE
					error_message:= info.get_error_messages (8)
				elseif info.explorer.is_dead ~ TRUE then
					error:=TRUE
					error_message:= info.get_error_messages (12)
				end
				g.move_planets
	 			board_print := g.out
	 			-- print(explorer.fuel)
	 			if g.fuel_check then -- out of fuel
	 				fuel_check_game_over := true
	 			end
			end

 			update_status

		end

	pass
			-- Lets the explorer pass a turn.
		do
			cmd_name:="pass"
			error:= FALSE

			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			else
				-- things to do if pass is used at a valid time
				info.set_skip_explorer_coordinates(TRUE)
				entity_movement:= TRUE -- bcs planets and others move without the explorer
				g.move_planets
			end

			update_status
		end

	play
			-- Starts a new game using test(3,5,7,15,30)

		do
			cmd_name:="play"
			error:= FALSE
			movement_out := FALSE
	 		entity_movement:= FALSE -- nothing moves
			play_check:= play_check + 1


			if mode ~"abort" or mode ~ "start" then
				--play_check:= play_check + 1
				mode:= "play"
				--g := new_galaxy(3,5,7,15,30)
				info.test(3,5,7,15,30)
         		create g.make

				board_print := g.out

			else
				error:= TRUE
				error_message:= info.get_error_messages (9)
			end

			update_status


		end

	status
			-- Displays explorer's energy, life and sector.
		do
			cmd_name:="status"
			error:= FALSE
			update_status
			entity_movement:= FALSE --nothing moves


			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)

			else
				-- things to do if status is used at a valid time


			end
			--print("here2")

		end

	test (a_threshold:INTEGER ; j_threshold:INTEGER; m_threshold:INTEGER;b_threshold:INTEGER ; p_threshold:INTEGER)
			-- Starts a new game in test mode provided game test(a_threshold:THRESHOLD ; j_threshold:THRESHOLD; m_threshold:THRESHOLD;b_threshold:THRESHOLD ; p_threshold:THRESHOLD)
		do
			cmd_name:= "test"
			error:= FALSE
			movement_out:= FALSE
			entity_movement:= FALSE -- nothing moves
			play_check:= play_check + 1
			if mode ~ "abort" or mode ~ "start" then

				mode:= "test"
				g := new_galaxy(a_threshold,j_threshold,m_threshold,b_threshold,p_threshold)
				board_print := g.out
			else
				error:= TRUE
				error_message:= info.get_error_messages (9)
			end

			update_status

		end

	wormhole
			-- Tunnels the explorer to a random sector (first open quadrant).
		local
			entity: ENTITY_ALPHABET
		do
			create entity.make('E')
			cmd_name:="wormhole"
			error:= FALSE

			if mode ~ "abort" or mode ~ "start" then
				error:= TRUE
				error_message:= info.get_error_messages (1)
			elseif info.explorer.landed ~ TRUE then
				error:= TRUE
				error_message:= info.get_error_messages(7)
			else
				exp_move_status:= g.check_for_wormhole
				--g.wormhole_move(entity)
				if exp_move_status ~ FALSE then
					error:=TRUE
					error_message:= info.get_error_messages(11)
				else

				-- things to do if wormhole is used at a valid time
				--if wormhole present
					cmd_name := "move" -- due to similar functionality same """update_status"""
				--  explore randomly moves
				g.wormhole_move(entity)
				--  planet moves just as if move command was entered
				g.move_planets
				end


			end

			update_status
		end

	new_galaxy(a_threshold:INTEGER ; j_threshold:INTEGER; m_threshold:INTEGER;b_threshold:INTEGER ; p_threshold:INTEGER): GALAXY
			-- to generate new galaxy as required from play and test command
		local
			l_g : GALAXY
		do
			info.test(a_threshold,j_threshold,m_threshold, b_threshold, p_threshold)
			create l_g.make
			Result := l_g
		end

	update_status
		do
			if mode ~ "start" or mode ~ "abort" then
				if cmd_name /~ "play" or cmd_name /~ "test" then
					j:= j+1
				else
					i:=i+1
					j:=0
				end
			else
				if cmd_name ~ "move" or cmd_name ~ "pass" or ( cmd_name ~ mode and play_check ~1 ) then
					i:= i+1
					j:= 0
				else
					j:= j+1
				end
			end
--			print("mode name i j")
--			print("%N")
--			print(mode)print("  ") print(cmd_name)print("  ") print(i) print("  ")print(j)
--			print("%N")
		end


feature -- queries
	out : STRING
		do

			create Result.make_from_string ("  ")
			Result.append ("state:")
			Result.append (i.out)
			Result.append (".")
			Result.append (j.out)

			if cmd_name ~ "none" then
				Result.append (", ok")
				Result.append ("%N")
				Result.append ("  ")
				Result.append ("Welcome! Try test(3,5,7,15,30)")
			else

				if error then --if error
					if mode ~ "test" or mode ~ "play" then
						Result.append (", mode:")
						Result.append (mode)
						Result.append (", error")
						Result.append ("%N")
						Result.append ("  ")
						Result.append (error_message)
						if cmd_name ~ "wormhole" then
							Result.append_integer_64(info.explorer.exp_coordinates.row)
							Result.append(":")
							Result.append_integer_64(info.explorer.exp_coordinates.column)
						end
					else
						Result.append (", error")
						Result.append ("%N")
						Result.append ("  ")
						Result.append (error_message)
					end
				else --if no error
					if mode /~ "abort" then
						Result.append (", mode:")
						Result.append (mode)
					end
					Result.append (", ok")
					Result.append ("%N")
					Result.append ("  ")


					if cmd_name ~ "abort" or cmd_name ~ "status" then
						if cmd_name ~ "abort" then
							Result.append ("Mission aborted. Try test(3,5,7,15,30)")
						elseif cmd_name ~ "status" then
							-- if explorer not landed
								--Result.append ("Explorer status report:Travelling at cruise speed at [") + X + Result.append(",") +Y + Result.append(",") + Z +Result.append("]")
								--Result.append ("Life units left:" + V + Result.append(", Fuel units left:") + W

							--if explorer landed
								--Result.append ("Explorer status report:Stationary on planet surface at [") + X + Result.append(",") +Y + Result.append(",") + Z +Result.append("]")
								--Result.append ("Life units left:" + V + Result.append(", Fuel units left:") + W
						end

					else
						if cmd_name ~ "liftoff" then
							Result.append ("Explorer has lifted off from planet at Sector:")
							Result.append_integer_64(info.explorer.exp_coordinates.row)
							Result.append(":")
							Result.append_integer_64(info.explorer.exp_coordinates.column)
							-- add the X:Y
							Result.append ("%N")
							Result.append ("  ")


						elseif cmd_name ~ "land" then
							if land_flag ~ 1 then--if life was found on the planet
								Result.append ("Tranquility base here - we've got a life!")
							else-- if life is not found
								Result.append ("Explorer found no life as we know it at Sector:")
								Result.append_integer_64(info.explorer.exp_coordinates.row)
								Result.append(":")
								Result.append_integer_64(info.explorer.exp_coordinates.column)
								Result.append ("%N")
								Result.append ("  ")
							end
						end

						if cmd_name ~ "play" or cmd_name ~ "test" then
							Result.append("Movement:none")
						else
							Result.append("Movement:")
							Result.append("%N")
							Result.append(g.out_movement)
						end

						if mode ~ "test" then
							Result.append (g.sector_out)
							Result.append (g.description_out)
							Result.append ("%N")
							Result.append ("  Deaths This Turn:")
							Result.append (info.explorer.death_message)
						end

						Result.append(g.out)
					end
				end -- if for error check
			end -- if for start check

		end

end




