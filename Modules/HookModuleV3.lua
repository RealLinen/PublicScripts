local isver = getfenv().isver or loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
--========================================================--
local function resetHookMethod(v)
    local suc, msg = pcall(function() return restorefunction(getrawmetatable(game)[v]) end)
    if suc then return true end;return false, msg
end
local function InstallizeTable(tb) 
    if type(tb)~="table" then return; end
    function tb:new(func, custom)
        custom = (type(custom)=="string" or type(custom)=="number") and custom or #tb+1
        tb[custom] = func
        return custom
    end
    function tb:remove(int) 
        tb[(int or #tb)] = nil
    end
end
--========================================================--
resetHookMethod("__index")
resetHookMethod("__namecall")
--========================================================--
local __index, __namecall = {}, {}
InstallizeTable(__index)
InstallizeTable(__namecall)
--========================================================--
local old__index, old__namecall;
old__namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local called;
    local DataTable = {
        ["checkcaller"] = checkcaller, 
        ["getcallingscript"] = getcallingscript, 
        ["returning"] = function(...) return old__namecall(...); end,
        ["namecallmethod"] = type(getnamecallmethod)=="function" and getnamecallmethod() or nil
    };if not isver() then return old__namecall(...) end
    for i,v in pairs(__index) do
        if (type(i)=="number" or type(i)=="string") and type(v)=="function" then
            called = {v(DataTable, ...)}
            if called[1]=="__nil" then called = { "__nil" };break; end
            if called[1] then break; end
        end
    end;
    called = type(called)=="table" and called or {}
    if called[1]=="__nil" then return nil; end
    local found = unpack(called)
    if found==nil then return old__namecall(...) end
    return found
end))
--========================================================--
--[[
local HookModuleV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Modules/HookModuleV3.lua"))()
-- Anti_kick example
HookModuleV3["__namecall"]:new(function(data, Self, ...)
    local checkcaller, getcallingscript, namecallmethod = data["checkcaller"], data["getcallingscript"], data["namecallmethod"]
    if not namecallmethod then return; end
    if (namecallmethod=="Kick" or namecallmethod=="kick") and Self==game:GetService("Players").LocalPlayer then
        return "__nil"
    end
end)
]]
--========================================================--
return { ["__index"] = __index, ["__namecall"] = __namecall, ["isver"] = isver, ["Creator"] = "Linen#3485" }
