note
    description: "[
       Alphabet allowed to appear on the galaxy board.
    ]"
    author: "Kevin Banh"
    date: "April 30, 2019"
    revision: "1"

class
    ENTITY_ALPHABET

inherit
    ANY
        redefine
            out,
            is_equal
        end

create
    make

feature -- Constructor

    make (a_char: CHARACTER)
        do
            item := a_char
            --create planet.make
            -- entity_explorer_isdead := 0
        end

feature -- Attributes

    item: CHARACTER
    entity_planet_id: INTEGER
    entity_wormhole_id: INTEGER
    entity_yellow_dwarf_id : INTEGER

    entity_blue_giant_id: INTEGER
    -- entity_explorer_isdead: INTEGER

    entity_blackhole_id: INTEGER = 1
    entity_stationary_id: INTEGER

    --planet: PLANET


feature -- Query

    out: STRING
            -- Return string representation of alphabet.
        do
            Result := item.out
        end

    is_equal(other : ENTITY_ALPHABET): BOOLEAN
        do
            Result := current.item.is_equal (other.item)
        end

    is_stationary: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           end
        end

    is_star : BOOLEAN
    	do
    		if item = 'Y' or item = '*' then
    			Result := True
    		end
    	end

    represents_planet_id(planet_id: INTEGER)--; p: PLANET)
    	do
    		entity_planet_id := planet_id
    		--planet := p

    	end

    represents_wormhole_id(wormhole_id: INTEGER)
    	do
    		entity_wormhole_id := wormhole_id
    		--planet := p

    	end

    represents_yellow_dwarf_id(yellow_dwarf_id: INTEGER)
    	do
    		entity_yellow_dwarf_id := yellow_dwarf_id
    		--planet := p

    	end

    represents_blue_giant_id(blue_giant_id: INTEGER)--; p: PLANET)
    	do
    		--entity_blue_giant_id := blue_giant_id
    		--planet := p

    	end

    represents_stationary_id(stat_id: INTEGER)--; p: PLANET)
    	do
    		entity_stationary_id := stat_id
    		--planet := p

    	end

--    get_planet_associated: PLANET
--    	do
--    		Result := planet
--    	end



invariant
    allowable_symbols:
    	item = 'E' or item = 'P' or item = 'A' or item = 'M' or  item = 'J' or item = 'O' or item = 'W' or item = 'Y' or item = '*' or item='B'  or item = '-'
   
end
