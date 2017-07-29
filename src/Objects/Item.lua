BaseObject          = require(_G.Everest.Objects.BaseObject)
CameraHandler       = require(_G.Everest.Handlers.CameraHandler)
NotificationHandler = require(_G.Everest.Handlers.NotificationHandler)

Item = {}
Item.__index = Item
setmetatable(Item, BaseObject)

Item.Items = {}

function Item.new(name, inventory)
	local new = BaseObject.new()
	setmetatable(new, Item)
	
	new.name = name
	new.Inventory = inventory
	
	return new
end

function Item:SetQuantity(quantity)
	self.Quantity = quantity
end

function Item:SetEntityId(id)
	self.EntityId = id
end

function Item:SetRenderImageId(id)
	self.RenderImageId = id
end

function Item:SetInventory(inventory)
	self.Inventory = inventory
end

function Item:OptionChosen(option)
end

function Item:StartPlacingEntity(entity, solid, walkable)
	_G.localPlayer:GetInventory():Hide()
	spawn(function()
		local mouse = game.Players.LocalPlayer:GetMouse()
		local click = false
		
		game:GetService("UserInputService").InputBegan:connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				click = true
			end
		end)
	
		while wait()	do
			local pos = _G.localPlayer.Position + (Vector2.new(mouse.X - (mouse.ViewSizeX*.5), -(mouse.Y - (mouse.ViewSizeY*.5)))/_G.TileSize)
			local roundpos = Vector2.new(math.floor(pos.x), math.floor(pos.y))
			entity:SetPosition(roundpos)
			if click then
				if not _G.Map.Tiles[roundpos.x][roundpos.y].Solid and _G.Map.Tiles[roundpos.x][roundpos.y].Walkable then
					_G.Map.Tiles[roundpos.x][roundpos.y].Solid = solid
					_G.Map.Tiles[roundpos.x][roundpos.y].Walkable = walkable
					_G.Map.Tiles[roundpos.x][roundpos.y].HasEntity = true
					if self.Inventory then self.Inventory:RemoveItem(self) end
					break
				elseif _G.Map.Tiles[roundpos.x][roundpos.y].HasEntity then
					NotificationHandler.NewNotification("Please remove the entity that is in the way!")
					click = false
				else
					NotificationHandler.NewNotification("You can only place this on walkable areas!")
					click = false
				end
			end
		end
	end)
end

function Item:StartPlacingTile(tile)
	_G.localPlayer:GetInventory():Hide()
	
	spawn(function()
		local mouse = game.Players.LocalPlayer:GetMouse()
		local click = false
		
		game:GetService("UserInputService").InputBegan:connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				click = true
			end
		end)
	
		local oldtileimage, oldpos
		
		while wait()	do
			local pos = _G.localPlayer.Position + (Vector2.new(mouse.X - (mouse.ViewSizeX*.5), -(mouse.Y - (mouse.ViewSizeY*.5)))/_G.TileSize)
			local roundpos = Vector2.new(math.floor(pos.x), math.ceil(pos.y))
			if oldtileimage then
				_G.Map.Tiles[oldpos.x][oldpos.y]:SetImage(oldtileimage)
			end
			oldtileimage = _G.Map.Tiles[roundpos.x][roundpos.y]:GetImage()
			oldpos = roundpos
			tile.Position = roundpos
			_G.Map.Tiles[roundpos.x][roundpos.y]:SetImage(tile:GetImage())
			if click then
				if not _G.Map.Tiles[roundpos.x][roundpos.y].Solid and _G.Map.Tiles[roundpos.x][roundpos.y].Walkable then
					_G.Map.Tiles[roundpos.x][roundpos.y] = tile
					tile:Render(0.01)
					if self.Inventory then self.Inventory:RemoveItem(self) end
					break
				else
					NotificationHandler.NewNotification("You can only place this on walkable areas!")
					click = false
				end
			end
		end
	end)
end

function Item:GetQuantity()
	return self.Quantity
end

function Item:GetEntityId()
	if not self.EntityId then
		error("Attempt to get entity id from base object!")
	else
		return self.EntityId
	end
end

function Item:GetRenderImageId()
	return self.RenderImageId
end

function Item:GetOptions()
	return {}
end

function Item:GetInfo()
	return "No information on this item."
end

return Item