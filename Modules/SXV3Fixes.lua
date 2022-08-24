local Misc = {
    ["getreg"] = "____________DHGJDIHBWNDJFUHEJIUFHBNJINXJHBXN!&*(#HUWBDNJIUHWBDstoredReg"
}

getgenv()[Misc.getreg] = getgenv()[Misc.getreg] or {}
getgenv()[Misc.getreg].__LinenHooked = true

local toConvert = {
    Table = {
        "getgenv"
    },
    Funcs = {
        ["loadedmodules"] = getloadedmodules or function()return getgc;end, -- For Synapse V3 User
        ["getreg"] = function()return getgenv()[Misc.getreg];end -- turns getreg into getgc
    }
}
-----------------------------
local global = getgenv and getgenv() or getfenv and getfenv() or {}
for i,v in pairs(toConvert.Table) do
    local obj = global[v]
    if type(obj)=="function" then obj() end
    if type(obj)~="table" then continue; end
    for a,b in pairs(toConvert.Funcs) do
        if obj[a]~=b then obj[a] = b end
    end
end
for i,v in pairs(toConvert.Funcs) do
    if global[i]~=v then global[i]=v end
end
return global -- Linen#3485, although credits don't matter
--[[
    This just replaces the functions that used to be tables but are now 'userdata' [ getreg is the only one I know of now ]
]]
