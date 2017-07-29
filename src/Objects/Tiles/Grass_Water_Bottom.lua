Tile = require(_G.Everest.Objects.Tile)

Grass_Water_Bottom = {}
Grass_Water_Bottom.__index = Grass_Water_Bottom
setmetatable(Grass_Water_Bottom, Tile)

Tile.Tiles[3] = Grass_Water_Bottom

function Grass_Water_Bottom.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_Bottom)
	
	new:SetImage(165444687)	
	
	return new
end


return Grass_Water_Bottom