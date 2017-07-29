CameraHandler  = require(_G.Everest.Handlers.CameraHandler)
ToolTipHandler = require(_G.Everest.Handlers.ToolTipHandler)
BaseObject     = require(_G.Everest.Objects.BaseObject)

Inventory = {}
Inventory.__index = Inventory
setmetatable(Inventory, BaseObject)

function Inventory.new(size, items)
	local new = BaseObject.new()
	setmetatable(new, Inventory)
	
	new.Slots = items or {}
	new:SetSize(size)
	
	return new
end

function Inventory:SetSize(size)
	self.Size = size or 10
end

function Inventory:SetSlot(slotNum, item)
	self.Slots[slotNum] = item	
	
	if self.container then
		self:Hide()
		self:Display()
	end
end

function Inventory:AddItem(item)
	for i = 1, self.Size do	
		if not self.Slots[i] then
			self:SetSlot(i, item)
			break
		end
	end
end

function Inventory:RemoveItem(item)
	for index, itemInInvent in pairs(self.Slots) do
		if itemInInvent == item then
			self:SetSlot(index, nil)
			break
		end
	end
end

function Inventory:AttemptAdd(item)
	if not self:IsFull() then
		self:AddItem(item)
		return true
	end
end

function Inventory:IsFull()
	return #self.Slots >= self:GetSize()
end

function Inventory:Display()
	self.container                        = Instance.new("ScrollingFrame", CameraHandler:GetContainer().Parent)
	self.container.Size                   = UDim2.new(0.8, 0, 0.7, 0)
	self.container.Position               = UDim2.new(0.1, 0, 0.15, 0)
	self.container.BackgroundTransparency = 0.7
	self.container.BorderSizePixel        = 5
	self.container.ZIndex                 = 8
	
	local item = Instance.new("ImageButton")
	item.Size = UDim2.new(0,32,0,32)
	item.BackgroundTransparency = 1
	item.ZIndex = 8

	local width = math.floor(self.container.AbsoluteSize.X/32)
	
	for i, v in pairs(self.Slots) do
		local dispItem = item:Clone()
		dispItem.Image = "rbxassetid://" .. v:GetRenderImageId()
		dispItem.Position = UDim2.new(0,(i-1)%width*32,0,math.floor((i-1)/width)*32)
		dispItem.Parent = self.container
		
		dispItem.MouseButton1Down:connect(function(x,y)
			ToolTipHandler:ProvideItemOptions(v:GetOptions(), UDim2.new(0,x,0,y), v)
		end)
	end
end

function Inventory:Hide()
	if self.container then
		self.container:Destroy()
		self.container = nil
	end
end

function Inventory:ToggleDisplay()
	if self.container then
		self:Hide()
	else
		self:Display()
	end
end

function Inventory:GetSize()
	return self.Size
end

function Inventory:GetSlot(slotNum)
	return self.Slots[slotNum]
end

return Inventory