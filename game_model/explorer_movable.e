note
	description: "Summary description for {EXPLORER_MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER_MOVABLE

	inherit
		MOVABLE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create letter.make ('E')
			yellow_dwarf := false
			has_checked_for_life := false
			create entity_alphabet.make('E')
			visited := false
			create sector_out_info.make_empty
			create death_message.make_empty
			is_dead := FALSE
			attacked:= FALSE
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
