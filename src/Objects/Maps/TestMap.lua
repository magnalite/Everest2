Map           = require(_G.Everest.Objects.Map)
Tile          = require(_G.Everest.Objects.Tile)

for _,v in pairs (_G.Everest.Objects.Tiles:GetChildren()) do
	require(v)
end



local timer = tick()
local objectCount = #_G.Objects

data = {}
data[1]   = {13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 }
data[0]   = {13 ,13 ,2  ,5  ,5  ,5  ,5  ,5  ,5  ,6  ,13 ,13 }
data[-1]  = {13 ,2  ,11 ,14 ,14 ,14 ,14 ,14 ,14 ,12 ,6  ,13  }
data[-2]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,7  ,13  }
data[-3]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,12 ,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6 }
data[-4]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,0 ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7 }
data[-5]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,9  ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,8  }
data[-6]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,7  ,13  }
data[-7]  = {13 ,1  ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,14 ,7  ,13  }
data[-8]  = {13 ,4  ,10 ,14 ,14 ,14 ,14 ,14 ,14 ,9  ,8  ,13  }
data[-9]  = {13 ,13 ,4  ,3  ,3  ,3  ,3  ,3  ,3  ,8  ,13 ,13 }
data[-10] = {13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 ,13 }


local map = Map.new()
for x = -30, 30 do
	if x%100 == 0 then
		print(x)
		wait()
	end
	for y = -30, 30 do
		map:SetTile(Vector2.new(x,y), Tile.Tiles[0].new(Vector2.new(x,y)))
	end
end

--for y, ytab in pairs(data) do
--	for x, tileId in pairs(ytab) do
--		map:SetTile(Vector2.new(x,y), Tile.Tiles[tileId].new(Vector2.new(x,y)))
--	end
--end

print("Map generation took " ..math.floor((tick() - timer) * 100)/100 .. " seconds and generated " .. #_G.Objects - objectCount .." objects")

return map