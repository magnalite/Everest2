Item = require(_G.Everest.Objects.Item)

Log = {}
Log.__index = Log
setmetatable(Log, Item)

Item.Items[0] = Log
Item.Items.Log = Log

function Log.new(inventory)
	local new = Item.new("Log", inventory)
	setmetatable(new, Log)
	
	new:SetEntityId("Log")
	new:SetRenderImageId(167229011)
	
	return new
end

function Log:GetInfo()
	return "Useful for burning."
end

return Log