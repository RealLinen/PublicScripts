local toConvert = {
    Table = {
        "getgenv"
    },
    Funcs = {
        ["reg"] = getloadedmodules, -- For Synapse V3
        ["getreg"] = getgc -- turns getreg into getgc
    }
}
-----------------------------
local global = getgenv and getgenv() or getfenv and getfenv() or {}
for i,v in pairs(toConvert.Table) do
    local obj = global[v]
    if type(obj)=="function" then obj() end
    if type(obj)~="table" then continue; end
    for a,b in pairs(toConvert.Funcs) do
        pcall(function()obj[a] = b;end)
    end
end
for i,v in pairs(toConvert.Funcs) do
    pcall(function()global[i] = v;end)
end
return global -- Linen#3485, although credits don't matter
--[[
    This just replaces the functions that used to be tables but are now 'userdata' [ getreg is the only one I know of now ]
]]
