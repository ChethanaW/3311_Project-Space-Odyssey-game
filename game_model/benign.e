note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN

	inherit
		MOVABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create letter.make ('B')
			create entity_alphabet.make('B')
			create sector_out_info.make_empty
			create death_message.make_empty
			is_dead:= FALSE
			fuel:= 3
			max_fuel:= 3
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
