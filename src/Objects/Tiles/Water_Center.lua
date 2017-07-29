Tile = require(_G.Everest.Objects.Tile)

Water_Center = {}
Water_Center.__index = Water_Center
setmetatable(Water_Center, Tile)

Tile.Tiles[13] = Water_Center

function Water_Center.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Water_Center)
	
	new:SetImage(165480864)	
	
	return new
end

return Water_Center