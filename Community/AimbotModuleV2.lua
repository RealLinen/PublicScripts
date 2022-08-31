local AimbotModule = { Credits = "Linen#3485" }
--=================== LOAD
AimbotModule.Camera = workspace.CurrentCamera
AimbotModule.mousemove = mousemoveabs
AimbotModule.SetPart = function(p: Instance)
    AimbotModule.__Part = p
end
AimbotModule.LockToPart = function(part--[[ the part you want to lock on/Instance ]], seconds--[[ seconds it should lock on the player for ]], cam--[[If you want the mouse to move onto the target]])
return ({pcall(function()
    repeat task.wait() until not AimbotModule.Locking
    part = typeof(part)=="Instance" and part or typeof(AimbotModule.__Part)=="Instance" and AimbotModule.__Part or nil;if not part then return; end
    seconds = typeof(seconds)=="number" and seconds or nil

    AimbotModule.Locking = true;
    local finished = false;task.delay(seconds+.1, function() finished = true end)
    if seconds then
        while task.wait() and not finished do
            local screenVec, onScreen = AimbotModule.Camera:WorldToViewportPoint(part.Position)
            AimbotModule.Camera.CFrame = CFrame.new(AimbotModule.Camera.CFrame.Position, (part.CFrame and part.CFrame.Position or part.Position))
            if cam then
                AimbotModule.mousemove(screenVec.X, screenVec.Y) 
            end
        end
    else
        local screenVec, onScreen = AimbotModule.Camera:WorldToViewportPoint(part.Position)
        AimbotModule.Camera.CFrame = CFrame.new(AimbotModule.Camera.CFrame.Position, (part.CFrame and part.CFrame.Position or part.Position))
        if cam then
            AimbotModule.mousemove(screenVec.X, screenVec.Y) 
        end
    end
    AimbotModule.Locking = false;    
end)})[2]
end
--===================--
--[[
    AimbotModule.SetPart: function(part)
    AimbotModule.LockToPart: function(part, seconds) -- Amount of seconds to lock onto that part
]]
--[[ Usage:
           AimbotModule.LockToPart(workspace.Baseplate, 3) -- Locks onto Baseplate for 3 secondss [ If its in view ]
]]
return AimbotModule
