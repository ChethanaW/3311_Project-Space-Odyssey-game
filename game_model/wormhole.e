note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

	inherit
		STATIONARY

--		rename
--			make as array_make
--		end


create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

			entity := 'W'
		end

feature
	wormhole_id: INTEGER


feature --commands

feature --queries


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
