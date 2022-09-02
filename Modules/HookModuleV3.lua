local isver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
--========================================================--
local function resetHookMethod(v)
    local suc, msg = pcall(function() return restorefunction(getrawmetatable(game)[v]) end)
    if suc then return true end;return false, msg
end
local function InstallizeTable(tb) 
    if type(tb)~="table" then return; end
    function tb:new(self, func)
        tb[#tb+1] = func
    end
    function tb:remove(self, int) 
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
old__index = hookmetamethod(game, "__index", newcclosure(function(Self, Key, ...)
    local called;
    local DataTable = {
        ["checkcaller"] = checkcaller, 
        ["getcallingscript"] = getcallingscript, 
        ["returning"] = function(...) return old__index(Self, Key, ...); end,
        ["namecallmethod"] = type(getnamecallmethod)=="function" and getnamecallmethod() or nil
    };if not isver() then return old__index(Self, Key, ...) end
    for i,v in pairs(__index) do
        if type(i)=="number" and type(v)=="function" then
            called = {v(DataTable, Self, Key, ...)}
            if called[1] then break; end
        end
    end
    return called and unpack(called) or old__index(Self, Key, ...)
end))
old__namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local called;
    local DataTable = {
        ["checkcaller"] = checkcaller, 
        ["getcallingscript"] = getcallingscript, 
        ["returning"] = function(...) return old__namecall(...); end,
        ["namecallmethod"] = type(getnamecallmethod)=="function" and getnamecallmethod() or nil
    };if not isver() then return old__namecall(...) end
    for i,v in pairs(__index) do
        if type(i)=="number" and type(v)=="function" then
            called = {v(DataTable, ...)}
            if called[1] then break; end
        end
    end
    return called and unpack(called) or old__namecall(...)
end))
--========================================================--
return { ["__index"] = __index, ["__namecall"] = __namecall, ["isver"] = isver }
