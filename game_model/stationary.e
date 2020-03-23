note
	description: "Summary description for {STATIONARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATIONARY

feature -- common features
	ID: INTEGER

	star_luminosity: INTEGER

	row: INTEGER

	column: INTEGER
	entity:CHARACTER
feature -- commands

	set_id(stationary_id: INTEGER)
		do
			ID:= stationary_id
		end

	set_row(r: INTEGER)
		do
			row:= r
		end

	set_column(c: INTEGER)
		do
			column :=c
		end

	set_luminosity(lum: INTEGER)
		do
			star_luminosity:=lum
		end
feature -- query




feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
