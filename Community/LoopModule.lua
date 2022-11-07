local RunService = game:GetService("RunService")
local isver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))();
local LoopModule = { ["isver"] = isver }
local ThisData = { ["Running"] = {} }
local Calling = 1
local Heartbeat = RunService.Heartbeat:Connect(function(deltaTime, ...)
    if not isver() then return; end
    if type(Calling)~="number" then return; end
    local func = LoopModule[Calling]
    local oldCalling = Calling
    if type(func)~="function" then Calling = 1;return true end;Calling = Calling + 1
    local suc,err = pcall(func, deltaTime, ...);if not suc then warn(string.format("LoopModule Function #%s Errored:\n%s", oldCalling, err)); end;
end)
setmetatable(LoopModule, {
    __call = function(tb, func)
        if type(func)=="function" then
            local newInt = #LoopModule+1
            LoopModule[newInt] = func
            return newInt
        end
    end
})
-----------------------
task.delay(0, function()
    repeat task.wait() until Heartbeat and not isver()
    pcall(function()
        Heartbeat:Disconnect()
        Heartbeat:Unconnect()
        Heartbeat:Remove()
    end)
end)

return LoopModule
