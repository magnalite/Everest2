Tile = require(_G.Everest.Objects.Tile)

Grass_Water_TopLeft = {}
Grass_Water_TopLeft.__index = Grass_Water_TopLeft
setmetatable(Grass_Water_TopLeft, Tile)

Tile.Tiles[2] = Grass_Water_TopLeft

function Grass_Water_TopLeft.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_TopLeft)
	
	new:SetImage(165444722)	
	
	return new
end

return Grass_Water_TopLeft