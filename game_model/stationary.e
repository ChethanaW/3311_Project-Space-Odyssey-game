note
	description: "Summary description for {STATIONARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATIONARY

feature -- common features
	ID: INTEGER -- id of the stationary

	star_luminosity: INTEGER  -- luminosity of a star

	row: INTEGER

	column: INTEGER
	entity:CHARACTER
feature {SHARED_INFORMATION, GALAXY}-- commands

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

	set_entity(char: CHARACTER)
		do
			entity:= char
		end

end
