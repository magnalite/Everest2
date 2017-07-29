BaseObject = {}
BaseObject.__index = BaseObject

httpService = game:GetService("HttpService")

function BaseObject.new()
	local new = {}
	setmetatable(new, BaseObject)
	
	new.Guid = httpService:GenerateGUID()
	--new.GuidTableId = #_G.Objects + 1	
	
	--table.insert(_G.Objects, new)
	_G.Objects[new.Guid] = new
	
	return new
end

function BaseObject.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "BaseObject"
	end
	
	dataTable.Guid = self.Guid
	
	return dataTable
end

function BaseObject:EnforceGuid(guid)
	_G.Objects[self.Guid] = nil
	self.Guid = guid
	_G.Objects[guid] = self
end

function BaseObject:GetGuid()
	return self.Guid
end

return BaseObject