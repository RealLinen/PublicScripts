local AimbotModule = { Credits = "Linen#3485" }
--=================== LOAD
AimbotModule.Camera = workspace.CurrentCamera
AimbotModule.mousemove = mousemoveabs
AimbotModule.SetPart = function(p: Instance)
    AimbotModule.__Part = p
end
AimbotModule.LockToPart = function(part: Instance, seconds: number)
    repeat task.wait() until not AimbotModule.Locking
    part = typeof(part)=="Instance" and part or typeof(AimbotModule.__Part)=="Instance" and AimbotModule.__Part or nil;if not part then return; end
    seconds = typeof(seconds)=="number" and seconds or 1

    AimbotModule.Locking = true;
    local finished = false;task.delay(seconds+.1, function() finished = true end)
    while task.wait() and not finished do
        local screenVec, onScreen = AimbotModule.Camera:WorldToViewportPoint(part.Position)
        if onScreen then
            AimbotModule.mousemove(screenVec.X, screenVec.Y)
        end
    end
    AimbotModule.Locking = false;
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
