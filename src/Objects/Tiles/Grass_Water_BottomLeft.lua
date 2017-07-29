Tile = require(_G.Everest.Objects.Tile)

Grass_Water_BottomLeft = {}
Grass_Water_BottomLeft.__index = Grass_Water_BottomLeft
setmetatable(Grass_Water_BottomLeft, Tile)

Tile.Tiles[4] = Grass_Water_BottomLeft

function Grass_Water_BottomLeft.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_BottomLeft)
	
	new:SetImage(165444704)	
	
	return new
end

return Grass_Water_BottomLeft