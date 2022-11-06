local RunService = game:GetService("RunService")
local isver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))();
local LoopModule = { ["isver"] = isver }
local Calling = 1
local Heartbeat = RunService.Heartbeat:Connect(function(deltaTime, ...)
    if not isver() then return; end
    if type(Calling)~="number" then return; end
    local func = LoopModule[Calling]
    if type(func)~="function" then Calling = 1;return true end;Calling = Calling + 1
    pcall(func, deltaTime, ...)
end)
setmetatable(LoopModule, {
    __call = function(tb, func)
        if type(func)=="function" then
            LoopModule[#LoopModule+1] = func
        end
    end
})
task.spawn(function()
    if not isver() and Heartbeat then
        pcall(function()
            Heartbeat:Disconnect()
            Heartbeat:Unconnect()
            Heartbeat:Remove()
        end)
    end;return true
end)
-----------------------
return LoopModule
