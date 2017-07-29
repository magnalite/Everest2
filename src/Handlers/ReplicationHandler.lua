ReplicationHandler = {}

local dataBuffer = {}

function ReplicationHandler.Push(data)
	dataBuffer[data.Guid] = data
end

function ReplicationHandler.DeleteEntity(Guid)
	dataBuffer[Guid] = {Guid = Guid, Delete = true}
end

function ReplicationHandler.ReferencePush(entity)
	delay(0, function()
		if entity then
			ReplicationHandler.Push(entity:Serialize())
		end
	end)
end

function ReplicationHandler.Replicate()
	for i, v in pairs(dataBuffer) do
		Workspace.Replicator:FireServer(v)
		dataBuffer[i] = nil
	end
end

function ReplicationHandler.ReplicateServer()
	for i, v in pairs(dataBuffer) do
		Workspace.Replicator:FireAllClients(v)
		dataBuffer[i] = nil
	end
end

function ReplicationHandler.DataHandle(data)
	if not data.Delete then
		if _G.Objects[data.Guid] then
			--print("Deserializing", data.Type)
			_G.Objects[data.Guid]:DeSerialize(data)
		else
			print("Instancing new " .. data.Type)
			local newEntity = require(_G.Everest:FindFirstChild(data.Type, true)).newReplication(data)
			newEntity:EnforceGuid(data.Guid)
			_G.Map:AddEntity(newEntity)
		end
	else
		if _G.Objects[data.Guid] then
			print("Destorying", _G.Objects[data.Guid].Type)
			_G.Objects[data.Guid]:Destroy()
		end
	end
end

if not _G.Server then
	coroutine.wrap(function()
		repeat wait() until _G.StartupComplete
		Workspace.Replicator.OnClientEvent:connect(ReplicationHandler.DataHandle)
	end)()
end

return ReplicationHandler