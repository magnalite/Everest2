CameraHandler  = require(_G.Everest.Handlers.CameraHandler)
Item           = require(_G.Everest.Objects.Item)

for _, v in pairs(_G.Everest.Objects.Items:GetChildren()) do
	require(v)
end


CraftingHandler = {}
CraftingHandler.__index = CraftingHandler

CraftingHandler.Recipes = {
	{ItemsRequired = {Log = 1}, WorkplaceRequired = {}, Output = {Plank = 2}},
	{ItemsRequired = {Plank = 10}, WorkplaceRequired = {}, Output = {WoodenWall = 1}},
	{ItemsRequired = {Plank = 4}, WorkplaceRequired = {}, Output = {WoodenFloor = 1}},
	{ItemsRequired = {Plank = 2}, WorkplaceRequired = {}, Output = {Torch = 1}},
	}

function CraftingHandler.PerformCraft(recipe, inventory)
	local neededItems = recipe.ItemsRequired
	
	for itemNeeded, amount in pairs(neededItems) do
		local removed = 0
		for inventorySlot, item in pairs(inventory.Slots) do
			if item.name == itemNeeded then
				inventory:SetSlot(inventorySlot, nil)
				removed = removed + 1
			end
			if removed == amount then
				break
			end
		end
		if removed ~= amount then
			warn("Did not remove enough items for craft! (I'm sorry for the lost items :c)")
		end
	end
	
	local outputItems = recipe.Output
	
	for item, amount in pairs(outputItems) do
		for i = 1, amount do
			inventory:AttemptAdd(Item.Items[item].new(inventory))
		end
	end
end

function CraftingHandler.AttemptCraft(recipe, inventory)
	local neededItems = recipe.ItemsRequired
	
	for itemNeeded, amount in pairs(neededItems) do
		local removed = 0
		for inventorySlot, item in pairs(inventory.Slots) do
			if item.name == itemNeeded then
				removed = removed + 1
			end
			if removed == amount then
				break
			end
		end
		if removed ~= amount then
			return nil
		end
	end
	
	CraftingHandler.PerformCraft(recipe, inventory)
	return true
end

function CraftingHandler.GetCraftableItems(inventory)
	local craftables = {}
	for _, recipe in pairs(CraftingHandler.Recipes) do
		local neededItems = recipe.ItemsRequired
		local canCraft = true
	
		for itemNeeded, amount in pairs(neededItems) do
			local removed = 0
			for inventorySlot, item in pairs(inventory.Slots) do
				if item.name == itemNeeded then
					removed = removed + 1
				end
				if removed == amount then
					break
				end
			end
			if removed ~= amount then
				canCraft = false
				break
			end
		end
		if canCraft then
			table.insert(craftables, recipe)
		end
	end
	
	return craftables
end

function CraftingHandler.GetRecipeCraftPotential(recipe, inventory)
	local neededItems = recipe.ItemsRequired
	
	local craftCount = 1	
	
	while craftCount < 200 do
		for itemNeeded, amount in pairs(neededItems) do
			local removed = 0
			for inventorySlot, item in pairs(inventory.Slots) do
				if item.name == itemNeeded then
					removed = removed + 1
				end
				if removed == amount * craftCount then
					break
				end
			end
			if removed ~= amount * craftCount then
				return craftCount - 1
			end
		end
		craftCount = craftCount + 1
	end
	
	warn("Damn you have a lot of items")
	return 200
end

function CraftingHandler:DisplayCraftingMenu(inventory)
	self.container                           = Instance.new("ScrollingFrame", CameraHandler:GetContainer().Parent)
	self.container.Size                      = UDim2.new(0.25, 0, 0.7, 0)
	self.container.Position                  = UDim2.new(0.5, 0, 0.15, 0)
	self.container.BackgroundTransparency    = 0.7
	self.container.BorderSizePixel           = 5
	self.container.ZIndex                    = 8
	
	self.info                                = Instance.new("Frame", CameraHandler:GetContainer().Parent)
	self.info.Size                           = UDim2.new(0.25, 0, 0.7, 0)
	self.info.Position                       = UDim2.new(0.25, 0, 0.15, 0)
	self.info.BackgroundTransparency         = 0.7
	self.info.BorderSizePixel                = 5
	self.info.ZIndex                         = 8
	
	self.requireLabel                        = Instance.new("TextLabel", self.info)
	self.requireLabel.Size                   = UDim2.new(1,0,0,32)
	self.requireLabel.Position               = UDim2.new(0,5,0,0)
	self.requireLabel.BackgroundTransparency = 1
	self.requireLabel.Text                   = "Required items"
	self.requireLabel.ZIndex                 = 8
	self.requireLabel.TextColor3             = Color3.new(1,1,1)
	self.requireLabel.TextStrokeColor3       = Color3.new(0,0,0)
	self.requireLabel.TextStrokeTransparency = 0.5
	self.requireLabel.TextXAlignment         = "Left"
	self.requireLabel.FontSize               = "Size12"
	
	self.requireList                         = Instance.new("ScrollingFrame", self.info)
	self.requireList.Size                    = UDim2.new(1, -11, 0, 100)
	self.requireList.Position                = UDim2.new(0, 5, 0, 37)
	self.requireList.BackgroundTransparency  = 0.5
	self.requireList.BackgroundColor3        = Color3.new(0,0,0)
	self.requireList.BorderSizePixel         = 3
	self.requireList.ZIndex                  = 8 
	
	self.outputLabel                         = Instance.new("TextLabel", self.info)
	self.outputLabel.Size                    = UDim2.new(1,0,0,32)
	self.outputLabel.Position                = UDim2.new(0,5,0,142)
	self.outputLabel.BackgroundTransparency  = 1
	self.outputLabel.Text                    = "Items recieved"
	self.outputLabel.ZIndex                  = 8
	self.outputLabel.TextColor3              = Color3.new(1,1,1)
	self.outputLabel.TextStrokeColor3        = Color3.new(0,0,0)
	self.outputLabel.TextStrokeTransparency  = 0.5
	self.outputLabel.TextXAlignment          = "Left"
	self.outputLabel.FontSize                = "Size12"
	
	self.outputList                          = Instance.new("ScrollingFrame", self.info)
	self.outputList.Size                     = UDim2.new(1, -11, 0, 100)
	self.outputList.Position                 = UDim2.new(0, 5, 0, 179)
	self.outputList.BackgroundTransparency   = 0.5
	self.outputList.BackgroundColor3         = Color3.new(0,0,0)
	self.outputList.BorderSizePixel          = 3
	self.outputList.ZIndex                   = 8 
	
	self.infoLabel                           = Instance.new("TextLabel", self.info)
	self.infoLabel.Size                      = UDim2.new(1,0,0,32)
	self.infoLabel.Position                  = UDim2.new(0,5,0,284)
	self.infoLabel.BackgroundTransparency    = 1
	self.infoLabel.Text                      = "Item info"
	self.infoLabel.ZIndex                    = 8
	self.infoLabel.TextColor3                = Color3.new(1,1,1)
	self.infoLabel.TextStrokeColor3          = Color3.new(0,0,0)
	self.infoLabel.TextStrokeTransparency    = 0.5
	self.infoLabel.TextXAlignment            = "Left"
	self.infoLabel.FontSize                  = "Size12"
	
	self.infoList                            = Instance.new("ScrollingFrame", self.info)
	self.infoList.Size                       = UDim2.new(1, -11, 0, 100)
	self.infoList.Position                   = UDim2.new(0, 5, 0, 321)
	self.infoList.BackgroundTransparency     = 0.5
	self.infoList.BackgroundColor3           = Color3.new(0,0,0)
	self.infoList.BorderSizePixel            = 3
	self.infoList.ZIndex                     = 8 
	
	self.totalCraft                          = Instance.new("TextButton", self.info)
	self.totalCraft.Size                     = UDim2.new(0.5,0,0,64)
	self.totalCraft.Position                 = UDim2.new(0.25,0,1,-80)
	self.totalCraft.BackgroundTransparency   = 0.5
	self.totalCraft.BackgroundColor3         = Color3.new(0,1,0)
	self.totalCraft.Text                     = ""
	self.totalCraft.ZIndex                   = 8
	self.totalCraft.TextColor3               = Color3.new(1,1,1)
	self.totalCraft.TextStrokeColor3         = Color3.new(0,0,0)
	self.totalCraft.TextStrokeTransparency   = 0.5
	self.totalCraft.FontSize                 = "Size12"
	self.totalCraft.BorderSizePixel          = 5
	
	self.totalCraftIncrease                  = Instance.new("TextButton", self.totalCraft)
	self.totalCraftIncrease.Size             = UDim2.new(0,10,0,10)
	self.totalCraftIncrease.Position         = UDim2.new(1, 15, 0.5, -5)
	self.totalCraftIncrease.Text             = "+"
	self.totalCraftIncrease.ZIndex           = 8
	self.totalCraftIncrease.TextColor3       = Color3.new(1,1,1)
	self.totalCraftIncrease.TextStrokeColor3 = Color3.new(0,0,0)
	self.totalCraftIncrease.TextStrokeTransparency = 0.5
	self.totalCraftIncrease.FontSize         = "Size24"
	self.totalCraftIncrease.BackgroundTransparency = 1
	
	self.totalCraftDecrease                  = Instance.new("TextButton", self.totalCraft)
	self.totalCraftDecrease.Size             = UDim2.new(0,10,0,10)
	self.totalCraftDecrease.Position         = UDim2.new(0, -25, 0.5, -5)
	self.totalCraftDecrease.Text             = "-"
	self.totalCraftDecrease.ZIndex           = 8
	self.totalCraftDecrease.TextColor3       = Color3.new(1,1,1)
	self.totalCraftDecrease.TextStrokeColor3 = Color3.new(0,0,0)
	self.totalCraftDecrease.TextStrokeTransparency = 0.5
	self.totalCraftDecrease.FontSize         = "Size24"
	self.totalCraftDecrease.BackgroundTransparency = 1
	
	local craftableItem                      = Instance.new("Frame")
	craftableItem.Size                       = UDim2.new(1,0,0,32)
	craftableItem.ZIndex                     = 8
	craftableItem.BackgroundColor3           = Color3.new(0,0,0)
	craftableItem.BackgroundTransparency     = 0.5
	craftableItem.BorderSizePixel            = 3
	
	local image                              = Instance.new("ImageLabel", craftableItem)
	image.Name                               = "image"
	image.Size                               = UDim2.new(0,32,0,32)
	image.ZIndex                             = 8
	image.Position                           = UDim2.new(0,4,0,0)
	image.BackgroundTransparency             = 1
	
	local text                               = Instance.new("TextButton", craftableItem)
	text.Name                                = "text"
	text.Size                                = UDim2.new(1, -36, 1, 0)
	text.ZIndex                              = 8
	text.Position                            = UDim2.new(0,44,0,0)
	text.BackgroundTransparency              = 1
	text.TextColor3                          = Color3.new(1,1,1)
	text.TextStrokeColor3                    = Color3.new(0,0,0)
	text.TextStrokeTransparency              = 0.5
	text.TextXAlignment                      = "Left"
	text.FontSize                            = "Size12"
	
	local it = 0	
	
	for _, v in pairs(self.GetCraftableItems(inventory)) do
		local output  = v.Output
		for item, num in pairs(output) do
			local craft       = craftableItem:Clone()
			craft.Parent      = self.container
			craft.Position    = UDim2.new(0,0,0,it*35)
			craft.image.Image = "rbxassetid://" .. Item.Items[item].new():GetRenderImageId()
			craft.text.Text   = item .. " (" .. num .. " per craft)"
			
			craft.text.MouseButton1Click:connect(function()
				CraftingHandler:DisplayRecipeInfo(v, inventory)
			end)		
			
			it = it + 1
		end
	end
end

function CraftingHandler:HideCraftingMenu()
	if self.container then
		self.container:Destroy()
		self.container = nil
	end
	if self.info then
		self.info:Destroy()
		self.info = nil
	end
end

function CraftingHandler:ToggleCraftingMenu(inventory)
	if self.container or self.ino then
		self:HideCraftingMenu()
	else
		self:DisplayCraftingMenu(inventory)
	end
end

function CraftingHandler:DisplayRecipeInfo(recipe, inventory)
	if self.info then
		
		if self.totalCraftConnection then
			self.totalCraftConnection:disconnect()
		end
		
		if breakloop then
			breakloop()
		end
		
		local craftableItem                	 = Instance.new("Frame")
		craftableItem.Size                   = UDim2.new(1,0,0,32)
		craftableItem.ZIndex                 = 8
		craftableItem.BackgroundColor3       = Color3.new(0,0,0)
		craftableItem.BackgroundTransparency = 0.5
		craftableItem.BorderSizePixel            = 3
		
		local image                          = Instance.new("ImageLabel", craftableItem)
		image.Name                           = "image"
		image.Size                           = UDim2.new(0,32,0,32)
		image.ZIndex                         = 8
		image.Position                       = UDim2.new(0,4,0,0)
		image.BackgroundTransparency         = 1
		
		local text                           = Instance.new("TextButton", craftableItem)
		text.Name                            = "text"
		text.Size                            = UDim2.new(1, -36, 1, 0)
		text.ZIndex                          = 8
		text.Position                        = UDim2.new(0,44,0,0)
		text.BackgroundTransparency          = 1
		text.TextColor3                      = Color3.new(1,1,1)
		text.TextStrokeColor3                = Color3.new(0,0,0)
		text.TextStrokeTransparency          = 0.5
		text.TextXAlignment                  = "Left"
		text.FontSize                        = "Size12"
		
		local it = 0		
		
		it = 0		
		
		for _, v in pairs(self.requireList:GetChildren()) do
			v:Destroy()
		end		
		
		for item, i in pairs(recipe.ItemsRequired) do
			local craft       = craftableItem:Clone()
			craft.Parent      = self.requireList
			craft.Position    = UDim2.new(0,0,0,it*35)
			craft.image.Image = "rbxassetid://" .. Item.Items[item].new():GetRenderImageId()
			craft.text.Text   = i .. " x " .. item
			it = it +1
		end
		
		it = 0		
		
		for _, v in pairs(self.outputList:GetChildren()) do
			v:Destroy()
		end		
		
		for item, i in pairs(recipe.Output) do
			local craft       = craftableItem:Clone()
			craft.Parent      = self.outputList
			craft.Position    = UDim2.new(0,0,0,it*35)
			craft.image.Image = "rbxassetid://" .. Item.Items[item].new():GetRenderImageId()
			craft.text.Text   = i .. " x " .. item
			it = it +1
		end
		
		it = 0		
		
		for _, v in pairs(self.infoList:GetChildren()) do
			v:Destroy()
		end		
		
		for item, i in pairs(recipe.Output) do
			local itemInst    = Item.Items[item].new()
			local craft       = craftableItem:Clone()
			craft.Parent      = self.infoList
			craft.Position    = UDim2.new(0,0,0,it*35)
			craft.image.Image = "rbxassetid://" .. itemInst:GetRenderImageId()
			craft.text.Text   = itemInst:GetInfo()
			it = it +1
		end
		
		local craftCount = 1		
		local changer = 0
		local crafting
		local potential = CraftingHandler.GetRecipeCraftPotential(recipe, inventory)
		self.totalCraft.Text = "Craft " .. craftCount .. "/" .. potential .. " times"
		
		spawn(function()
			while wait(0.1) and not crafting do
				craftCount = math.min(math.max(craftCount + changer, 1), potential)
				self.totalCraft.Text = "Craft " .. craftCount .. "/" .. potential .. " times"
				breakloop = (function() crafting = true end)
			end	
		end)
		
		self.totalCraftIncrease.MouseButton1Down:connect(function()
			changer = 1
		end)
		
		self.totalCraftDecrease.MouseButton1Down:connect(function()
			changer = -1
		end)
		
		self.totalCraftIncrease.MouseButton1Up:connect(function()
			changer = 0
		end)
		
		self.totalCraftDecrease.MouseButton1Up:connect(function()
			changer = 0
		end)
		
		self.totalCraftConnection = self.totalCraft.MouseButton1Click:connect(function()
			crafting = true
			for i = 1, craftCount do
				wait()			
				CraftingHandler.AttemptCraft(recipe, inventory)
				self.totalCraft.Text = "Craft " .. craftCount - i .. "/" .. potential .. " items"
			end
			CraftingHandler:HideCraftingMenu()
			CraftingHandler:DisplayCraftingMenu(inventory)
		end)
		
	end
end

return CraftingHandler