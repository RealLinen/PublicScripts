local RunService = game:GetService("RunService")
local isver = getfenv().isver or loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))();
local LoopModule = { ["isver"] = isver }
local ThisData = { ["Running"] = {} }
---------------------------------------------
task.spawn(function()
    while task.wait() and isver() do
        for i,v in pairs(LoopModule) do
            if type(i)=="number" and type(v)=="function" then
                local suc,err = pcall(task.spawn, v)
                if not suc then warn(string.format("(%s) [ LoopModule -> Error ]:\n%s", i, err)) end
            end
        end
    end
end)
---------------------------------------------
setmetatable(LoopModule, {
    __call = function(tb, func, customM)
        customM = (type(customM)=="string" or type(customM)=="number") and customM or (#LoopModule+1)
        if type(func)=="function" then
            LoopModule[customM] = func
            return customM
        end
    end
})
-----------------------
return LoopModule
