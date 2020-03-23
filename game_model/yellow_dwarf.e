note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF

	inherit
		STATIONARY
create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
				entity:= 'Y'
		end

feature -- Access

feature -- Measurement


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
