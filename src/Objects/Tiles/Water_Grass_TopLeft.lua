Tile = require(_G.Everest.Objects.Tile)

Water_Grass_TopLeft = {}
Water_Grass_TopLeft.__index = Water_Grass_TopLeft
setmetatable(Water_Grass_TopLeft, Tile)

Tile.Tiles[9] = Water_Grass_TopLeft

function Water_Grass_TopLeft.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Water_Grass_TopLeft)
	
	new:SetImage(165459134)	
	
	return new
end

return Water_Grass_TopLeft