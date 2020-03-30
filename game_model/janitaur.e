note
	description: "Summary description for {JANITAUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR

	inherit
		MOVABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create letter.make ('J')
			create entity_alphabet.make('J')
			create sector_out_info.make_empty
			create death_message.make_empty
			is_dead:= FALSE
			fuel:= 5
			max_fuel:= 5
			load:= 0
			max_load:= 2
			actions_left_until_reproduction:= 2
			clone_when_quadrant_not_full:= FALSE
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
