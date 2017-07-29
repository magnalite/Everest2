Tile = require(_G.Everest.Objects.Tile)

WoodenFloor = {}
WoodenFloor.__index = WoodenFloor
setmetatable(WoodenFloor, Tile)

Tile.Tiles[14] = WoodenFloor

function WoodenFloor.new(position)
	local new = Tile.new(position, true)
	setmetatable(new, WoodenFloor)
	
	new:SetImage(170302918)	
	
	return new
end

return WoodenFloor