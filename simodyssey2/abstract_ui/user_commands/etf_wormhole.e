note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_WORMHOLE
inherit
	ETF_WORMHOLE_INTERFACE
create
	make
feature -- command
	wormhole
    	do
			-- perform some update on the model state
			model.wormhole
			etf_cmd_container.on_change.notify ([Current])
    	end

end
