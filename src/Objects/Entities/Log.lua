ItemEntity  = require(_G.Everest.Objects.ItemEntity)
LogItem = require(_G.Everest.Objects.Items.Log)

Log = {}
Log.__index = Log
setmetatable(Log, ItemEntity)

function Log.new(position)
	local new = ItemEntity.new(position)
	setmetatable(new, Log)	
	
	new:SetImage(167229011, 167229023, Vector2.new(), Vector2.new())
	new:SetType("Log")	
	
	return new
end

function Log:CreateItem(inventory)
	return LogItem.new(inventory)
end

function Log.newReplication(data)
	local newlog = Log.new(Vector2.new(data.PosX, data.PosY))
	if data.ImpulseDir and data.ImpulsePower then
		newlog:Impulse(data.ImpulseDir, data.ImpulsePower)
	end
	
	return newlog
end

return Log